/**
 * RESTFul CRUD for Authors
 * Only tokens with the `AUTHOR_ADMIN` can interact with this endpoint
 */
component extends="baseHandler" secured="AUTHOR_ADMIN" {

	// DI
	property name="ormService" inject="AuthorService@contentbox";
	property name="roleService" inject="roleService@contentbox";
	property name="permissionService" inject="permissionService@contentbox";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder    = "lastName";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity       = "Author";
	// Use getOrFail() or getByIdOrSlugOrFail() for show/delete/update actions
	variables.useGetOrFail = true;

	/**
	 * Display all authors according to query options
	 *
	 * @tags                     Authors
	 * @responses                contentbox/apidocs/authors/index/responses.json
	 * @x-contentbox-permissions AUTHOR_ADMIN
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
	 * @tags                     Authors
	 * @responses                contentbox/apidocs/authors/show/responses.json
	 * @x-contentbox-permissions AUTHOR_ADMIN
	 */
	function show( event, rc, prc ){
		param rc.includes       = "permissions,permissionGroups,role.permissions";
		param rc.excludes       = "role.permissions.createdDate,role.permissions.modifiedDate";
		param rc.ignoreDefaults = false;
		param rc.id             = 0;

		super.show( argumentCollection = arguments );
	}

	/**
	 * Create an author in ContentBox
	 *
	 * @tags        Authors
	 * @requestBody contentbox/apidocs/authors/create/requestBody.json
	 * @responses   contentbox/apidocs/authors/create/responses.json
	 * @x           -contentbox-permissions AUTHOR_ADMIN
	 */
	function create( event, rc, prc ){
		// Default set variables for the author
		rc.isPasswordRest = true;
		rc.password       = hash( createUUID() & now() );
		rc.isActive       = true;

		// Super size me!
		arguments.saveMethod = "createNewAuthor";
		super.create( argumentCollection = arguments );
	}

	/**
	 * Update an existing author
	 *
	 * @tags                     Authors
	 * @responses                contentbox/apidocs/authors/update/responses.json
	 * @x-contentbox-permissions AUTHOR_ADMIN
	 */
	function update( event, rc, prc ){
		// Memento output
		param rc.includes = "permissions,permissionGroups,role.permissions";

		// Can't update everything via the API.
		arguments.populate.exclude          = "username,password,pages,entries,is2FactorAuth,isPasswordReset,lastLogin";
		arguments.populate.nullEmptyInclude = "";

		// Super size it!
		super.update( argumentCollection = arguments );
	}

	/**
	 * Delete an author using an id
	 *
	 * @tags                     Authors
	 * @responses                contentbox/apidocs/authors/delete/responses.json
	 * @x-contentbox-permissions AUTHOR_ADMIN
	 */
	function delete( event, rc, prc ){
		super.delete( argumentCollection = arguments );
	}

}
