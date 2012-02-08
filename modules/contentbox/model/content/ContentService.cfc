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
			c.isTrue("isPublished");
		}
		content = c.isEq("slug",arguments.slug).get();

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

}