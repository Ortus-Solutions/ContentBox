/**
* Permissions service for contentbox
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	/**
	* Constructor
	*/
	PermissionService function init(){
		// init it
		super.init(entityName="cbPermission");
		
		return this;
	}
	
}