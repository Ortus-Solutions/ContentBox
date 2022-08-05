/**
 * RESTFul CRUD for Content Store items
 *
 * An incoming site identifier is required
 */
component extends="baseContentHandler" {

	// DI
	property name="ormService" inject="ContentStoreService@contentbox";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder    = "publishedDate DESC";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity       = "ContentStore";
	// Use getOrFail() or getByIdOrSlugOrFail() for show/delete/update actions
	variables.useGetOrFail = false;

	/**
	 * Display all content store items using different filters
	 *
	 * @tags                     ContentStore
	 * @responses                contentbox/apidocs/contentStore/index/responses.json
	 * @x-contentbox-permissions CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR
	 */
	function index( event, rc, prc ) secured="CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR"{
		// Paging + Mementifier
		param rc.page       = 1;
		param rc.excludes   = "HTMLTitle,HTMLKeywords,HTMLDescription";
		// Criterias and Filters
		param rc.sortOrder  = "publishedDate DESC";
		// Search terms
		param rc.search     = "";
		// One or a list of categories to filter on
		param rc.category   = "";
		// Author ID to filter on
		param rc.author     = "";
		// The parent to filter on, default is root pages
		param rc.parent     = "";
		// If passed, this will do a hierarchical search according to this slug prefix. Remember that all hierarchical content's slug field contains its hierarchy: /products/awesome/product1. This prefix will be appended with a `/`
		param rc.slugPrefix = "";
		// If passed, we can do a slug wildcard search
		param rc.slugSearch = "";

		// Build up a search criteria and let the base execute it
		arguments.results = variables.ormService.findPublishedContent(
			searchTerm = rc.search,
			category   = rc.category,
			offset     = getPageOffset( rc.page ),
			max        = getMaxRows(),
			sortOrder  = rc.sortOrder,
			siteId     = prc.oCurrentSite.getSiteID(),
			authorID   = rc.author,
			parent     = rc.parent,
			slugPrefix = rc.slugPrefix,
			slugSearch = rc.slugSearch
		);

		// Build to match interface
		arguments.results.records = arguments.results.content;

		// Delegate it!
		super.index( argumentCollection = arguments );
	}

	/**
	 * Show a content store item using the id
	 *
	 * @tags                     ContentStore
	 * @responses                contentbox/apidocs/contentStore/show/responses.json
	 * @x-contentbox-permissions CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR
	 */
	function show( event, rc, prc ) secured="CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR"{
		param rc.includes = arrayToList( [
			"activeContent",
			"childrenSnapshot:children",
			"customFieldsAsStruct:customFields",
			"linkedContentSnapshot:linkedContent",
			"relatedContentSnapshot:relatedContent",
			"renderedContent"
		] );
		param rc.excludes = "";

		super.show( argumentCollection = arguments );
	}

	/**
	 * Create a content store item
	 *
	 * @tags        ContentStore
	 * @requestBody contentbox/apidocs/contentStore/create/requestBody.json
	 * @responses   contentbox/apidocs/contentStore/create/responses.json
	 * @x           -contentbox-permissions CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR
	 */
	function create( event, rc, prc ) secured="CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR"{
		// Supersize it
		arguments.contentType = "CONTENTSTORE";
		super.save( argumentCollection = arguments );
	}

	/**
	 * Update an existing content store item
	 *
	 * @tags                     ContentStore
	 * @responses                contentbox/apidocs/contentStore/update/responses.json
	 * @x-contentbox-permissions CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR
	 */
	function update( event, rc, prc ) secured="CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR"{
		arguments.contentType = "CONTENTSTORE";
		super.save( argumentCollection = arguments );
	}

	/**
	 * Delete a content store item using an id or slug
	 *
	 * @tags                     ContentStore
	 * @responses                contentbox/apidocs/contentStore/delete/responses.json
	 * @x-contentbox-permissions CONTENTSTORE_ADMIN
	 */
	function delete( event, rc, prc ) secured="CONTENTSTORE_ADMIN"{
		super.delete( argumentCollection = arguments );
	}

}
