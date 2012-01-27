/**
* Security rules manager
*/
component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton{
	
	/**
	* Constructor
	*/
	SecurityRuleService function init(){
		// init it
		super.init(entityName="cbSecurityRule");
		
		return this;
	}
	
	/**
	* Get the maximum used order
	*/
	numeric function getMaxOrder(){
		var q = executeQuery(query="select max( sr.order ) from cbSecurityRule as sr",asQuery=false);
		if( ArrayIsDefined(q,1) ){ return q[1]; }
		return 0;
	}
	
	/**
	* Get the next maximum used order
	*/
	numeric function getNextMaxOrder(){
		return getMaxOrder()+1;
	}	
	
	/**
    * Save rule
    */
	any function saveRule(required any entity, boolean forceInsert=false, boolean flush=false, boolean transactional=getUseTransactions()){
		
		// determine new or not
		if( !arguments.entity.isLoaded() ){
			// new, so add next max order if not default
			if( arguments.entity.getOrder() EQ 0 ){
				arguments.entity.setOrder( getNextMaxOrder() );
			}
		}
		
		return save(argumentCollection=arguments);
	}
	
	/**
	* Get all rules in firing order
	*/
	query function getSecurityRules(){
		return list(sortOrder="order asc");
	}
}