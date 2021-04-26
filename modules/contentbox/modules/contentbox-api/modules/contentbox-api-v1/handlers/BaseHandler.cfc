/**
 * @see https://coldbox-orm.ortusbooks.com/orm-events/automatic-rest-crud
 *
 * This is our base handler for our API which is bassed off the cborm resources base handler.
 *
 * ## Pre-Requisites
 *
 * - You will be injecting Virtual Entity services
 * - Your entities need to inherit from ActiveEntity
 * - You will need to register the routes using ColdBox <code>resources()</code> method
 * - You will need mementifier active
 *
 * ## Requirements
 *
 * In order for this to work, you will create a handler that inherits from this base
 * and make sure that you inject the appropriate virtual entity service using the variable name: <code>ormService</code>
 * Also populate the variables as needed
 *
 * <pre>
 * component extends="BaseOrmResource"{
 *
 * 		// Inject the correct virtual entity service to use
 * 		property name="ormService" inject="RoleService"
 * 		property name="ormService" inject="PermissionService"
 *
 * 		// The default sorting order string: permission, name, data desc, etc.
 * 		variables.sortOrder = "";
 * 		// The name of the entity this resource handler controls. Singular name please.
 * 		variables.entity 	= "Permission";
 * }
 * </pre>
 *
 * That's it!  All resource methods: <code>index, create, show, update, delete</code> will be implemented for you.
 * You can create more actions or override them as needed.
 */
component extends="cborm.models.resources.BaseHandler" {

	/**
	 * Display all resource records with pagination
	 * GET /api/v1/{resource}
	 *
	 * @criteria If you pass a criteria object, then we will use that instead of creating a new one
	 * @results If you pass in a results struct, it must contain the following: { count:numeric, records: array of objects }
	 */
	function index( event, rc, prc, criteria, struct results ){
		param rc.page      = 1;
		param rc.isDeleted = false;

		// Add to incoming criteria our base default criterias
		if ( !isNull( arguments.criteria ) ) {
			arguments.criteria.isEq( "isDeleted", autoCast( "isDeleted", rc.isDeleted ) );
		}

		// Delegate it
		super.index( argumentCollection = arguments );
	}

}
