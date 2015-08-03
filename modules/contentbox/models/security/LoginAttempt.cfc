/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License" );
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
* Store logins from cbadmin. Entity used to prevent brute force
*/
component persistent="true" table="cb_loginAttempts" entityName="cbLoginAttempt" cachename="loginAttempt" cacheuse="read-write"{

	// Primary Key
	property 	name="loginAttemptsID" 
				fieldtype="id" 
				generator="native" 
				setter="false";
	
	// Properties
	property 	name="value" 		
				notnull="true" 
				default="" 
				length="255"
				index="idx_values";

	property 	name="attempts" 	
				ormtype="integer"  
				notnull="true"  
				default="0";

	property 	name="createdDate"	
				ormtype="timestamp"  
				notnull="true"
				default=""
				index="idx_createdDate";

	property 	name="lastLoginSuccessIP"	
				notnull="false"
				length="100";

	// Non-persisted property
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
		return LSDateFormat( createdDate, "mm/dd/yyyy" ) & " " & LSTimeFormat( createdDate, "hh:mm:ss tt" );
	}
}
