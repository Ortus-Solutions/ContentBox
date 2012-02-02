/**
* Entry service for contentbox
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	/**
	* Constructor
	*/
	ContentVersionService function init(){
		// init it
		super.init(entityName="cbContentVersion");
		
		return this;
	}
	
	struct function findRelatedVersions(required contentID,max=0, offset=0, asQuery=false){
		var results = {};
		
		// Find it
		var c = newCriteria()
			.isEq("relatedContent.contentID", javaCast("int",arguments.contentID));
		
		// run criteria query and projections count
		results.count 		= c.count();
		results.versions 	= c.list(offset=arguments.offset,max=arguments.max,sortOrder="version DESC",asQuery=false);

		return results;
	}
	
	
	
}