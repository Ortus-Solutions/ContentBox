/**
 * RESTFul CRUD for Site relocations
 * An incoming site identifier is required
 */
component extends="baseHandler" secured="PAGES_ADMIN,PAGES_EDITOR"{

	// DI
	property name="ormService" inject="RelocationService@contentbox";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder    = "slug";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity       = "Relocation";
	// Use getOrFail() or getByIdOrSlugOrFail() for show/delete/update actions
	variables.useGetOrFail = false;

	/**
	 * Executes before all handler actions
	 */
	any function preHandler( event, rc, prc, action, eventArguments ){
		// Verify incoming site
		param rc.site    = "";
		prc.oCurrentSite = rc.site = getSiteByIdOrSlugOrFail( rc.site );
	}

	/**
	 * Display all relocations
	 *
	 * @tags      relocations
	 * @responses contentbox/apidocs/relocations/index/responses.json
	 */
	function index( event, rc, prc ){
		// Criterias and Filters
		param rc.sortOrder = "slug";
		param rc.search = "";

		// Build up a search criteria and let the base execute it
		arguments.criteria = newCriteria().isEq( "site", prc.oCurrentSite );
		// Search Criteria
		arguments.criteria.when( len( rc.search ), function( c ){
			c.like( "slug", "%#search#%" );
		} )
		// Content ID filter
		.when( !isNull( rc.contentID ), function( c ){
			c.isEq( "relatedContent.contentID", rc.contentID );
		} );

		// Delegate it!
		super.index( argumentCollection = arguments );
	}

	/**
	 * Show a relocation using the id or slug
	 *
	 * @tags      relocations
	 * @responses contentbox/apidocs/relocations/show/responses.json
	 */
	function show( event, rc, prc ){
		param rc.includes = "";
		param rc.excludes = "";

		super.show( argumentCollection = arguments );
	}

	/**
	 * Create a relocation
	 *
	 * @tags        relocations
	 * @requestBody contentbox/apidocs/relocations/create/requestBody.json
	 * @responses   contentbox/apidocs/relocations/create/responses.json
	 * @x           -contentbox-permissions relocations_ADMIN
	 */
	function create( event, rc, prc ){
		super.create( argumentCollection = arguments );
	}

	/**
	 * Update an existing relocation
	 *
	 * @tags                     relocations
	 * @responses                contentbox/apidocs/relocations/update/responses.json
	 * @x-contentbox-permissions relocations_ADMIN
	 */
	function update( event, rc, prc ){
		super.update( argumentCollection = arguments );
	}

	/**
	 * Delete a relocation using an id or slug
	 *
	 * @tags                     relocations
	 * @responses                contentbox/apidocs/relocations/delete/responses.json
	 * @x-contentbox-permissions relocations_ADMIN
	 */
	function delete( event, rc, prc ){
		super.delete( argumentCollection = arguments );
	}

}
