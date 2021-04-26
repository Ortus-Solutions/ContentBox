/**
 * Manage permissions
 */
component extends="BaseHandler" {

	// DI
	property name="ormService" inject="PermissionService@cb";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder = "permission";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity    = "Permission";

	/**
	 * Display all permissions
	 * GET /cbapi/v1/permissions
	 *
	 * @override
	 */
	function index( event, rc, prc ){
		// Criterias and Filters
		param rc.search    = "";
		param rc.sortOrder = "permission";

		// Build up a search criteria and let the base execute it
		arguments.criteria = newCriteria().when( len( rc.search ), function( c ){
			c.like( "permission", "%#rc.search#%" )
		} );

		// Delegate it!
		super.index( argumentCollection = arguments );
	}

}
