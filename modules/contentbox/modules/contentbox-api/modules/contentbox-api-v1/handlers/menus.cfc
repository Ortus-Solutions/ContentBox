/**
 * RESTFul CRUD for Site Menus
 *
 * An incoming site identifier is required
 */
component extends="baseHandler" secured="MENUS_ADMIN" {

	// DI
	property name="ormService" inject="MenuService@contentbox";

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
	 * @tags                     Menus
	 * @responses                contentbox/apidocs/menus/index/responses.json
	 * @x-contentbox-permissions MENUS_ADMIN
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
	 * @tags                     Menus
	 * @responses                contentbox/apidocs/menus/show/responses.json
	 * @x-contentbox-permissions MENUS_ADMIN
	 */
	function show( event, rc, prc ){
		param rc.includes = "rootMenuItems:menuItems";
		param rc.excludes = "";

		super.show( argumentCollection = arguments );
	}

	/**
	 * Create a menu
	 *
	 * @tags        Menus
	 * @requestBody contentbox/apidocs/menus/create/requestBody.json
	 * @responses   contentbox/apidocs/menus/create/responses.json
	 * @x           -contentbox-permissions MENUS_ADMIN
	 */
	function create( event, rc, prc ){
		super.create( argumentCollection = arguments );
	}

	/**
	 * Update an existing menu
	 *
	 * @tags                     Menus
	 * @responses                contentbox/apidocs/menus/update/responses.json
	 * @x-contentbox-permissions MENUS_ADMIN
	 */
	function update( event, rc, prc ){
		super.update( argumentCollection = arguments );
	}

	/**
	 * Delete a menu using an id or slug
	 *
	 * @tags                     Menus
	 * @responses                contentbox/apidocs/menus/delete/responses.json
	 * @x-contentbox-permissions MENUS_ADMIN
	 */
	function delete( event, rc, prc ){
		super.delete( argumentCollection = arguments );
	}

}
