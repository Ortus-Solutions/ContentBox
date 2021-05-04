/**
 * RESTFul CRUD for Content Versions
 */
component extends="baseHandler" {

	// DI
	property name="ormService" inject="contentVersionService@cb";
	property name="contentService" inject="contentService@cb";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder    = "version DESC";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity       = "ContentVersion";
	// Use getOrFail() or getByIdOrSlugOrFail() for show/delete/update actions
	variables.useGetOrFail = true;

	/**
	 * Executes before all handler actions
	 */
	any function preHandler( event, rc, prc, action, eventArguments ){
		// Verify incoming params
		param rc.site            = "";
		param rc.contentIdOrSlug = "";

		prc.oCurrentSite    = rc.site = getSiteByIdOrSlugOrFail( rc.site );
		prc.contentType     = event.getCurrentRouteMeta().contentType;
		prc.oRelatedContent = variables.contentService.getByIdOrSlugOrFail( rc.contentIdOrSlug );
	}

	/**
	 * Display all versions for the requested contentype
	 *
	 * @override
	 */
	function index( event, rc, prc ){
		param rc.page       = 1;
		// Criterias and Filters
		param rc.sortOrder  = variables.sortOrder;
		// Approved Bit
		param rc.isApproved = "";
		// Memento Params
		param rc.includes   = "";
		param rc.excludes   = "content";

		// Boolean check is approved
		if ( len( rc.isApproved ) && !isBoolean( rc.isApproved ) ) {
			rc.isApproved = "";
		}
		// Build up a search criteria and let the base execute it
		arguments.criteria = newCriteria()
			// Pin the related content
			.isEq( "relatedContent.contentID", prc.oRelatedContent.getContentID() )
			// isApproved filter
			.when( len( rc.isApproved ), function( c ){
				arguments.c.isEq( "isApproved", javacast( "Boolean", rc.isApproved ) );
			} );

		// Delegate it!
		super.index( argumentCollection = arguments );
	}

	/**
	 * Show a content version individually
	 *
	 * @override
	 */
	function show( event, rc, prc ){
		param rc.includes = "relatedContentSnapshot:relatedContent";
		param rc.excludes = "";

		super.show( argumentCollection = arguments );
	}

}
