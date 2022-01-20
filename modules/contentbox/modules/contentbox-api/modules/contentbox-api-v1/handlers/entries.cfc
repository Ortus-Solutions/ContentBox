/**
 * RESTFul CRUD for Blog Entries
 *
 * An incoming site identifier is required
 */
component extends="baseContentHandler" {

	// DI
	property name="ormService" inject="EntryService@contentbox";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder    = "publishedDate DESC";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity       = "Entry";
	// Use getOrFail() or getByIdOrSlugOrFail() for show/delete/update actions
	variables.useGetOrFail = false;

	/**
	 * Display all entries using different filters
	 *
	 * @tags Entries
	 * @x    -contentbox-permissions ENTRIES_ADMIN,ENTRIES_EDITOR
	 */
	function index( event, rc, prc ) secured="ENTRIES_ADMIN,ENTRIES_EDITOR"{
		param rc.page      = 1;
		param rc.excludes  = "HTMLTitle,HTMLKeywords,HTMLDescription";
		// Criterias and Filters
		param rc.sortOrder = "publishedDate DESC";
		// Search terms
		param rc.search    = "";
		// One or a list of categories to filter on
		param rc.category  = "";
		// Author ID to filter on
		param rc.author    = "";

		// Build up a search criteria and let the base execute it
		arguments.results = variables.ormService.findPublishedContent(
			searchTerm = rc.search,
			category   = rc.category,
			offset     = getPageOffset( rc.page ),
			max        = getMaxRows(),
			sortOrder  = rc.sortOrder,
			siteId     = prc.oCurrentSite.getSiteID(),
			authorID   = rc.author
		);

		// Build to match interface
		arguments.results.records = arguments.results.content;

		// Delegate it!
		super.index( argumentCollection = arguments );
	}

	/**
	 * Show an entry using the id
	 *
	 * @tags Entries
	 * @x    -contentbox-permissions ENTRIES_ADMIN,ENTRIES_EDITOR
	 */
	function show( event, rc, prc ) secured="ENTRIES_ADMIN,ENTRIES_EDITOR"{
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
	 * Create an entry
	 *
	 * @tags Entries
	 * @x    -contentbox-permissions ENTRIES_ADMIN,ENTRIES_EDITOR
	 */
	function create( event, rc, prc ) secured="ENTRIES_ADMIN,ENTRIES_EDITOR"{
		// Supersize it
		arguments.contentType = "ENTRIES";
		super.save( argumentCollection = arguments );
	}

	/**
	 * Update an existing entry
	 *
	 * @tags Entries
	 * @x    -contentbox-permissions ENTRIES_ADMIN,ENTRIES_EDITOR
	 */
	function update( event, rc, prc ) secured="ENTRIES_ADMIN,ENTRIES_EDITOR"{
		// Supersize it
		arguments.contentType = "ENTRIES";
		super.save( argumentCollection = arguments );
	}

	/**
	 * Delete an entry using an id or slug
	 *
	 * @tags Entries
	 * @x    -contentbox-permissions ENTRIES_ADMIN
	 */
	function delete( event, rc, prc ) secured="ENTRIES_ADMIN"{
		super.delete( argumentCollection = arguments );
	}

}
