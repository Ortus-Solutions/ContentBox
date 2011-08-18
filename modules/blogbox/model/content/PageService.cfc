/**
* Page service for BlogBox
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	/**
	* Constructor
	*/
	PageService function init(){
		// init it
		super.init(entityName="bbPage");
		
		return this;
	}
	
	/**
	* Save a page
	*/
	function savePage(required page){
		// verify that the slug does not exist yet?
		if( !page.isLoaded() ){
			if( countWhere(slug=arguments.page.getSlug()) GT 0){
				// append date to slug
				arguments.page.setSlug( "#left(hash(now()),8)#-" & arguments.page.getSlug() );
			}
		}
		
		save( arguments.page );
	}
	
	/**
	* Update an page's hits
	*/
	function updateHits(required page){
		var q = new Query(sql="UPDATE bb_page SET hits = hits + 1 WHERE pageID = #arguments.page.getPageID()#").execute();
	}
	
	/**
	* Get an id from a slug
	*/
	function getIDBySlug(required pageSlug){
		var q = new Query(sql="select pageID from bb_page where slug = :slug");
		q.addParam(name="slug",value=arguments.pageSlug);
		
		return q.execute().getResult().pageID;
	}
	
	/**
	* page search returns struct with keys [pages,count]
	*/
	struct function search(search="",isPublished,author,parent,max=0,offset=0){
		var results = {};
		// get Hibernate Restrictions class
		var restrictions = getRestrictions();	
		// criteria queries
		var criteria = [];
		// default sort order
		var sortOrder = "title asc";
		
		// isPublished filter
		if( structKeyExists(arguments,"isPublished") AND arguments.isPublished NEQ "any"){
			arrayAppend(criteria, restrictions.eq("isPublished", javaCast("boolean",arguments.isPublished)) );
		}		
		// Author Filter
		if( structKeyExists(arguments,"author") AND arguments.author NEQ "all"){
			arrayAppend(criteria, restrictions.eq("author.authorID", javaCast("int",arguments.author)) );
		}
		// parent filter
		if( structKeyExists(arguments,"parent") ){
			if( len(arguments.parent) ){
				arrayAppend(criteria, restrictions.eq("parent.pageID", javaCast("int",arguments.parent)) );
			}
			else{
				arrayAppend(criteria, restrictions.isNull("parent") );
			}
			sortOrder = "order asc";
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
		
		// run criteria query and projections count
		results.pages 	= criteriaQuery(criteria=criteria,offset=arguments.offset,max=arguments.max,sortOrder=sortOrder,asQuery=false);
		results.count 	= criteriaCount(criteria=criteria);
		
		return results;
	}
	
	// Page listing for UI
	function findPublishedPages(max=0,offset=0,searchTerm="",asQuery=false,parent){
		var results = {};
		// get Hibernate Restrictions class
		var restrictions = getRestrictions();	
		// criteria queries
		var criteria = [];
		// sorting
		var sortOrder = "publishedDate DESC";
		
		// only published pages
		arrayAppend(criteria, restrictions.eq("isPublished", javaCast("boolean",1)) );
		// only non-password pages
		arrayAppend(criteria, restrictions.eq("passwordProtection","") );
		
		// Search Criteria
		if( len(arguments.searchTerm) ){
			// like disjunctions
			var orCriteria = [];
 			arrayAppend(orCriteria, restrictions.like("title","%#arguments.searchTerm#%"));
 			arrayAppend(orCriteria, restrictions.like("content","%#arguments.searchTerm#%"));
			// append disjunction to main criteria
			arrayAppend( criteria, restrictions.disjunction( orCriteria ) );
		}
		
		// parent filter
		if( structKeyExists(arguments,"parent") ){
			if( len(arguments.parent) ){
				arrayAppend(criteria, restrictions.eq("parent.pageID", javaCast("int",arguments.parent)) );
			}
			else{
				arrayAppend(criteria, restrictions.isNull("parent") );
			}
			sortOrder = "order asc";
		}	
		
		// run criteria query and projections count
		results.pages 	= criteriaQuery(criteria=criteria,offset=arguments.offset,max=arguments.max,sortOrder=sortOrder,asQuery=arguments.asQuery);
		results.count 	= criteriaCount(criteria=criteria);
		
		return results;
	}
	
	/**
	* Find a published page by slug
	*/
	function findBySlug(required slug){
		
		var page = findWhere({isPublished=true,slug=arguments.slug});
		
		// if not found, send and empty one
		if( isNull(page) ){ return new(); }
		
		return page;		
	}
	
	
	/**
	* @override Create a new hibernate criteria object according to entityname and criterion array objects
	*/
	private any function createCriteriaQuery(required entityName, array criteria=ArrayNew(1)){
		var qry = ORMGetSession().createCriteria( arguments.entityName );

		for(var i=1; i LTE ArrayLen(arguments.criteria); i++) {
			if( isSimpleValue( arguments.criteria[i] ) ){
				// create criteria out of simple values for associations with alias
				qry.createCriteria( arguments.criteria[i], arguments.criteria[i] );
			}
			else{
				// add criterion
				qry.add( arguments.criteria[i] );
			}
		}

		return qry;
	}
	
}