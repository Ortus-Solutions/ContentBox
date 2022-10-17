/**
 * RESTFul CRUD for Site Templates
 * An incoming site identifier is required
 */
component extends="baseHandler" {

	// DI
	property name="ormService" inject="ContentTemplateService@contentbox";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder    = "name";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity       = "ContentTemplate";
	// Use getOrFail() or getByIdOrNameOrFail() for show/delete/update actions
	variables.useGetOrFail = true;

	/**
	 * Executes before all handler actions
	 */
	any function preHandler( event, rc, prc, action, eventArguments ){
		// Verify incoming site
		param rc.includes = "";
		param rc.excludes = "";
		prc.oCurrentSite = rc.keyExists( "site" ) ? getSiteByIdOrSlugOrFail( rc.site ) : cb.site();
		param rc.site = prc.oCurrentSite.getSiteId();
	}

	/**
	 * Display all templates
	 *
	 * @tags Templates
	 */
	function index( event, rc, prc ){
		// Criterias and Filters
		param rc.sortOrder = "name";
		// Build up a search criteria and let the base execute it
		arguments.criteria = variables.ormService.newCriteria().isEq( "site", prc.oCurrentSite );
		arguments.criteria.when(
			rc.keyExists( "search" ) && len( rc.search ),
			function( c ){
				c.or(
					c.restrictions.like( "name","%#search#%" ),
					c.restrictions.like( "description","%#search#%" )
				);
			}
		);

		// Delegate it!
		super.index( argumentCollection = arguments );
	}

	/**
	 * Show a template using the id or name
	 *
	 * @tags Templates
	 */
	function show( event, rc, prc ){
		super.show( argumentCollection = arguments );
	}

	/**
	 * Create a template
	 *
	 * @tags Templates
	 * @x    -contentbox-permissions PAGES_ADMIN
	 */
	function create( event, rc, prc ) secured="PAGES_ADMIN"{
		param rc.creator = prc.oCurrentAuthor;
		structDelete( rc, "templateID" );
		super.create( argumentCollection = arguments );
	}

	/**
	 * Update an existing template
	 *
	 * @tags Templates
	 * @x    -contentbox-permissions PAGES_ADMIN
	 */
	function update( event, rc, prc ) secured="PAGES_ADMIN"{
		structDelete( rc, "creator" );
		structDelete( rc, "site" );
		super.update( argumentCollection = arguments );
	}

	/**
	 * Delete a template using an id or name
	 *
	 * @tags Templates
	 * @x    -contentbox-permissions PAGES_ADMIN
	 */
	function delete( event, rc, prc ) secured="PAGES_ADMIN"{
		super.delete( argumentCollection = arguments );
	}

}
