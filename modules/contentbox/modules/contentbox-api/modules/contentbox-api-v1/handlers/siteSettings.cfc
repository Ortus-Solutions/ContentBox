/**
 * RESTFul CRUD for Settings
 */
component extends="baseHandler" {

	// DI
	property name="ormService" inject="SettingService@cb";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder = "name";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity    = "Setting";
	// Use getOrFail() or getByIdOrSlugOrFail() for show/delete/update actions
	variables.useGetOrFail = true;

	/**
	 * Display all non-site settings
	 *
	 * @override
	 */
	function index( event, rc, prc ){
		// Criterias and Filters
		param rc.sortOrder = "name";
		param rc.search    = "";
		// An incoming site id or slug to filter on
		param rc.site = "";

		// Build up a search criteria and let the base execute it
		var c = newCriteria();
		arguments.criteria = c
			.joinTo( "site", "site" )
				.$or(
					c.restrictions.isEq( "site.siteID", rc.site ),
					c.restrictions.isEq( "site.slug", rc.site )
				);

		// Delegate it!
		super.index( argumentCollection = arguments );
	}

}
