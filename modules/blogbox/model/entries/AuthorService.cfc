/**
* Service to handle auhtor operations.
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	/**
	* Constructor
	*/
	public AuthorService function init(){
		// init it
		super.init(entityName="bbAuthor");
	    
		return this;
	}

}