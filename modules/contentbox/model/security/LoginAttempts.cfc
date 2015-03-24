/**

* Store logins from cbadmin. Table used to prevent brute force
*/
component persistent="true" table="cb_loginAttempts" entityName="cbLoginAttempts" cachename="loginAttempts" cacheuse="read-write"{

	// Primary Key
	property name="LoginAttemptsID" fieldtype="id" column="LoginAttemptsID" generator="native" setter="false";
	
	// Properties
	property name="value" 		ormtype="string"  notnull="true" 	default="" length="255";
	property name="attempts" 	ormtype="integer"  notnull="true"  	default="0" length="255";
	property name="createdDate"	ormtype="timestamp"  notnull="true" default="";
	property name="lastLoginSuccessIP"	ormtype="string"  notnull="true" 	default="" length="45";
	property name="isBlocked"	persistent="false" default="false" type="boolean";
		
	// Constructor
	function init(){
		variables.createdDate = now();
		variables.attempts = 1;
		variables.isBlocked = false;
		return this;
	}
	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return ( len( getLoginAttemptsID() ) ? true : false );
	}
}
