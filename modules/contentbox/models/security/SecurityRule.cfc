/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A cool SecurityRule entity
*/
component 	persistent="true" 
			table="cb_securityRule" 
			entityName="cbSecurityRule" 
			extends="contentbox.models.BaseEntity"
			cachename="cbSecurityRule" 
			cacheuse="read-write"{

	/* *********************************************************************
	**							PROPERTIES									
	********************************************************************* */

	property 	name="ruleID" 
				fieldtype="id" 
				column="ruleID" 
				generator="native" 
				setter="false" 
				params="{ allocationSize = 1, sequence = 'ruleID_seq' }";

	property 	name="whitelist" 	
				ormtype="string"  	
				notnull="false" 	
				default="" 
				length="255";

	property 	name="securelist" 	
				ormtype="string"  	
				notnull="true" 		
				default="" 
				length="255";

	property 	name="roles" 		
				ormtype="string"  	
				notnull="false"  	
				default="" 
				length="255";

	property 	name="permissions" 	
				ormtype="string"  	
				notnull="false"  	
				default="" 
				length="500";

	property 	name="redirect"		
				ormtype="string"  	
				notnull="true"  	
				default="" 
				length="500";

	property 	name="useSSL"		
				ormtype="boolean" 	
				notnull="false" 	
				default="false";

	property 	name="order"		
				ormtype="integer" 	
				notnull="true" 		
				default="0";

	property 	name="match"		
				ormtype="string"  	
				notnull="false" 	
				default="" 
				length="50";

	property 	name="message"		
				ormtype="string"  	
				notnull="false" 	
				default="" 
				length="255";

	property 	name="messageType"		
				ormtype="string"  	
				notnull="false" 	
				default="info"
				dbdefault="'info'"
				length="50";

	/* *********************************************************************
	**							PK + CONSTRAINTS									
	********************************************************************* */

	this.pk = "ruleID";

	this.constraints = {
		"whitelist"	 			= { required = false, size = "1..255" },
		"securelist"			= { required = false, size = "1..255" },
		"roles"					= { required = false, size = "1..255" },
		"permissions"			= { required = false, size = "1..500" },
		"redirect"				= { required = false, size = "1..500" },
		"order"					= { required = false, type="numeric" },
		"match"					= { required = false, size = "1..50" },
		"message"				= { required = false, size = "1..255" },
		"messageType"			= { required = false, size = "1..50" }
	};

	/* *********************************************************************
	**							PUBLIC FUNCTIONS									
	********************************************************************* */

	// Constructor
	function init(){
		variables.match 		= 'event';
		variables.useSSL 		= false;
		variables.order  		= 0;
		variables.messageType 	= "info";

		super.init();

		return this;
	}
	
	/**
	* Overriden setter
	*/
	SecurityRule function setMatch(required match){
		if( not reFindnocase( "^(event|url)$", arguments.match) ){
			throw(message="Invalid match type sent: #arguments.match#",detail="Valid match types are 'event,url'",type="InvalidMatchType" );
		}
		variables.match = arguments.match;
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
		if( !len(securelist) ){ arrayAppend(errors, "Securelist is required" ); }
		if( !len(redirect) ){ arrayAppend(errors, "Redirect is required" ); }
		
		return errors;
	}

	/**
	* Get memento representation
	*/
	function getMemento( excludes="" ){
		var pList = listToArray( "whitelist,securelist,roles,permissions,redirect,useSSL,order,match,message,messageType" );
		var result 	= getBaseMemento( properties=pList, excludes=arguments.excludes );
		
		return result;
	}
	
}
