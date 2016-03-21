/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Store logins from admin attempts. Depending on system settings, users can be blocked via this entity
*/
component persistent="true" table="cb_loginAttempts" entityName="cbLoginAttempt" cachename="loginAttempt" cacheuse="read-write"{

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
	* Attempt timestamp
	*/
	property 	name="createdDate"	
				ormtype="timestamp"  
				notnull="true"
				default=""
				index="idx_loginCreatedDate";

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
		
	/**
	* Constructor
	*/
	function init(){
		variables.createdDate 	= now();
		variables.attempts 		= 0;
		variables.isBlocked 	= false;

		return this;
	}

	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return ( len( getLoginAttemptsID() ) ? true : false );
	}

	/**
	* Get formatted createdDate
	*/
	string function getDisplayCreatedDate(){
		var createdDate = getCreatedDate();
		if( isNull( createdDate ) ){ return ""; }
		return LSDateFormat( createdDate, "dd mmm yyyy" ) & " " & LSTimeFormat( createdDate, "hh:mm tt" );
	}

}