/**
 * RESTFul CRUD for Entries
 */
component extends="baseHandler" {

	// DI
	property name="ormService" inject="EntryService@cb";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder    = "lastName";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity       = "Entry";
	// Use getOrFail() or getByIdOrSlugOrFail() for show/delete/update actions
	variables.useGetOrFail = false;
	// Delete method to use
	variables.deleteMethod = "deleteContent";

	/**
	 * Executes before all handler actions
	 */
	any function preHandler( event, rc, prc, action, eventArguments ){
		// Verify incoming site
		param rc.site    = "";
		prc.oCurrentSite = rc.site = getSiteByIdOrSlugOrFail( rc.site );
	}

	/**
	 * Display all entries using different filters
	 *
	 * @override
	 */
	function index( event, rc, prc ){
		param rc.page      = 1;
		// Criterias and Filters
		param rc.sortOrder = "publishedDate DESC";
		// Search terms
		param rc.search    = "";
		// One or a list of categories to filter on
		param rc.category  = "";
		// Author ID to filter on
		param rc.author    = "";

		// Build up a search criteria and let the base execute it
		arguments.results = variables.ormService.findPublishedEntries(
			searchTerm = rc.search,
			category   = rc.category,
			offset     = getPageOffset( rc.page ),
			max        = getMaxRows(),
			sortOrder  = rc.sortOrder,
			siteId     = prc.oCurrentSite.getSiteID(),
			authorID   = rc.author
		);

		// Build to match interface
		arguments.results.records = arguments.results.entries;

		// Delegate it!
		super.index( argumentCollection = arguments );
	}

	/**
	 * Show an entry using the id
	 *
	 * @override
	 */
	function show( event, rc, prc ){
		param rc.includes = arrayToList( [
			"activeContent",
			"childrenSnapshot:children",
			"customFieldsAsStruct:customFields",
			"linkedContentSnapshot",
			"relatedContentSnapshot",
			"renderedContent"
		] );
		param rc.excludes = "";

		super.show( argumentCollection = arguments );
	}

	/**
	 * Create a blog entry
	 */
	function create( event, rc, prc ){
		// params
		event
			.paramValue( "allowComments", prc.cbSiteSettings.cb_comments_enabled )
			.paramValue( "newCategories", "" )
			.paramValue( "isPublished", true )
			.paramValue( "slug", "" )
			.paramValue( "changelog", "" )
			.paramValue( "customFieldsCount", 0 )
			.paramValue( "publishedDate", now() )
			.paramValue( "publishedHour", timeFormat( rc.publishedDate, "HH" ) )
			.paramValue( "publishedMinute", timeFormat( rc.publishedDate, "mm" ) )
			.paramValue(
				"publishedTime",
				event.getValue( "publishedHour" ) & ":" & event.getValue( "publishedMinute" )
			)
			.paramValue( "expireHour", "" )
			.paramValue( "expireMinute", "" )
			.paramValue( "expireTime", "" )
			.paramValue( "content", "" )
			.paramValue( "creatorID", "" )
			.paramValue( "customFieldsCount", 0 )
			.paramValue( "relatedContentIDs", [] )
			.paramValue( "site", prc.oCurrentSite.getsiteID() );

		// Set author to logged in user and override it
		rc.creator = jwtAuth().getUser().getAuthorID();
		// Supersize it
		super.create( argumentCollection = arguments );
	}

}
