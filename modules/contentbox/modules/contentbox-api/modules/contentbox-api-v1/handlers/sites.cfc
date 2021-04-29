/**
 * RESTFul CRUD for Sites
 */
component extends="baseHandler" {

	// DI
	property name="ormService" inject="SiteService@cb";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder = "slug";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity    = "Site";
	// Use getOrFail() or getByIdOrSlugOrFail() for show/delete/update actions
	variables.useGetOrFail = false;

	/**
	 * Display all sites
	 *
	 * @override
	 */
	function index( event, rc, prc ){
		// Criterias and Filters
		param rc.sortOrder = "slug";
		param rc.search    = "";
		param rc.isActive  = true;

		// Build up a search criteria and let the base execute it
		arguments.criteria = newCriteria()
			// Active filter
			.isEq( "isActive", autoCast( "isActive", rc.isActive ) )
			// Search filter
			.when( len( rc.search ), function( c ){
				c.$or(
					c.restrictions.like( "name", "%#rc.search#%" ),
					c.restrictions.like( "description", "%#rc.search#%" )
				)
			} );

		// Delegate it!
		super.index( argumentCollection = arguments );
	}

}
