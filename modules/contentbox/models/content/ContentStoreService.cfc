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
	* @content.hint The content store object
	* @originalSlug.hint If an original slug is passed, then we need to update hierarchy slugs.
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
	* content search returns struct with keys [content,count]
	* @search.hint The search term to search on
	* @isPublished.hint Boolean bit to search if page is published or not, pass 'any' or not to ignore.
	* @author.hint The authorID to filter on, pass 'all' to ignore filter
	* @parent.hint The parentID to filter on, don't pass or pass an empty value to ignore, defaults to 'all'
	* @creator.hint The creatorID to filter on, don't pass or pass an empty value to ignore, defaults to 'all'
	* @category.hint The categorie(s) to filter on. You can also pass 'all' or 'none'
	* @max.hint The maximum records to return
	* @offset.hint The offset on the pagination
	* @sortOrder.hint Sorting of the results, defaults to page title asc
	* @searchActiveContent.hint If true, it searches title and content on the page, else it just searches on title
	* @showInSearch.hint If true, it makes sure content has been stored as searchable, defaults to false, which means it searches no matter what this bit says
	*
	* @returns struct = [pages,count]
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
		boolean showInSearch=false
	){

		var results = {};
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
		if( structKeyExists( arguments, "parent" ) ){
			if( len( trim( arguments.parent ) ) ){
				c.eq( "parent.contentID", javaCast( "int", arguments.parent ) );
			} else {
				c.isNull( "parent" );
			}
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
	* Find published contentstore entries by filters
	* @max.hint The maximum number of records to retrieve
	* @offset.hint Where to start in the pagination
	* @searchTerm.hint The search term to use for search
	* @category.hint One or more categories to filter on
	* @asQuery.hint Return results as query or array of objects. Defaults to false
	* @parent.hint The parent ID to restrict the search on
	* @sortOrder.hint The sort order string, defaults to publisedDate DESC
	*/
	function findPublishedEntries(
		numeric max=0,
		numeric offset=0,
		any searchTerm="",
		any category="",
		boolean asQuery=false,
		string parent,
		string sortOrder="publishedDate DESC"
	){

		var results = {};
		var c = newCriteria();

		// only published pages
		c.isTrue( "isPublished" )
			.isLT( "publishedDate", Now() )
			.$or( c.restrictions.isNull( "expireDate" ), c.restrictions.isGT( "expireDate", now() ) )
			// only non-password pages
			.isEq( "passwordProtection", "" );

		// Category Filter
		if( len( arguments.category ) ){
			// create association with categories by slug.
			c.createAlias( "categories", "cats" ).isIn( "cats.slug", listToArray( arguments.category ) );
		}

		// Search Criteria
		if( len( arguments.searchTerm ) ){
			// like disjunctions
			c.createAlias( "activeContent", "ac" );
			c.or( c.restrictions.like( "title", "%#arguments.searchTerm#%" ),
				  c.restrictions.like( "ac.content", "%#arguments.searchTerm#%" ) );
		}

		// parent filter
		if( structKeyExists( arguments, "parent" ) ){
			if( len( trim( arguments.parent ) ) ){
				c.eq( "parent.contentID", javaCast( "int", arguments.parent ) );
			} else {
				c.isNull( "parent" );
			}
			// change sort by parent
			arguments.sortOrder = "order asc";
		}

		// run criteria query and projections count
		results.count 	= c.count( "contentID" );
		results.entries = c.resultTransformer( c.DISTINCT_ROOT_ENTITY )
							.list( 
								offset 		= arguments.offset,
								max 		= arguments.max,
								sortOrder 	= arguments.sortOrder,
								asQuery 	= arguments.asQuery 
							);

		return results;
	}

	/**
	* Returns an array of [contentID, title, slug] structures of all the content store items in the system
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