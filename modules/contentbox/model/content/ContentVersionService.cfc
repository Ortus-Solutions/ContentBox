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
	
	
	
}