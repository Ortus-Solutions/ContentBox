/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Service layer for all Page operations
 */
component extends="ContentService" singleton {

	// Inject generic content service
	property name="contentService" inject="id:ContentService@cb";

	/**
	 * Constructor
	 */
	PageService function init(){
		// init it
		super.init( entityName = "cbPage", useQueryCaching = true );

		return this;
	}

	/**
	 * Save a page and do necessary updates
	 *
	 * @page The page to save or update
	 * @originalSlug If an original slug is passed, then we need to update hierarchy slugs.
	 *
	 * @return PageService
	 */
	function savePage( required any page, string originalSlug = "" ){
		transaction {
			// Verify uniqueness of slug
			if (
				!contentService.isSlugUnique(
					slug     : arguments.page.getSlug(),
					contentID: arguments.page.getContentID(),
					siteId   : arguments.page.getSiteId()
				)
			) {
				// make slug unique
				arguments.page.setSlug( getUniqueSlugHash( arguments.page.getSlug() ) );
			}

			// Save the target page
			save( entity = arguments.page, transactional = false );

			// Update all affected child pages if any on slug updates, much like nested set updates its nodes, we update our slugs
			if ( structKeyExists( arguments, "originalSlug" ) AND len( arguments.originalSlug ) ) {
				var pagesInNeed = newCriteria().like( "slug", "#arguments.originalSlug#/%" ).list();
				for ( var thisPage in pagesInNeed ) {
					thisPage.setSlug(
						replaceNoCase(
							thisPage.getSlug(),
							arguments.originalSlug,
							arguments.page.getSlug()
						)
					);
					save( entity = thisPage, transactional = false );
				}
			}
		}

		return arguments.page;
	}

	/**
	 * Search for pages according to many filters
	 *
	 * @search The search term to search on
	 * @isPublished Boolean bit to search if page is published or not, pass 'any' or not to ignore.
	 * @author The authorID to filter on, pass 'all' to ignore filter
	 * @parent The parentID to filter on, don't pass or pass an empty value to ignore, defaults to 'all'
	 * @creator The creatorID to filter on, don't pass or pass an empty value to ignore, defaults to 'all'
	 * @category The categorie(s) to filter on. You can also pass 'all' or 'none'
	 * @max The maximum records to return
	 * @offset The offset on the pagination
	 * @sortOrder Sorting of the results, defaults to page title asc
	 * @searchActiveContent If true, it searches title and content on the page, else it just searches on title
	 * @showInSearch If true, it makes sure content has been stored as searchable, defaults to false, which means it searches no matter what this bit says
	 * @siteId The site ID to filter on
	 *
	 * @returns struct = { pages, count }
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
		string siteId               = ""
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
			c.isEq( "ac.author.authorID", javacast( "int", arguments.author ) );
		}

		// Creator Filter
		if ( arguments.creator NEQ "all" ) {
			c.isEq( "creator.authorID", javacast( "int", arguments.creator ) );
		}

		// Site Filter
		if ( len( arguments.siteId ) ) {
			c.isEq( "site.siteId", javacast( "int", arguments.siteId ) );
		}

		// Search Criteria
		if ( len( arguments.search ) ) {
			// Search with active content
			if ( arguments.searchActiveContent ) {
				// like disjunctions
				c.or(
					c.restrictions.like( "title", "%#arguments.search#%" ),
					c.restrictions.like( "slug", "%#arguments.search#%" ),
					c.restrictions.like( "ac.content", "%#arguments.search#%" )
				);
			} else {
				c.or(
					c.restrictions.like( "title", "%#arguments.search#%" ),
					c.restrictions.like( "slug", "%#arguments.search#%" )
				);
			}
		}

		// parent filter
		if ( structKeyExists( arguments, "parent" ) ) {
			if ( len( trim( arguments.parent ) ) ) {
				c.isEq( "parent.contentID", javacast( "int", arguments.parent ) );
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
				c.createAlias( "categories", "cats" )
					.isIn(
						"cats.categoryID",
						javacast( "java.lang.Integer[]", [ arguments.category ] )
					);
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
		results.pages = c
			.resultTransformer( c.DISTINCT_ROOT_ENTITY )
			.list(
				offset    = arguments.offset,
				max       = arguments.max,
				sortOrder = arguments.sortOrder,
				asQuery   = false
			);
		return results;
	}

	/**
	 * Find published pages in ContentBox that have no passwords
	 *
	 * @max The max number of pages to return, defaults to 0=all
	 * @offset The pagination offset
	 * @searchTerm Pass a search term to narrow down results
	 * @category Pass a list of categories to narrow down results
	 * @asQuery Return results as array of objects or query, default is array of objects
	 * @parent The parent ID to restrict the search on
	 * @showInMenu If passed, it limits the search to this content property
	 * @sortOrder The sort order string, defaults to publisedDate DESC
	 * @siteId The siteId to filter on
	 *
	 * @return struct of { count, pages }
	 */
	function findPublishedPages(
		numeric max       = 0,
		numeric offset    = 0,
		string searchTerm = "",
		string category   = "",
		boolean asQuery   = false,
		string parent,
		boolean showInMenu,
		string sortOrder = "publishedDate DESC",
		string siteId    = ""
	){
		var results = { "count" : 0, "pages" : [] };
		var c       = newCriteria();

		// only published pages
		c.isTrue( "isPublished" )
			.isLT( "publishedDate", now() )
			.$or(
				c.restrictions.isNull( "expireDate" ),
				c.restrictions.isGT( "expireDate", now() )
			)
			// only non-password pages
			.isEq( "passwordProtection", "" );

		// Show only pages with showInMenu criteria?
		if ( structKeyExists( arguments, "showInMenu" ) ) {
			c.isEq( "showInMenu", javacast( "boolean", arguments.showInMenu ) );
		}

		// Category Filter
		if ( len( arguments.category ) ) {
			// create association with categories by slug.
			c.createAlias( "categories", "cats" )
				.isIn( "cats.slug", listToArray( arguments.category ) );
		}

		// Search Criteria
		if ( len( arguments.searchTerm ) ) {
			// like disjunctions
			c.createAlias(
					associationName: "contentVersions",
					alias          : "ac",
					withClause     : getRestrictions().isTrue( "ac.isActive" )
				)
				.or(
					c.restrictions.like( "title", "%#arguments.searchTerm#%" ),
					c.restrictions.like( "ac.content", "%#arguments.searchTerm#%" )
				);
		}

		// Site Filter
		if ( len( arguments.siteId ) ) {
			c.isEq( "site.siteId", javacast( "int", arguments.siteId ) );
		}

		// parent filter
		if ( structKeyExists( arguments, "parent" ) ) {
			if ( len( trim( arguments.parent ) ) ) {
				c.isEq( "parent.contentID", javacast( "int", arguments.parent ) );
			} else {
				c.isNull( "parent" );
			}
			// change sort by parent
			arguments.sortOrder = "order asc";
		}

		// run criteria query and projections count
		results.count = c.count( "contentID" );
		results.pages = c
			.asDistinct()
			.list(
				offset   : arguments.offset,
				max      : arguments.max,
				sortOrder: arguments.sortOrder,
				asQuery  : arguments.asQuery
			);

		return results;
	}

	/**
	 * Returns an array of [contentID, title, slug, createdDate, modifiedDate, featuredImageURL] structures of all the content in the system
	 *
	 * @sortOrder The sort ordering of the results
	 * @isPublished	Show all content or true/false published content
	 * @showInSearch Show all content or true/false showInSearch flag
	 * @siteId The site id to use to filter on
	 *
	 * @return Array of page data {contentID, title, slug, createdDate, modifiedDate, featuredImageURL}
	 */
	array function getAllFlatPages(
		sortOrder = "title asc",
		boolean isPublished,
		boolean showInSearch,
		string siteId = ""
	){
		return super.getAllFlatContent( argumentCollection = arguments );
	}

	/**
	 * Get all content for export as flat data
	 */
	array function getAllForExport(){
		return super.getAllForExport( newCriteria().isNull( "parent" ).list() );
	}

}
