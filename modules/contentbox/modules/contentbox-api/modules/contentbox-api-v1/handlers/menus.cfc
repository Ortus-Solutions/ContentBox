/**
 * RESTFul CRUD for Site Menus
 *
 * An incoming site identifier is required
 */
component extends="baseHandler" {

	// DI
	property name="ormService" inject="MenuService@cb";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder    = "slug";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity       = "Menu";
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
	 * Display all menus
	 *
	 * @tags Menus
	 */
	function index( event, rc, prc ) secured="MENUS_ADMIN"{
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
	 * @tags Menus
	 */
	function show( event, rc, prc ) secured="MENUS_ADMIN"{
		param rc.includes = "rootMenuItems:menuItems";
		param rc.excludes = "";

		super.show( argumentCollection = arguments );
	}

	/**
	 * Create a menu
	 *
	 * @tags Menus
	 */
	function create( event, rc, prc ) secured="MENUS_ADMIN"{
		super.create( argumentCollection = arguments );
	}

	/**
	 * Update an existing menu
	 *
	 * @tags Menus
	 */
	function update( event, rc, prc ) secured="MENUS_ADMIN"{
		super.update( argumentCollection = arguments );
	}

	/**
	 * Delete a menu using an id or slug
	 *
	 * @tags Menus
	 */
	function delete( event, rc, prc ) secured="MENUS_ADMIN"{
		super.delete( argumentCollection = arguments );
	}

}
