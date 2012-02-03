/**
* Page service for contentbox
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	/**
	* Constructor
	*/
	PageService function init(){
		// init it
		super.init(entityName="cbPage");
		
		return this;
	}
	
	/**
	* Save a page
	*/
	function savePage(required page){
		var c = newCriteria();
		
		// Prepare for slug uniqueness
		c.eq("slug", arguments.page.getSlug() );
		if( arguments.page.isLoaded() ){ c.ne("contentID", arguments.page.getContentID() ); }
		
		// Verify uniqueness of slug
		if( c.count() GT 0){
			// make slug unique
			arguments.page.setSlug( arguments.page.getSlug() & "-#left(hash(now()),5)#" );
		}
		
		// Save the page
		save( arguments.page );
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
	* page search returns struct with keys [pages,count]
	*/
	struct function search(search="",isPublished,author,parent,max=0,offset=0,sortOrder="title asc"){
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
		// parent filter
		if( structKeyExists(arguments,"parent") ){
			if( len( trim(arguments.parent) ) ){
				c.eq("parent.contentID", javaCast("int",arguments.parent) );
			}
			else{
				c.isNull("parent");
			}
			sortOrder = "order asc";
		}	
		// Search Criteria
		if( len(arguments.search) ){
			// like disjunctions
			c.or( c.restrictions.like("title","%#arguments.search#%"),
				  c.restrictions.like("content","%#arguments.search#%") );
		}
		
		// run criteria query and projections count
		results.count 	= c.count();
		results.pages 	= c.list(offset=arguments.offset,max=arguments.max,sortOrder=sortOrder,asQuery=false);
		return results;
	}
	
	// Page listing for UI
	function findPublishedPages(max=0,offset=0,searchTerm="",asQuery=false,parent,boolean showInMenu){
		var results = {};
		var c = newCriteria();
		// sorting
		var sortOrder = "publishedDate DESC";
		
		// only published pages
		c.isTrue("isPublished")
			.isLT("publishedDate", Now())
			// only non-password pages
			.isEq("passwordProtection","");
			
		// Show only pages with showInMenu criteria?
		if( structKeyExists(arguments,"showInMenu") ){
			c.isTrue("showInMenu");
		}
		
		// Search Criteria
		if( len(arguments.searchTerm) ){
			// like disjunctions
			c.or( c.restrictions.like("title","%#arguments.searchTerm#%"),
				  c.restrictions.like("content","%#arguments.searchTerm#%") );
		}
		
		// parent filter
		if( structKeyExists(arguments,"parent") ){
			if( len( trim(arguments.parent) ) ){
				c.eq("parent.contentID", javaCast("int",arguments.parent) );
			}
			else{
				c.isNull("parent");
			}
			sortOrder = "order asc";
		}	
		
		// run criteria query and projections count
		results.count 	= c.count();
		results.pages 	= c.list(offset=arguments.offset,max=arguments.max,sortOrder=sortOrder,asQuery=arguments.asQuery);
		
		return results;
	}
	
	/**
	* Find a published page by slug
	*/
	function findBySlug(required slug){
		var page = newCriteria().isTrue("isPublished").isEq("slug",arguments.slug).get();
		
		// if not found, send and empty one
		if( isNull(page) ){ return new(); }
		
		return page;		
	}
		
}