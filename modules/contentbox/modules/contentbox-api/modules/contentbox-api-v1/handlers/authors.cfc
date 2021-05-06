/**
 * RESTFul CRUD for Authors
 */
component extends="baseHandler" {

	// DI
	property name="ormService" inject="AuthorService@cb";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder    = "lastName";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity       = "Author";
	// Use getOrFail() or getByIdOrSlugOrFail() for show/delete/update actions
	variables.useGetOrFail = true;

	/**
	 * Display all authors
	 */
	function index( event, rc, prc ){
		// Criterias and Filters
		param rc.sortOrder = "lastName";
		param rc.search    = "";
		param rc.isActive  = true;
		param rc.page      = 1;

		// Make sure isActive is boolean
		if ( !isBoolean( rc.isActive ) ) {
			rc.isActive = true;
		}

		// Build up a search criteria and let the base execute it
		arguments.results = variables.ormService.search(
			searchTerm = rc.search,
			isActive   = rc.isActive,
			offset     = getPageOffset( rc.page ),
			max        = getMaxRows(),
			sortOrder  = rc.sortOrder
		);

		// Build to match interface
		arguments.results.records = arguments.results.authors;

		// Delegate it!
		super.index( argumentCollection = arguments );
	}

	/**
	 * Show an author using the id
	 *
	 * @override
	 */
	function show( event, rc, prc ){
		param rc.includes       = "permissions,permissionGroups,role.permissions";
		param rc.excludes       = "role.permissions.createdDate,role.permissions.modifiedDate";
		param rc.ignoreDefaults = false;
		param rc.id             = 0;

		super.show( argumentCollection = arguments );
	}

	/**
	 * Update an author using an id
	 *
	 * @override
	 */
	function update( event, rc, prc ){
		param rc.includes = "permissions,permissionGroups,role.permissions";

		// Can't update passwords, use the password change endpoint
		arguments.populate.exclude          = "password";
		arguments.populate.nullEmptyInclude = "";

		super.update( argumentCollection = arguments );
	}

}
