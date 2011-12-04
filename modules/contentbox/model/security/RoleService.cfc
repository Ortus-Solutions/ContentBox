/**
* Roles service for contentbox
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	/**
	* Constructor
	*/
	RoleService function init(){
		// init it
		super.init(entityName="cbRole");
		
		return this;
	}
	
}