/**
* Entry service for contentbox
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	// DI
	property name="contentService" inject="id:contentService@cb";
	
	/**
	* Constructor
	*/
	EntryService function init(){
		// init it
		super.init(entityName="cbEntry");
		
		return this;
	}
	
	/**
	* Save an entry
	*/
	function saveEntry(entry){
		var c = newCriteria();
		
		// Prepare for slug uniqueness
		c.eq("slug", arguments.entry.getSlug() );
		if( arguments.entry.isLoaded() ){ c.ne("contentID", arguments.entry.getContentID() ); }
		
		// Verify uniqueness of slug
		if( c.count() GT 0){
			// make slug unique
			arguments.entry.setSlug( arguments.entry.getSlug() & "-#left(hash(now()),5)#");
		}
		
		// save entry
		save( arguments.entry );
	}
		
	/**
	* Get an id from a slug
	*/
	function getIDBySlug(required entrySlug){
		var results = newCriteria()
			.isEq("slug", arguments.entrySlug)
			.withProjections(property="contentID")
			.get();
		// verify results
		if( isNull( results ) ){ return "";}
		return results;
	}
	
	/**
	* entry search returns struct with keys [entries,count]
	*/
	struct function search(search="",isPublished,category,author,max=0,offset=0){
		var results = {};
		// criteria queries
		var c = newCriteria();
		
		// isPublished filter
		if( structKeyExists(arguments,"isPublished") AND arguments.isPublished NEQ "any"){
			c.eq("isPublished", javaCast("boolean",arguments.isPublished));
		}		
		// Author Filter
		if( structKeyExists(arguments,"author") AND arguments.author NEQ "all"){
		//	c.eq("author.authorID", javaCast("int",arguments.author));
		}
		// Search Criteria
		if( len(arguments.search) ){
			// like disjunctions
			c.or( c.restrictions.like("title","%#arguments.search#%"),
				  c.restrictions.like("content","%#arguments.search#%") );
		}
		// Category Filter
		if( structKeyExists(arguments,"category") AND arguments.category NEQ "all"){
			// Uncategorized?
			if( arguments.category eq "none" ){
				c.isEmpty("categories");
			}
			// With categories
			else{
				// search the association
				c.createAlias("categories","cats")
					.isIn("cats.categoryID", JavaCast("java.lang.Integer[]",[arguments.category]) );
			}			
		}	
		
		// run criteria query and projections count
		results.count 	= c.count();
		results.entries = c.list(offset=arguments.offset,max=arguments.max,sortOrder="publishedDate DESC",asQuery=false);
		
		return results;
	}
	
	// Entry Archive Report
	function getArchiveReport(){
		// we use HQL so we can be DB independent using the map() hql function thanks to John Wish, you rock!
		var hql = "SELECT new map( count(*) as count, YEAR(publishedDate) as year, MONTH(publishedDate) as month )
				   FROM cbEntry
				  WHERE isPublished = true
				    AND passwordProtection = ''
				  GROUP BY YEAR(publishedDate), MONTH(publishedDate)
				  ORDER BY 2 DESC, 3 DESC";
		
		// run report
		return executeQuery(query=hql,asQuery=false);
	}
	
	// Entry listing by Date
	function findPublishedEntriesByDate(numeric year=0,numeric month=0, numeric day=0,max=0,offset=0,asQuery=false){
		var results = {};
		var hql = "FROM cbEntry
				  WHERE isPublished = true
				    AND passwordProtection = ''";
		var params = {};
		
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
		// find
		results.entries = executeQuery(query=hql,params=params,max=arguments.max,offset=arguments.offset,asQuery=arguments.asQuery);
		results.count 	= executeQuery(query="select count(*) #hql#",params=params,max=1,asQuery=false)[1];
		
		return results;
	}
	
	// Entry listing for UI
	function findPublishedEntries(max=0,offset=0,category="",searchTerm="",asQuery=false){
		var results = {};
		var c = newCriteria();
		
		// only published entries
		c.isTrue("isPublished").isLt("publishedDate", now() )
			// only non-password protected ones
			.isEq("passwordProtection","");
		
		// Category Filter
		if( len(arguments.category) ){
			// create association with categories by slug.
			c.createAlias("categories","cats").isEq("cats.slug",arguments.category);
		}	
		
		// Search Criteria
		if( len(arguments.searchTerm) ){
			// like disjunctions
			c.or( c.restrictions.like("title","%#arguments.searchTerm#%"),
				  c.restrictions.like("content","%#arguments.searchTerm#%")	);
		}
		
		// run criteria query and projections count
		results.count 	= c.count();
		results.entries = c.list(offset=arguments.offset,max=arguments.max,sortOrder="publishedDate DESC",asQuery=arguments.asQuery);
		
		return results;
	}
	
	/**
	* Find a published entry by slug
	*/
	function findBySlug(required slug){
		var entry = newCriteria().isTrue("isPublished").isEq("slug",arguments.slug).get();
		
		// if not found, send and empty one
		if( isNull(entry) ){ return new(); }
		
		return entry;		
	}
	
}