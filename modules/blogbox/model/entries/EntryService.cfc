/**
* Entry service for BlogBox
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	/**
	* Constructor
	*/
	EntryService function init(){
		// init it
		super.init(entityName="bbEntry");
		
		return this;
	}
	
}