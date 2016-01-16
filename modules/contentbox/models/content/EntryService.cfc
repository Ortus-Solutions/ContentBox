/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manages blog entry content
*/
component extends="ContentService" singleton{

	// Inject generic content service
	property name="contentService" inject="id:ContentService@cb";

	/**
	* Constructor
	*/
	EntryService function init(){
		// init it
		super.init(entityName="cbEntry",useQueryCaching=true);

		return this;
	}

	/**
	* Save an entry
	* 
	* @return EntryService
	*/
	function saveEntry( required any entry, boolean transactional=true ){

		// Verify uniqueness of slug
		if( !contentService.isSlugUnique( slug=arguments.entry.getSlug(), contentID=arguments.entry.getContentID() ) ){
			// make slug unique
			arguments.entry.setSlug( getUniqueSlugHash( arguments.entry.getSlug() ) );
		}

		// save entry
		save( entity=arguments.entry, transactional=arguments.transactional );

		return this;
	}

	/**
	* entry search returns struct with keys [entries,count]
	* @search.hint The search term to search on
	* @isPublished.hint Boolean bit to search if page is published or not, pass 'any' or not to ignore.
	* @author.hint The authorID to filter on, pass 'all' to ignore filter
	* @creator.hint The creatorID to filter on, don't pass or pass an empty value to ignore, defaults to 'all'
	* @category.hint The categorie(s) to filter on. You can also pass 'all' or 'none'
	* @max.hint The maximum records to return
	* @offset.hint The offset on the pagination
	* @sortOrder.hint Sorting of the results, defaults to page title asc
	* @searchActiveContent.hint If true, it searches title and content on the page, else it just searches on title
	* @showInSearch.hint If true, it makes sure content has been stored as searchable, defaults to false, which means it searches no matter what this bit says
	*
	* @returns struct = [entries,count]
	*/
	struct function search(
		string search="",
		string isPublished="any",
		string author="all",
		string creator="all",
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
				c.or( c.restrictions.like( "title", "%#arguments.search#%" ),
					  c.restrictions.like( "ac.content", "%#arguments.search#%" ) );
			} else {
				c.like( "title", "%#arguments.search#%" );
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
			sortOrder = "publishedDate DESC";
		}

		// run criteria query and projections count
		results.count 	= c.count( "contentID" );
		results.entries = c.resultTransformer( c.DISTINCT_ROOT_ENTITY )
							.list( offset=arguments.offset, max=arguments.max, sortOrder=arguments.sortOrder, asQuery=false );

		return results;
	}

	/**
	* Get a query report of entries archive
	*/
	function getArchiveReport(){
		// we use HQL so we can be DB independent using the map() hql function thanks to John Wish, you rock!
		var hql = "SELECT new map( count(*) as count, YEAR(publishedDate) as year, MONTH(publishedDate) as month )
				   FROM cbEntry
				  WHERE isPublished = true
				    AND passwordProtection = ''
				    AND publishedDate <= :now
				  GROUP BY YEAR(publishedDate), MONTH(publishedDate)
				  ORDER BY 2 DESC, 3 DESC";
		var params = {};
		params["now"] = now();
		// run report
		return executeQuery( query=hql, params=params, asQuery=false );
	}

	/**
	* Find published entries by date filters
	*/
	function findPublishedEntriesByDate(
		numeric year=0,
		numeric month=0,
		numeric day=0,
		numeric max=0,
		numeric offset=0,
		boolean asQuery=false
	){
		var results = {};
		var hql = "FROM cbEntry
				  WHERE isPublished = true
				    AND passwordProtection = ''
				    AND publishedDate <= :now";
		var params = {};
		params["now"] = now();
		// year lookup mandatory
		if( arguments.year NEQ 0 ){
			params["year"] = arguments.year;
			hql &= " AND YEAR(publishedDate) = :year";
		}
		// month lookup
		if( arguments.month NEQ 0 ){
			params["month"] = arguments.month;
			hql &= " AND MONTH(publishedDate) = :month";
		}
		// day lookup
		if( arguments.day NEQ 0 ){
			params["day"] = arguments.day;
			hql &= " AND DAY(publishedDate) = :day";
		}

		// Get Count
		results.count 	= executeQuery(query="select count(*) #hql#",params=params,max=1,asQuery=false)[1];
		// Add Ordering
		hql &= " ORDER BY publishedDate DESC";
		// find entries
		results.entries = executeQuery(query=hql,params=params,max=arguments.max,offset=arguments.offset,asQuery=arguments.asQuery);

		return results;
	}

	/**
	* Find published entries in ContentBox that have no passwords
	* @max.hint The max number of pages to return, defaults to 0=all
	* @offset.hint The pagination offset
	* @searchTerm.hint Pass a search term to narrow down results
	* @category.hint Pass a list of categories to narrow down results
	* @asQuery.hint Return results as array of objects or query, default is array of objects
	* @sortOrder.hint The sort order string, defaults to publisedDate DESC
	*/
	function findPublishedEntries(
		numeric max=0,
		numeric offset=0,
		string searchTerm="",
		string category="",
		boolean asQuery=false,
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
		if( len(arguments.searchTerm) ){
			// like disjunctions
			c.createAlias( "activeContent", "ac" );
			c.or( c.restrictions.like( "title", "%#arguments.searchTerm#%" ),
				  c.restrictions.like( "ac.content", "%#arguments.searchTerm#%" ) );
		}

		// run criteria query and projections count
		results.count 	= c.count( "contentID" );
		results.entries = c.resultTransformer( c.DISTINCT_ROOT_ENTITY )
							.list( offset=arguments.offset,
								   max=arguments.max,
								   sortOrder=arguments.sortOrder,
								   asQuery=arguments.asQuery );

		return results;
	}

	/**
	* Returns an array of [contentID, title, slug] structures of all the entries in the system
	*/
	array function getAllFlatEntries(){
		var c = newCriteria();

		return c.withProjections( property="contentID,title,slug" )
			.resultTransformer( c.ALIAS_TO_ENTITY_MAP )
			.list( sortOrder="title asc" );
	}

	/**
	* Get all content for export as flat data
	*/
	array function getAllForExport(){
		return super.getAllForExport( getAll() );
	}

}
