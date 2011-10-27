/**
* Entry service for contentbox
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	// DI
	property name="HQLHelper" inject="id:HQLHelper@cb";
	
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
		// verify that the slug does not exist yet?
		if( !entry.isLoaded() ){
			if( countWhere(slug=arguments.entry.getSlug()) GT 0){
				// append date to slug
				arguments.entry.setSlug( "#left(hash(now()),8)#-" & arguments.entry.getSlug() );
			}
		}
		
		save( arguments.entry );
	}
	
	/**
	* Update an entry's hits
	*/
	function updateHits(required entry){
		// direct SQL as it is pretty standard SQL
		var q = new Query(sql="UPDATE cb_entry SET hits = hits + 1 WHERE entryID = #arguments.entry.getEntryID()#").execute();
	}
	
	/**
	* Get an id from a slug
	*/
	function getIDBySlug(required entrySlug){
		// direct SQL as it is pretty standard SQL
		var q = new Query(sql="select entryID from cb_entry where slug = :slug");
		q.addParam(name="slug",value=arguments.entrySlug);
		
		return q.execute().getResult().entryID;
	}
	
	/**
	* entry search returns struct with keys [entries,count]
	*/
	struct function search(search="",isPublished,category,author,max=0,offset=0){
		var results = {};
		// get Hibernate Restrictions class
		var restrictions = getRestrictions();	
		// criteria queries
		var criteria = [];
		
		// isPublished filter
		if( structKeyExists(arguments,"isPublished") AND arguments.isPublished NEQ "any"){
			arrayAppend(criteria, restrictions.eq("isPublished", javaCast("boolean",arguments.isPublished)) );
		}		
		// Author Filter
		if( structKeyExists(arguments,"author") AND arguments.author NEQ "all"){
			arrayAppend(criteria, restrictions.eq("author.authorID", javaCast("int",arguments.author)) );
		}
		// Search Criteria
		if( len(arguments.search) ){
			// like disjunctions
			var orCriteria = [];
 			arrayAppend(orCriteria, restrictions.like("title","%#arguments.search#%"));
 			arrayAppend(orCriteria, restrictions.like("content","%#arguments.search#%"));
			// append disjunction to main criteria
			arrayAppend( criteria, restrictions.disjunction( orCriteria ) );
		}
		// Category Filter
		if( structKeyExists(arguments,"category") AND arguments.category NEQ "all"){
			
			// Uncategorized?
			if( arguments.category eq "none" ){
				arrayAppend(criteria, restrictions.isEmpty("categories") );
			}
			// With categories
			else{
				// create association criteria, by passing a simple value the method will inflate.
				arrayAppend(criteria, "categories");
				// add the association criteria to the main search
				arrayAppend(criteria, restrictions.in("categories.categoryID",JavaCast("java.lang.Integer[]",[arguments.category])));
			}			
		}	
		
		// run criteria query and projections count
		results.entries = criteriaQuery(criteria=criteria,offset=arguments.offset,max=arguments.max,sortOrder="publishedDate DESC",asQuery=false);
		results.count 	= criteriaCount(criteria=criteria);
		
		return results;
	}
	
	// Entry Archive Report
	function getArchiveReport(){
		var results = {};
		// we use HQL so we can be DB independent
		var hql = "SELECT count(*), YEAR(publishedDate) as year, MONTH(publishedDate) as month
				   FROM cbEntry
				  WHERE isPublished = true
				    AND passwordProtection = ''
				  GROUP BY YEAR(publishedDate), MONTH(publishedDate)
				  ORDER BY 2 DESC, 3 DESC";
		
		// run report
		results = executeQuery(query=hql,asQuery=false);
		
		// build up a nicer structure
		return HQLHelper.arrayReportToStruct(hqlData=results,columnNames=["count","year","month"] );		
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
		// get Hibernate Restrictions class
		var restrictions = getRestrictions();	
		// criteria queries
		var criteria = [];
		
		// only published entries
		arrayAppend(criteria, restrictions.eq("isPublished", javaCast("boolean",1)) );
		arrayAppend(criteria, restrictions.lt("publishedDate", now() ));
		
		// only non-password entries
		arrayAppend(criteria, restrictions.eq("passwordProtection","") );
		
		// Category Filter
		if( len(arguments.category) ){
			// create association criteria, by passing a simple value the method will inflate.
			arrayAppend(criteria, "categories");
			// add the association criteria to the main search
			arrayAppend(criteria, restrictions.eq("categories.slug",arguments.category));			
		}	
		
		// Search Criteria
		if( len(arguments.searchTerm) ){
			// like disjunctions
			var orCriteria = [];
 			arrayAppend(orCriteria, restrictions.like("title","%#arguments.searchTerm#%"));
 			arrayAppend(orCriteria, restrictions.like("content","%#arguments.searchTerm#%"));
			// append disjunction to main criteria
			arrayAppend( criteria, restrictions.disjunction( orCriteria ) );
		}
		
		// run criteria query and projections count
		results.entries = criteriaQuery(criteria=criteria,offset=arguments.offset,max=arguments.max,sortOrder="publishedDate DESC",asQuery=arguments.asQuery);
		results.count 	= criteriaCount(criteria=criteria);
		
		return results;
	}
	
	/**
	* Find a published entry by slug
	*/
	function findBySlug(required slug){
		
		var entry = findWhere({isPublished=true,slug=arguments.slug});
		
		// if not found, send and empty one
		if( isNull(entry) ){ return new(); }
		
		return entry;		
	}
	
}