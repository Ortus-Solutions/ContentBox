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
* A cool Role entity
*/
component persistent="true" entityName="cbRole" table="cb_role" cachename="cbRole" cacheuse="read-write"{
	// DI
	property name="permissionService" 	inject="permissionService@cb" persistent="false";
	
	// Primary Key
	property name="roleID" fieldtype="id" generator="native" setter="false";
	
	// Properties
	property name="role"  		ormtype="string" notnull="true" length="255" unique="true" default="";
	property name="description" ormtype="string" notnull="false" default="" length="500";
	
	// M2M -> Permissions
	property name="permissions" singularName="permission" fieldtype="many-to-many" type="array" lazy="extra" orderby="permission" cascade="all" cacheuse="read-write"  
			  cfc="contentbox.model.security.Permission" fkcolumn="FK_roleID" linktable="cb_rolePermissions" inversejoincolumn="FK_permissionID"; 
	
	// Calculated Fields
	property name="numberOfPermissions" formula="select count(*) from cb_rolePermissions as rolePermissions where rolePermissions.FK_roleID=roleID";
	property name="numberOfAuthors" 	formula="select count(*) from cb_author as author where author.FK_roleID=roleID";
	
	// Non-Persistable Fields
	property name="permissionList" 	persistent="false";
	
	// Constructor
	function init(){
		permissions 	= [];
		permissionList	= '';
		return this;
	}

	/**
	* Get the role name, same as getRole()
	*/
	string function getName(){
		return variables.role;
	}
	
	/**
	* Check for permission
	* @slug.hint The permission slug or list of slugs to validate the role has. If it's a list then they are ORed together
	*/
	boolean function checkPermission(required slug){
		// cache list
		if( !len( permissionList ) AND hasPermission() ){
			var q = entityToQuery( getPermissions() );
			permissionList = valueList( q.permission );	
		}
		
		// Do verification checks
		var aList = listToArray( arguments.slug );
		var isFound = false;
		
		for( var thisPerm in aList ){
			if( listFindNoCase( permissionList, trim( thisPerm ) ) ){
				isFound = true;
				break;
			}
		}
		
		return isFound;
	}
	
	/**
	* Clear all permissions
	*/
	Role function clearPermissions(){
		permissions = [];
		return this;
	}
	
	/**
	* Override the setPermissions
	*/
	Role function setPermissions(required array permissions){
		if( hasPermission() ){
			variables.permissions.clear();
			variables.permissions.addAll( arguments.permissions );
		}
		else{
			variables.permissions = arguments.permissions;
		}
		return this;
	}
	
	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return ( len( getRoleID() ) ? true : false );
	}
	
	/**
	* Get memento representation
	*/
	function getMemento(){
		var pList = listToArray( "roleID,role,description" );
		var result = {};
		
		for(var thisProp in pList ){
			if( structKeyExists( variables, thisProp ) ){
				result[ thisProp ] = variables[ thisProp ];	
			}
			else{
				result[ thisProp ] = "";
			}
		}
		
		// Do Permissions
		if( hasPermission() ){
			result[ "permissions" ]= [];
			for( var thisPerm in variables.permissions ){
				arrayAppend( result[ "permissions" ], thisPerm.getMemento() );
			}
		}
		else{
			result[ "permissions" ] = [];
		}
		
		return result;
	}
	
}
