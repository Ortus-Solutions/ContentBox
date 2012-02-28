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
	
	// Content ORM Search
	function searchContent(searchTerm="",max=0,offset=0,asQuery=false){
		var results = {};
		var c = newCriteria();
		
		// only published content
		c.isTrue("isPublished").isLt("publishedDate", now() )
			// only non-password protected ones
			.isEq("passwordProtection","");
		
		// Search Criteria
		if( len(arguments.searchTerm) ){
			// like disjunctions
			c.createAlias("activeContent","ac");
			c.or( c.restrictions.like("title","%#arguments.searchTerm#%"),
				  c.restrictions.like("ac.content", "%#arguments.searchTerm#%") );
		}
		
		// run criteria query and projections count
		results.count 	= c.count();
		results.content = c.list(offset=arguments.offset,max=arguments.max,sortOrder="publishedDate DESC",asQuery=arguments.asQuery);
		
		return results;
	}

	/**
	* Get an id from a slug of a content object
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
	* Find a published content object by slug
	*/
	function findBySlug(required slug, required showUnpublished=false){
		var c = newCriteria();
		if (!showUnpublished){
			c.isTrue("isPublished")
				.isLT("publishedDate", Now());
		}
		var content = c.isEq("slug",arguments.slug).get();

		// if not found, send and empty one
		if( isNull(content) ){ return new(); }

		return content;
	}

	/**
	* Delete a content object safely via hierarchies
	*/
	ContentService function deleteContent(required content){
		// Check for dis-associations
		if( arguments.content.hasParent() ){
			arguments.content.getParent().removeChild( arguments.content );
		}
		// now delete it
		delete( arguments.content );
		// return service
		return this;
	}
	
	/**
	* Find published content objects
	*/
	function findPublishedContent(max=0,offset=0,searchTerm="",category="",asQuery=false,parent,boolean showInMenu){
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
		
		// Category Filter
		if( len(arguments.category) ){
			// create association with categories by slug.
			c.createAlias("categories","cats").isEq("cats.slug",arguments.category);
		}	
		
		// Search Criteria
		if( len(arguments.searchTerm) ){
			// like disjunctions
			c.createAlias("activeContent","ac");
			c.or( c.restrictions.like("title","%#arguments.searchTerm#%"),
				  c.restrictions.isEq("ac.content", "%#arguments.searchTerm#%") );
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
		results.content = c.list(offset=arguments.offset,max=arguments.max,sortOrder=sortOrder,asQuery=arguments.asQuery);
		
		return results;
	}

}