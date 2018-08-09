/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manages content store items
*/
component extends="ContentService" singleton{

	// DI
	property name="contentService" inject="id:ContentService@cb";

	/**
	* Constructor
	*/
	ContentStoreService function init(){
		// init it
		super.init( entityName="cbContentStore", useQueryCaching=true );

		return this;
	}

	/**
	 * Save content store object
	 *
	 * @content The content store object
	 * @originalSlug If an original slug is passed, then we need to update hierarchy slugs.
	 *
	 * @returns ContentStoreService
	 */
	function saveContent( required any content, string originalSlug="" ){

		transaction{
			// Verify uniqueness of slug
			if( !contentService.isSlugUnique( slug=arguments.content.getSlug(), contentID=arguments.content.getContentID() ) ){
				// make slug unique
				arguments.content.setSlug( getUniqueSlugHash( arguments.content.getSlug() ) );
			}

			// save entry
			save( entity=arguments.content, transactional=false );

			// Update all affected child pages if any on slug updates, much like nested set updates its nodes, we update our slugs
			if( structKeyExists( arguments, "originalSlug" ) AND len( arguments.originalSlug ) ){
				var entriesInNeed = newCriteria().like( "slug", "#arguments.originalSlug#/%" ).list();
				for( var thisContent in entriesInNeed ){
					thisContent.setSlug( replaceNoCase( thisContent.getSlug(), arguments.originalSlug, arguments.content.getSlug() ) );
					save( entity=thisContent, transactional=false );
				}
			}
		}

		return this;
	}

	/**
	 * Content search returns struct with keys [content,count]
	 *
	 * @search The search term to search on
	 * @isPublished Boolean bit to search if page is published or not, pass 'any' or not to ignore.
	 * @author The authorID to filter on, pass 'all' to ignore filter
	 * @parent The parentID or parent entity to filter on, don't pass or pass an empty value to ignore, defaults to 'all'
	 * @creator The creatorID to filter on, don't pass or pass an empty value to ignore, defaults to 'all'
	 * @category The categorie(s) to filter on. You can also pass 'all' or 'none'
	 * @max The maximum records to return
	 * @offset The offset on the pagination
	 * @sortOrder Sorting of the results, defaults to page title asc
	 * @searchActiveContent If true, it searches title and content on the page, else it just searches on title
	 * @showInSearch If true, it makes sure content has been stored as searchable, defaults to false, which means it searches no matter what this bit says
	 * @slugPrefix If passed, this will do a hierarchical search according to this slug prefix. Remember that all hierarchical content's slug field contains its hierarchy: /products/awesome/product1. This prefix will be appended with a `/`
	 *
	 * @returns struct = { pages, count }
	 */
	struct function search(
		string search="",
		string isPublished="any",
		string author="all",
		string creator="all",
		string parent,
		string category="all",
		numeric max=0,
		numeric offset=0,
		string sortOrder="",
		boolean searchActiveContent=true,
		boolean showInSearch=false,
		string slugPrefix=""
	){

		var results = { "count" : 0, "pages" : [] };
		// criteria queries
		var c = newCriteria();
		// stub out activeContent alias based on potential conditions...
		// this way, we don't have to worry about accidentally creating it twice, or not creating it at all
		if(
			( arguments.author NEQ "all" ) ||
			( len( arguments.search ) ) ||
			( findNoCase( "modifiedDate", arguments.sortOrder ) )
		) {
			c.createAlias( "activeContent", "ac" );
		}

		// only search shownInSearch bits
		if( arguments.showInSearch ){
			c.isTrue( "showInSearch" );
		}

		// isPublished filter
		if( arguments.isPublished NEQ "any" ){
			c.eq( "isPublished", javaCast( "boolean", arguments.isPublished ) );
		}

		// Author Filter
		if( arguments.author NEQ "all" ){
			c.isEq( "ac.author.authorID", javaCast( "int", arguments.author ) );
		}

		// Creator Filter
		if( arguments.creator NEQ "all" ){
			c.isEq( "creator.authorID", javaCast( "int", arguments.creator ) );
		}

		// Search Criteria
		if( len( arguments.search ) ){
			// Search with active content
			if( arguments.searchActiveContent ){
				// like disjunctions
				c.or(
					c.restrictions.like( "title","%#arguments.search#%" ),
					c.restrictions.like( "slug","%#arguments.search#%" ),
					c.restrictions.like( "description","%#arguments.search#%" ),
					c.restrictions.like( "ac.content", "%#arguments.search#%" )
				);
			} else {
				c.or(
					c.restrictions.like( "title","%#arguments.search#%" ),
					c.restrictions.like( "slug","%#arguments.search#%" ),
					c.restrictions.like( "description","%#arguments.search#%" )
				);
			}
		}

		// parent filter
		if( !isNull( arguments.parent ) ){
			if( isSimpleValue( arguments.parent ) and len( arguments.parent ) ){
				c.eq( "parent.contentID", javaCast( "int", arguments.parent ) );
			} else if( isObject( arguments.parent ) ){
				c.eq( "parent", arguments.parent );
			} else {
				c.isNull( "parent" );
			}
		}

		// Slug Prefix
		if( len( arguments.slugPrefix ) ){
			c.ilike( "slug", "#arguments.slugPrefix#/%" );
		}

		// Category Filter
		if( arguments.category NEQ "all" ){
			// Uncategorized?
			if( arguments.category eq "none" ){
				c.isEmpty( "categories" );
			}
			// With categories
			else{
				// search the association
				c.createAlias( "categories", "cats" )
					.isIn( "cats.categoryID", JavaCast( "java.lang.Integer[]", [ arguments.category ] ) );
			}
		}

		// DETERMINE SORT ORDERS
		// If modified Date
		if( findNoCase( "modifiedDate", arguments.sortOrder ) ) {
			sortOrder = replaceNoCase( arguments.sortOrder, "modifiedDate", "ac.createdDate" );
		}
		// default to title sorting
		else if( !len( arguments.sortOrder ) ){
			sortOrder = "title asc";
		}

		// run criteria query and projections count
		results.count 	= c.count( "contentID" );
		results.content = c.resultTransformer( c.DISTINCT_ROOT_ENTITY )
							.list(
								offset 		= arguments.offset,
								max 		= arguments.max,
								sortOrder 	= arguments.sortOrder,
								asQuery 	= false
							);
		return results;
	}

	/**
	 * Returns an array of [contentID, title, slug] structures of all the content store items in the system
	 *
	 * @sortOrder The sort order to use, defaults to title
	 */
	array function getAllFlatEntries( sortOrder="title asc" ){
		var c = newCriteria();

		return c.withProjections( property="contentID,title,slug" )
			.resultTransformer( c.ALIAS_TO_ENTITY_MAP )
			.list( sortOrder=arguments.sortOrder );
	}

	/**
	* Get all content for export as flat data
	*/
	array function getAllForExport(){
		return super.getAllForExport( newCriteria().isNull( "parent" ).list() );
	}

}