/**
* A cool SecurityRule entity
*/
component persistent="true" table="cb_securityRule" entityName="cbSecurityRule"{

	// Primary Key
	property name="ruleID" fieldtype="id" column="ruleID" generator="native" setter="false";
	
	// Properties
	property name="whitelist" 	ormtype="string"  notnull="false" 	default="" length="255";	property name="securelist" 	ormtype="string"  notnull="true" 	default="" length="255";	property name="roles" 		ormtype="string"  notnull="false"  	default="" length="255";	property name="permissions" ormtype="string"  notnull="false"  	default="" length="500";	property name="redirect"	ormtype="string"  notnull="true"  	default="" length="500";
	property name="useSSL"		ormtype="boolean" notnull="false" 	default="false" dbdefault="0";
	property name="order"		ormtype="integer" notnull="true" 	default="0" dbdefault="0";
	
	// Constructor
	function init(){
		return this;
	}
	
	/*
	* Validate entry, returns an array of error or no messages
	*/
	array function validate(){
		var errors = [];
		
		// limits
		securelist		= left(securelist,255);
		whitelist		= left(whitelist,255);
		roles			= left(roles,500);
		permissions		= left(permissions,500);
		redirect		= left(redirect,255);
		
		// Required
		if( !len(securelist) ){ arrayAppend(errors, "Securelist is required"); }
		if( !len(redirect) ){ arrayAppend(errors, "Redirect is required"); }
		
		return errors;
	}
	
	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getRuleID() );
	}
	
}
