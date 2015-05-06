/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
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
* A cool Permission entity
*/
component persistent="true" entityName="cbPermission" table="cb_permission" cachename="cbPermission" cacheuse="read-write"{

	// Primary Key
	property name="permissionID" fieldtype="id" generator="native" setter="false";
	
	// Properties
	property name="permission"  ormtype="string" notnull="true" length="255" unique="true" default="";
	property name="description" ormtype="string" notnull="false" default="" length="500";
	
	// Calculated Fields
	property name="numberOfRoles" formula="select count(*) from cb_rolePermissions as rolePermissions where rolePermissions.FK_permissionID=permissionID";
	
	// Constructor
	function init(){
		return this;
	}
	
	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return ( len( getPermissionID() ) ? true : false );
	}
	
	/**
	* Get memento representation
	*/
	function getMemento(){
		var pList = listToArray( "permissionID,permission,description,numberOfRoles" );
		var result = {};
		
		for(var thisProp in pList ){
			if( structKeyExists( variables, thisProp ) ){
				result[ thisProp ] = variables[ thisProp ];	
			}
			else{
				result[ thisProp ] = "";
			}
		}
		
		return result;
	}
	
	
}
