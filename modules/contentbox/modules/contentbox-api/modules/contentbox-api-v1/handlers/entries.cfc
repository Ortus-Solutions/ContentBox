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

	/**
	 * Executes before all handler actions
	 */
	any function preHandler( event, rc, prc, action, eventArguments ){
		// Verify incoming site
		param rc.site    = "";
		prc.oCurrentSite = rc.site = getSiteByIdOrSlugOrFail( rc.site );
	}

	/**
	 * Display all entries
	 *
	 * @override
	 */
	function index( event, rc, prc ){
		// Criterias and Filters
		param rc.sortOrder = "publishedDate DESC";
		param rc.page      = 1;
		param rc.search    = "";
		param rc.category  = "";
		param rc.includes  = "";
		param rc.excludes  = "";

		// Build up a search criteria and let the base execute it
		arguments.results = variables.ormService.findPublishedEntries(
			searchTerm = rc.search,
			category   = rc.category,
			offset     = getPageOffset( rc.page ),
			max        = getMaxRows(),
			sortOrder  = rc.sortOrder,
			siteId     = prc.oCurrentSite.getSiteID()
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
			"childrenSnapshot",
			"linkedContentSnapshot",
			"relatedContentSnapshot",
			"renderedContent"
		] );
		param rc.excludes = "";

		super.show( argumentCollection = arguments );
	}

}
