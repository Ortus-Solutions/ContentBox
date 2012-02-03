/**
* A generic content service for content objects
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	/**
	* Constructor
	*/
	ContentService function init(){
		// init it
		super.init(entityName="cbContent");
		
		return this;
	}
	
		
}