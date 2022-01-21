/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manages content store items
 */
component extends="ContentService" singleton {

	// DI
	property name="contentService" inject="id:ContentService@contentbox";

	/**
	 * Constructor
	 */
	ContentStoreService function init(){
		// init it
		super.init( entityName = "cbContentStore", useQueryCaching = true );

		return this;
	}

	/**
	 * Save the content store object and if an original slug is passed, we will update the entire
	 * hierarchy if the slug changed.
	 *
	 * @content      The content store object
	 * @originalSlug If an original slug is passed, then we need to update hierarchy slugs.
	 *
	 * @return ContentStoreService
	 */
	function save( required any content, string originalSlug = "" ){
		transaction {
			// save entry
			super.save( arguments.content );

			// Update all affected child pages if any on slug updates, much like nested set updates its nodes, we update our slugs
			if ( structKeyExists( arguments, "originalSlug" ) AND len( arguments.originalSlug ) ) {
				var entriesInNeed = newCriteria().like( "slug", "#arguments.originalSlug#/%" ).list();
				for ( var thisContent in entriesInNeed ) {
					thisContent.setSlug(
						replaceNoCase(
							thisContent.getSlug(),
							arguments.originalSlug,
							arguments.content.getSlug()
						)
					);
					super.save( thisContent );
				}
			}
		}

		return arguments.content;
	}

	/**
	 * Search for content store items according to many filters
	 *
	 * @search              The search term to search on
	 * @isPublished         Boolean bit to search if page is published or not, pass 'any' or not to ignore.
	 * @author              The authorID to filter on, pass 'all' to ignore filter
	 * @parent              The parentID or parent entity to filter on, don't pass or pass an empty value to ignore, defaults to 'all'
	 * @creator             The creatorID to filter on, don't pass or pass an empty value to ignore, defaults to 'all'
	 * @category            The categorie(s) to filter on. You can also pass 'all' or 'none'
	 * @max                 The maximum records to return
	 * @offset              The offset on the pagination
	 * @sortOrder           Sorting of the results, defaults to page title asc
	 * @searchActiveContent If true, it searches title and content on the page, else it just searches on title
	 * @showInSearch        If true, it makes sure content has been stored as searchable, defaults to false, which means it searches no matter what this bit says
	 * @slugPrefix          If passed, this will do a hierarchical search according to this slug prefix. Remember that all hierarchical content's slug field contains its hierarchy: /products/awesome/product1. This prefix will be appended with a `/`
	 * @siteID              The site ID to filter on
	 * @propertyList        A list of properties to retrieve as a projection instead of array of objects
	 *
	 * @return struct = { content, count }
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
		string slugPrefix           = "",
		string siteID               = "",
		string propertyList
	){
		var results = { "count" : 0, "content" : [] };
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
					c.restrictions.like( "description", "%#arguments.search#%" ),
					c.restrictions.like( "ac.content", "%#arguments.search#%" )
				);
			} else {
				c.$or(
					c.restrictions.like( "title", "%#arguments.search#%" ),
					c.restrictions.like( "slug", "%#arguments.search#%" ),
					c.restrictions.like( "description", "%#arguments.search#%" )
				);
			}
		}

		// parent filter
		if ( !isNull( arguments.parent ) ) {
			if ( isSimpleValue( arguments.parent ) and len( arguments.parent ) ) {
				c.isEq( "parent.contentID", arguments.parent );
			} else if ( isObject( arguments.parent ) ) {
				c.isEq( "parent", arguments.parent );
			} else {
				c.isNull( "parent" );
			}
		}

		// Slug Prefix
		if ( len( arguments.slugPrefix ) ) {
			c.ilike( "slug", "#arguments.slugPrefix#/%" );
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
		results.content = c.list(
			offset   : arguments.offset,
			max      : arguments.max,
			sortOrder: arguments.sortOrder,
			asQuery  : false
		);
		return results;
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
