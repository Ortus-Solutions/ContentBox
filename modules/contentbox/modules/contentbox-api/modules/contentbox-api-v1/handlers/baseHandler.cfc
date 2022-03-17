/**
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
 *
 * @see https://coldbox-orm.ortusbooks.com/orm-events/automatic-rest-crud
 */
component extends="cborm.models.resources.BaseHandler" {

	// DI
	property name="settings" inject="coldbox:moduleSettings:cborm";
	property name="siteService" inject="siteService@contentbox";
	property name="cb" inject="CBHelper@contentbox";

	// Use native getOrFail() or getByIdOrSlugOrFail()
	variables.useGetOrFail = true;

	/**
	 * Display all resource records with pagination
	 * GET /api/v1/{resource}
	 *
	 * @criteria If you pass a criteria object, then we will use that instead of creating a new one
	 * @results  If you pass in a results struct, it must contain the following: { count:numeric, records: array of objects }
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

	/**
	 * Display a resource by incoming ID or slug
	 */
	function show( event, rc, prc ){
		param rc.includes       = "";
		param rc.excludes       = "";
		param rc.ignoreDefaults = false;
		param rc.id             = 0;

		// announce it
		announceInterception( "#variables.settings.resources.eventPrefix#pre#variables.entity#Show", {} );

		// Get by id or slug
		prc.oEntity = (
			variables.useGetOrFail ? variables.ormService.getOrFail( rc.id ) : getByIdOrSlugOrFail( rc.id, prc )
		);

		// announce it
		announceInterception(
			"#variables.settings.resources.eventPrefix#post#variables.entity#Show",
			{ entity : prc.oEntity }
		);

		// Marshall it
		prc.response.setData(
			prc.oEntity.getMemento(
				includes       = rc.includes,
				excludes       = rc.excludes,
				ignoreDefaults = rc.ignoreDefaults
			)
		);
	}

	/**
	 * Create a resource
	 */
	function create(
		event,
		rc,
		prc,
		struct populate   = {},
		struct validate   = {},
		string saveMethod = variables.saveMethod
	){
		super.create( argumentCollection = arguments );
	}

	/**
	 * Update a resource
	 */
	function update(
		event,
		rc,
		prc,
		struct populate   = {},
		struct validate   = {},
		string saveMethod = variables.saveMethod
	){
		param rc.includes                             = "";
		param rc.excludes                             = "";
		param rc.ignoreDefaults                       = false;
		param rc.id                                   = 0;
		param arguments.populate.composeRelationships = true;

		// Population arguments
		arguments.populate.memento = rc;
		arguments.populate.model   = (
			variables.useGetOrFail ? variables.ormService.getOrFail( rc.id ) : getByIdOrSlugOrFail( rc.id, prc )
		);

		// Validation Arguments
		arguments.validate.target = populateModel( argumentCollection = arguments.populate );

		// Validate
		prc.oEntity = validateOrFail( argumentCollection = arguments.validate );

		// announce it
		announceInterception(
			"#variables.settings.resources.eventPrefix#pre#variables.entity#Update",
			{ entity : prc.oEntity }
		);

		// Save it
		invoke(
			variables.ormService,
			arguments.saveMethod,
			[ prc.oEntity ]
		);

		// announce it
		announceInterception(
			"#variables.settings.resources.eventPrefix#post#variables.entity#Update",
			{ entity : prc.oEntity }
		);

		// Marshall it out
		prc.response.setData(
			prc.oEntity.getMemento(
				includes       = rc.includes,
				excludes       = rc.excludes,
				ignoreDefaults = rc.ignoreDefaults
			)
		);
	}

	/**
	 * Delete a resource by id or slug
	 */
	function delete(
		event,
		rc,
		prc,
		string deleteMethod = variables.deleteMethod
	){
		param rc.id = 0;

		prc.oEntity = (
			variables.useGetOrFail ? variables.ormService.getOrFail( rc.id ) : getByIdOrSlugOrFail( rc.id, prc )
		);

		// announce it
		announceInterception(
			"#variables.settings.resources.eventPrefix#pre#variables.entity#Delete",
			{ entity : prc.oEntity }
		);

		// Delete it
		invoke(
			variables.ormService,
			arguments.deleteMethod,
			[ prc.oEntity ]
		);

		// announce it
		announceInterception( "#variables.settings.resources.eventPrefix#post#variables.entity#Delete", { id : rc.id } );

		// Marshall it out
		prc.response.addMessage( "#variables.entity# deleted!" );
	}

	/**
	 * This utility tries to get the incoming resource by id or slug or fails
	 *
	 * @id  The id/slug identifier to retrieve the entity
	 * @prc The ColdBox PRC
	 *
	 * @return The found entity
	 *
	 * @throws EntityNotFound
	 */
	private function getByIdOrSlugOrFail( required id, required prc ){
		var c       = variables.ormService.newCriteria();
		var oEntity = c
			.$or(
				// note: id is a shortcut in Hibernate for the Primary Key
				c.restrictions.isEq( "id", arguments.id ),
				c.restrictions.isEq( "slug", arguments.id )
			)
			// If the site exists, seed it
			.when( !isNull( prc.oCurrentSite ), function( c ){
				c.isEq( "site", prc.oCurrentSite );
			} )
			.get();

		if ( isNull( oEntity ) ) {
			throw(
				message      = "No entity found for ID/Slug #arguments.id.toString()#",
				type         = "EntityNotFound",
				extendedinfo = variables.entity
			);
		}

		return oEntity;
	}

	/**
	 * This utility tries to get a site by id or slug
	 *
	 * @return The found site
	 *
	 * @throws EntityNotFound
	 */
	private function getSiteByIdOrSlugOrFail( required id ){
		var c     = variables.siteService.newCriteria();
		var oSite = c
			.$or(
				// note: id is a shortcut in Hibernate for the Primary Key
				c.restrictions.isEq( "id", arguments.id ),
				c.restrictions.isEq( "slug", arguments.id )
			)
			.get();

		if ( isNull( oSite ) ) {
			throw(
				message      = "No site found for ID/Slug #arguments.id.toString()#",
				type         = "EntityNotFound",
				extendedinfo = "Site"
			);
		}

		return oSite;
	}

}
