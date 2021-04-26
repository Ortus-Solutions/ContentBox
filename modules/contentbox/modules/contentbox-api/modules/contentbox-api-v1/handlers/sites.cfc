/**
 * Manage sites
 */
component extends="BaseHandler" {

	// DI
	property name="ormService" inject="SiteService@cb";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder = "slug";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity    = "Site";

	/**
	 * Display all sites
	 * GET /cbapi/v1/sites
	 *
	 * @override
	 */
	function index( event, rc, prc ){
		// Criterias and Filters
		param rc.search    = "";
		param rc.sortOrder = "slug";
		param rc.isActive  = true;

		// Build up a search criteria and let the base execute it
		arguments.criteria = newCriteria()
			.isEq( "isActive", autoCast( "isActive", rc.isActive ) )
			.when( len( rc.search ), function( c ){
				c.$or( c.like( "name", "%#rc.search#%" ), c.like( "description", "%#rc.search#%" ) )
			} );

		// Delegate it!
		super.index( argumentCollection = arguments );
	}

}
