/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Service layer for all Page operations
 */
component extends="ContentService" singleton {

	// Inject generic content service
	property name="contentService" inject="id:ContentService@contentbox";

	/**
	 * Constructor
	 */
	PageService function init(){
		// init it
		super.init( entityName = "cbPage", useQueryCaching = true );

		return this;
	}

	/**
	 * Save a page and do necessary updates to the hierarchies if there is a slug change
	 *
	 * @page         The page to save or update
	 * @originalSlug If an original slug is passed, then we need to update hierarchy slugs.
	 *
	 * @return Saved page
	 */
	function save( required any page, string originalSlug = "" ){
		transaction {
			// Save the target page
			super.save( arguments.page );

			// Update all affected child pages if any on slug updates, much like nested set updates its nodes, we update our slugs
			if ( !isNull( arguments.originalSlug ) AND len( arguments.originalSlug ) ) {
				var pagesInNeed = newCriteria().like( "slug", "#arguments.originalSlug#/%" ).list();
				for ( var thisPage in pagesInNeed ) {
					thisPage.setSlug(
						replaceNoCase(
							thisPage.getSlug(),
							arguments.originalSlug,
							arguments.page.getSlug()
						)
					);
					super.save( thisPage );
				}
			}
		}

		return arguments.page;
	}

	/**
	 * Search for pages according to many filters
	 *
	 * @search              The search term to search on
	 * @isPublished         Boolean bit to search if page is published or not, pass 'any' or not to ignore.
	 * @author              The authorID to filter on, pass 'all' to ignore filter
	 * @parent              The parentID to filter on, don't pass or pass an empty value to ignore, defaults to 'all'
	 * @creator             The creatorID to filter on, don't pass or pass an empty value to ignore, defaults to 'all'
	 * @category            The categorie(s) to filter on. You can also pass 'all' or 'none'
	 * @max                 The maximum records to return
	 * @offset              The offset on the pagination
	 * @sortOrder           Sorting of the results, defaults to page title asc
	 * @searchActiveContent If true, it searches title and content on the page, else it just searches on title
	 * @showInSearch        If true, it makes sure content has been stored as searchable, defaults to false, which means it searches no matter what this bit says
	 * @siteID              The site ID to filter on
	 * @propertyList        A list of properties to retrieve as a projection instead of array of objects
	 *
	 * @return struct = { pages, count }
	 */
	struct function search(
		string search      = "",
		string isPublished = "any",
		string author      = "all",
		string creator     = "all",
		string parent,
		string category             = "all",
		numeric max                 = 0,
		numeric offset              = 0,
		string sortOrder            = "",
		boolean searchActiveContent = true,
		boolean showInSearch        = false,
		string siteID               = "",
		string propertyList
	){
		var results = { "count" : 0, "pages" : [] };
		// criteria queries
		var c       = newCriteria();

		// stub out activeContent alias based on potential conditions...
		// this way, we don't have to worry about accidentally creating it twice, or not creating it at all
		if (
			( arguments.author NEQ "all" ) ||
			( len( arguments.search ) ) ||
			( findNoCase( "modifiedDate", arguments.sortOrder ) )
		) {
			c.createAlias(
				associationName: "contentVersions",
				alias          : "ac",
				withClause     : getRestrictions().isTrue( "ac.isActive" )
			);
		}

		// only search shownInSearch bits
		if ( arguments.showInSearch ) {
			c.isTrue( "showInSearch" );
		}

		// isPublished filter
		if ( arguments.isPublished NEQ "any" ) {
			c.isEq( "isPublished", javacast( "boolean", arguments.isPublished ) );
		}

		// Author Filter
		if ( arguments.author NEQ "all" ) {
			c.isEq( "ac.author.authorID", arguments.author );
		}

		// Creator Filter
		if ( arguments.creator NEQ "all" ) {
			c.isEq( "creator.authorID", arguments.creator );
		}

		// Site Filter
		if ( len( arguments.siteID ) ) {
			c.isEq( "site.siteID", arguments.siteID );
		}

		// Search Criteria
		if ( len( arguments.search ) ) {
			// Search with active content
			if ( arguments.searchActiveContent ) {
				// like disjunctions
				c.$or(
					c.restrictions.like( "title", "%#arguments.search#%" ),
					c.restrictions.like( "slug", "%#arguments.search#%" ),
					c.restrictions.like( "ac.content", "%#arguments.search#%" )
				);
			} else {
				c.$or(
					c.restrictions.like( "title", "%#arguments.search#%" ),
					c.restrictions.like( "slug", "%#arguments.search#%" )
				);
			}
		}

		// parent filter
		if ( structKeyExists( arguments, "parent" ) ) {
			if ( len( trim( arguments.parent ) ) ) {
				c.isEq( "parent.contentID", arguments.parent );
			} else {
				c.isNull( "parent" );
			}
		}

		// Category Filter
		if ( arguments.category NEQ "all" ) {
			// Uncategorized?
			if ( arguments.category eq "none" ) {
				c.isEmpty( "categories" );
			}
			// With categories
			else {
				// search the association
				c.createAlias( "categories", "cats" ).isIn( "cats.categoryID", [ arguments.category ] );
			}
		}

		// DETERMINE SORT ORDERS
		// If modified Date
		if ( findNoCase( "modifiedDate", arguments.sortOrder ) ) {
			sortOrder = replaceNoCase(
				arguments.sortOrder,
				"modifiedDate",
				"ac.createdDate"
			);
		}
		// default to title sorting
		else if ( !len( arguments.sortOrder ) ) {
			sortOrder = "title asc";
		}

		// run criteria query and projections count
		results.count = c.count( "contentID" );

		if ( !isNull( arguments.propertyList ) ) {
			c.withProjections( property = arguments.propertyList ).asStruct();
		} else {
			c.resultTransformer( c.DISTINCT_ROOT_ENTITY );
		}
		results.pages = c.list(
			offset    = arguments.offset,
			max       = arguments.max,
			sortOrder = arguments.sortOrder,
			asQuery   = false
		);
		return results;
	}

	/**
	 * Find published pages using different filters and output formats.
	 *
	 * @max        The maximum number of records to paginate
	 * @offset     The offset in the pagination
	 * @searchTerm The search term to search
	 * @category   The category to filter the content on
	 * @asQuery    Return as query or array of objects, defaults to array of objects
	 * @sortOrder  how we need to sort the results
	 * @parent     The parentID or parent entity to filter on, don't pass or pass an empty value to ignore, defaults to 'all'
	 * @slugPrefix If passed, this will do a hierarchical search according to this slug prefix. Remember that all hierarchical content's slug field contains its hierarchy: /products/awesome/product1. This prefix will be appended with a `/`
	 * @siteID     If passed, filter by site id
	 * @properties The list of properties to project on instead of giving you full object graphs
	 * @authorID   The authorID to filter on
	 * @criteria   The criteria object to use if passed, else we create a new one.
	 * @showInMenu If passed, it limits the search to this content property
	 * @slugSearch If passed, we will search for content items with this field as a full text search on slugs
	 *
	 * @return struct of { count, content }
	 */
	function findPublishedContent(
		numeric max      = 0,
		numeric offset   = 0,
		any searchTerm   = "",
		any category     = "",
		boolean asQuery  = false,
		string sortOrder = "publishedDate DESC",
		any parent,
		string slugPrefix = "",
		string siteID     = "",
		string properties,
		string authorID = "",
		boolean showInMenu,
		string slugSearch = ""
	){
		arguments.criteria = newCriteria()
			// Show only pages with showInMenu criteria?
			.when( !isNull( arguments.showInMenu ), function( c ){
				arguments.c.isEq( "showInMenu", javacast( "boolean", showInMenu ) );
			} );

		// run criteria query and projections count
		return super.findPublishedContent( argumentCollection = arguments );
	}

	/**
	 * Get all site content for export as flat data
	 *
	 * @site The site to get the export from
	 */
	array function getAllForExport( required site ){
		return super.getAllForExport(
			newCriteria()
				.isNull( "parent" )
				.isEq( "site", arguments.site )
				.list()
		);
	}

}
