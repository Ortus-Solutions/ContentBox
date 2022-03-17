/**
 * RESTFul CRUD for Sites
 */
component extends="baseHandler" secured="SITES_ADMIN" {

	// DI
	property name="ormService" inject="SiteService@contentbox";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder    = "slug";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity       = "Site";
	// Use getOrFail() or getByIdOrSlugOrFail() for show/delete/update actions
	variables.useGetOrFail = false;

	/**
	 * Display all sites
	 *
	 * @tags Sites
	 * @x    -contentbox-permissions SITES_ADMIN
	 */
	function index( event, rc, prc ){
		// Criterias and Filters
		param rc.sortOrder = "slug";
		param rc.search    = "";
		param rc.isActive  = true;

		// Make sure isActive is boolean
		if ( !isBoolean( rc.isActive ) ) {
			rc.isActive = true;
		}

		// Build up a search criteria and let the base execute it
		arguments.criteria = newCriteria()
			// Active filter
			.isEq( "isActive", javacast( "boolean", rc.isActive ) )
			// Search filter
			.when( len( rc.search ), function( c ){
				c.$or(
					c.restrictions.like( "name", "%#rc.search#%" ),
					c.restrictions.like( "description", "%#rc.search#%" )
				);
			} );

		// Delegate it!
		super.index( argumentCollection = arguments );
	}

	/**
	 * Show a site using the id
	 *
	 * @tags Sites
	 * @x    -contentbox-permissions SITES_ADMIN
	 */
	function show( event, rc, prc ){
		super.show( argumentCollection = arguments );
	}

	/**
	 * Create a site
	 *
	 * @tags Sites
	 * @x    -contentbox-permissions SITES_ADMIN
	 */
	function create( event, rc, prc ){
		// Supersize it
		super.create( argumentCollection = arguments );
	}

	/**
	 * Update an existing site
	 *
	 * @tags Sites
	 * @x    -contentbox-permissions SITES_ADMIN
	 */
	function update( event, rc, prc ){
		// You cannot update site slugs
		arguments.populate.exclude = "slug";
		super.update( argumentCollection = arguments );
	}

	/**
	 * Delete a site using an id or slug
	 *
	 * @tags Sites
	 * @x    -contentbox-permissions SITES_ADMIN
	 */
	function delete( event, rc, prc ){
		super.delete( argumentCollection = arguments );
	}

}
