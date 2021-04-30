/**
 * RESTFul CRUD for Site Categories
 * An incoming site identifier is required
 */
component extends="baseHandler" {

	// DI
	property name="ormService" inject="CategoryService@cb";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder    = "slug";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity       = "Category";
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
	 * Display all categories
	 *
	 * @override
	 */
	function index( event, rc, prc ){
		// Criterias and Filters
		param rc.sortOrder = "slug";

		// Build up a search criteria and let the base execute it
		arguments.criteria = newCriteria().isEq( "site", prc.oCurrentSite );

		// Delegate it!
		super.index( argumentCollection = arguments );
	}

	/**
	 * Show a category using the id
	 *
	 * @override
	 */
	function show( event, rc, prc ){
		param rc.includes = "NumberOfPublishedPages,numberOfPublishedContentStore,numberOfPublishedEntries";
		param rc.excludes = "";

		super.show( argumentCollection = arguments );
	}

}
