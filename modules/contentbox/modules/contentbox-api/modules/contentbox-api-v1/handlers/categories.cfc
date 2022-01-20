/**
 * RESTFul CRUD for Site Categories
 * An incoming site identifier is required
 */
component extends="baseHandler" {

	// DI
	property name="ormService" inject="CategoryService@contentbox";

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
	 * @tags Categories
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
	 * Show a category using the id or slug
	 *
	 * @tags Categories
	 */
	function show( event, rc, prc ){
		param rc.includes = "NumberOfPublishedPages,numberOfPublishedContentStore,numberOfPublishedEntries";
		param rc.excludes = "";

		super.show( argumentCollection = arguments );
	}

	/**
	 * Create a category
	 *
	 * @tags Categories
	 * @x    -contentbox-permissions CATEGORIES_ADMIN
	 */
	function create( event, rc, prc ) secured="CATEGORIES_ADMIN"{
		super.create( argumentCollection = arguments );
	}

	/**
	 * Update an existing category
	 *
	 * @tags Categories
	 * @x    -contentbox-permissions CATEGORIES_ADMIN
	 */
	function update( event, rc, prc ) secured="CATEGORIES_ADMIN"{
		super.update( argumentCollection = arguments );
	}

	/**
	 * Delete a category using an id or slug
	 *
	 * @tags Categories
	 * @x    -contentbox-permissions CATEGORIES_ADMIN
	 */
	function delete( event, rc, prc ) secured="CATEGORIES_ADMIN"{
		super.delete( argumentCollection = arguments );
	}

}
