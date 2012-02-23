/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
* A cool SecurityRule entity
*/
component persistent="true" table="cb_securityRule" entityName="cbSecurityRule"{

	// Primary Key
	property name="ruleID" fieldtype="id" column="ruleID" generator="native" setter="false";
	
	// Properties
	property name="whitelist" 	ormtype="string"  notnull="false" 	default="" length="255";	property name="securelist" 	ormtype="string"  notnull="true" 	default="" length="255";	property name="roles" 		ormtype="string"  notnull="false"  	default="" length="255";	property name="permissions" ormtype="string"  notnull="false"  	default="" length="500";	property name="redirect"	ormtype="string"  notnull="true"  	default="" length="500";
	property name="useSSL"		ormtype="boolean" notnull="false" 	default="false" dbdefault="0";
	property name="order"		ormtype="integer" notnull="true" 	default="0" dbdefault="0";
	property name="match"		ormtype="string"  notnull="false" 	default="" length="50";
	
	// Constructor
	SecurityRule function init(){
		setMatch('event');
		return this;
	}
	
	/**
	* Overriden setter
	*/
	function setMatch(required match){
		if( not reFindnocase("^(event|url)$", arguments.match) ){
			throw(message="Invalid match type sent: #arguments.match#",detail="Valid match types are 'event,url'",type="InvalidMatchType");
		}
		variables.match = arguments.match;
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
