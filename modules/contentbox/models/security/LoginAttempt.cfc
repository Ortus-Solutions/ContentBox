/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Store logins from admin attempts. Depending on system settings, users can be blocked via this entity
*/
component 	persistent="true" 
			table="cb_loginAttempts" 
			entityName="cbLoginAttempt" 
			extends="contentbox.models.BaseEntity"
			cachename="loginAttempt" 
			cacheuse="read-write"{

	/* *********************************************************************
	**							PROPERTIES									
	********************************************************************* */

	/**
	* Primary key
	*/
	property 	name="loginAttemptsID" 
				fieldtype="id" 
				generator="native" 
				setter="false"
				params="{ allocationSize = 1, sequence = 'loginAttemptsID_seq' }";
	/**
	* The username attempt value
	*/
	property 	name="value" 		
				notnull="true" 
				default="" 
				length="255"
				index="idx_values";
	/**
	* How many attempts in the system
	*/
	property 	name="attempts" 	
				ormtype="integer"  
				notnull="true"  
				default="0";
	/**
	* Tracks the last successful login IP address
	*/
	property 	name="lastLoginSuccessIP"	
				notnull="false"
				length="100";
	/**
	* Verifies if tracking is blocked or not
	*/
	property 	name="isBlocked"	
				persistent="false" 
				default="false" 
				type="boolean";
		
	/* *********************************************************************
	**							PK+CONSTRAINTS									
	********************************************************************* */

	this.pk = "loginAttemptsID";

	/* *********************************************************************
	**							PUBLIC FUNCTIONS									
	********************************************************************* */

	/**
	* Constructor
	*/
	function init(){
		variables.createdDate 	= now();
		variables.attempts 		= 0;
		variables.isBlocked 	= false;

		super.init();
		
		return this;
	}

	/**
	* Get memento representation
	*/
	function getMemento( excludes="" ){
		var pList 	= listToArray( "value,attempts,lastLoginSuccessIP,isBlocked" );
		var result 	= getBaseMemento( properties=pList, excludes=arguments.excludes );
		
		return result;
	}

}