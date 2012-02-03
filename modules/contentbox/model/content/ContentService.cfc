/**
* A generic content service for content objects
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	/**
	* Constructor
	*/
	ContentService function init(entityName="cbContent"){
		// init it
		super.init(entityName=arguments.entityName);
		
		return this;
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
	* Find a published page by slug
	*/
	function findBySlug(required slug){
		var page = newCriteria().isTrue("isPublished").isEq("slug",arguments.slug).get();
		
		// if not found, send and empty one
		if( isNull(page) ){ return new(); }
		
		return page;		
	}
	
		
}