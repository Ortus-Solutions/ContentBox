/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manages blog entry content
 */
component extends="ContentService" singleton {

	// Inject generic content service
	property name="contentService" inject="id:ContentService@contentbox";

	/**
	 * Constructor
	 */
	EntryService function init(){
		// init it
		super.init( entityName = "cbEntry", useQueryCaching = true );

		return this;
	}

	/**
	 * Save an entry
	 *
	 * @entry        The entry to save or update
	 * @originalSlug The original slug if the save is an update
	 *
	 * @return Saved entry
	 */
	function save( required any entry, string originalSlug = "" ){
		return super.save( arguments.entry );
	}

	/**
	 * Search for blog entries according to many filters
	 *
	 * @search              The search term to search on
	 * @isPublished         Boolean bit to search if page is published or not, pass 'any' or not to ignore. Default is `any`
	 * @author              The authorID to filter on, pass 'all' to ignore filter
	 * @creator             The creatorID to filter on, don't pass or pass an empty value to ignore, defaults to 'all'
	 * @category            The categorie(s) to filter on. You can also pass 'all' or 'none'
	 * @max                 The maximum records to return
	 * @offset              The offset on the pagination
	 * @sortOrder           Sorting of the results, defaults to page title asc
	 * @searchActiveContent If true, it searches title and content on the page, else it just searches on title
	 * @showInSearch        If true, it makes sure content has been stored as searchable, defaults to false, which means it searches no matter what this bit says
	 * @siteId              The site ID to filter on
	 * @propertyList        A list of properties to retrieve as a projection instead of array of objects
	 *
	 * @return struct of { entries, count }
	 */
	struct function search(
		string search               = "",
		string isPublished          = "any",
		string author               = "all",
		string creator              = "all",
		string category             = "all",
		numeric max                 = 0,
		numeric offset              = 0,
		string sortOrder            = "",
		boolean searchActiveContent = true,
		boolean showInSearch        = false,
		string siteId               = "",
		string propertyList
	){
		var results = { "count" : 0, "entries" : [] };
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
		// Search Criteria
		if ( len( arguments.search ) ) {
			// Search with active content
			if ( arguments.searchActiveContent ) {
				// like disjunctions
				c.$or(
					c.restrictions.like( "title", "%#arguments.search#%" ),
					c.restrictions.like( "ac.content", "%#arguments.search#%" )
				);
			} else {
				c.like( "title", "%#arguments.search#%" );
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
		// Site Filter
		if ( len( arguments.siteId ) ) {
			c.isEq( "site.siteID", arguments.siteId );
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
			sortOrder = "publishedDate DESC";
		}

		// run criteria query and projections count
		results.count = c.count( "contentID" );

		if ( !isNull( arguments.propertyList ) ) {
			c.withProjections( property = arguments.propertyList ).asStruct();
		} else {
			c.resultTransformer( c.DISTINCT_ROOT_ENTITY );
		}
		results.entries = c.list(
			offset    = arguments.offset,
			max       = arguments.max,
			sortOrder = arguments.sortOrder,
			asQuery   = false
		);

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
		// run report
		return executeQuery( query = hql, params = { "now" : now() } );
	}

	/**
	 * Find published entries by date filters
	 *
	 * @year    The year to filter on
	 * @month   The month to filter on
	 * @day     The day to filter on
	 * @max     The maximum records to return
	 * @offset  The offset on the pagination
	 * @asQuery Return query or array of structs
	 * @siteId  The site ID to filter on
	 *
	 * @return struct of { entries, count }
	 */
	function findPublishedEntriesByDate(
		numeric year    = 0,
		numeric month   = 0,
		numeric day     = 0,
		numeric max     = 0,
		numeric offset  = 0,
		boolean asQuery = false,
		string siteId   = ""
	){
		var results = {};
		var hql     = "FROM cbEntry
				  WHERE isPublished = true
				    AND passwordProtection = ''
				    AND publishedDate <= :now";
		var params      = {};
		params[ "now" ] = now();

		// Site
		if ( len( arguments.siteId ) ) {
			params[ "siteId" ] = arguments.siteId;
			hql &= " AND site.siteID = :siteId";
		}

		// year lookup mandatory
		if ( arguments.year NEQ 0 ) {
			params[ "year" ] = arguments.year;
			hql &= " AND YEAR( publishedDate ) = :year";
		}

		// month lookup
		if ( arguments.month NEQ 0 ) {
			params[ "month" ] = arguments.month;
			hql &= " AND MONTH( publishedDate ) = :month";
		}

		// day lookup
		if ( arguments.day NEQ 0 ) {
			params[ "day" ] = arguments.day;
			hql &= " AND DAY( publishedDate ) = :day";
		}

		// Get Count
		results.count = executeQuery(
			query   = "select count( * ) #hql#",
			params  = params,
			max     = 1,
			asQuery = false
		)[ 1 ];

		// Add Ordering
		hql &= " ORDER BY publishedDate DESC";

		// find entries
		results.entries = executeQuery(
			query   = hql,
			params  = params,
			max     = arguments.max,
			offset  = arguments.offset,
			asQuery = arguments.asQuery
		);

		return results;
	}

	/**
	 * Get all site content for export as flat data
	 *
	 * @site The site to get the export from
	 */
	array function getAllForExport( required site ){
		return super.getAllForExport( findAllWhere( { site : arguments.site } ) );
	}

}
