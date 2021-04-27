/**
 * RESTFul CRUD for Sites
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
				c.$or( c.like( "name", "%#rc.search#%" ), c.like( "description", "%#rc.search#%" ) )
			} );

		// Delegate it!
		super.index( argumentCollection = arguments );
	}

	/**
	 * Display a site by incoming ID or slug
	 */
	function show( event, rc, prc ){
		param rc.includes       = "";
		param rc.excludes       = "";
		param rc.ignoreDefaults = false;
		param rc.id             = 0;

		// announce it
		announceInterception(
			"#variables.settings.resources.eventPrefix#pre#variables.entity#Show",
			{}
		);

		// Get by id or slug
		prc.oEntity = getByIdOrSlugOrFail( rc.id );

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

}
