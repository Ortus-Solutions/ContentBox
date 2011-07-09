/**
* Service to handle comment operations.
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	/**
	* Constructor
	*/
	public CommentService function init(){
		
		super.init(entityName="bbComment");
		
		return this;
	}

}