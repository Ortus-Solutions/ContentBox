/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A cool Permission entity
*/
component 	persistent="true" 
			entityName="cbPermission" 
			table="cb_permission"
			extends="contentbox.models.BaseEntity"
			cachename="cbPermission" 
			cacheuse="read-write"{

	/* *********************************************************************
	**							PROPERTIES									
	********************************************************************* */

	property 	name="permissionID" 
				fieldtype="id" 
				generator="native" 
				setter="false"  
				params="{ allocationSize = 1, sequence = 'permissionID_seq' }";
	
	property 	name="permission"  
				ormtype="string" 
				notnull="true" 
				length="255" 
				unique="true" 
				default="";

	property 	name="description" 
				ormtype="string" 
				notnull="false" 
				default="" 
				length="500";
	
	/* *********************************************************************
	**							CALCULATED FIELDS									
	********************************************************************* */

	// Calculated Fields
	property 	name="numberOfRoles" 
				formula="select count(*) from cb_rolePermissions as rolePermissions 
						where rolePermissions.FK_permissionID=permissionID";

	/* *********************************************************************
	**							PK + CONSTRAINTS									
	********************************************************************* */

	this.pk = "permissionID";

	/* *********************************************************************
	**							PUBLIC FUNCITONS									
	********************************************************************* */

	/**
	* Constructor
	*/
	function init(){
		super.init();
		return this;
	}
	
	/**
	* Get memento representation
	*/
	function getMemento(){
		var pList = listToArray( "permissionID,permission,description,numberOfRoles" );
		var result = {};
		
		for( var thisProp in pList ){
			if( structKeyExists( variables, thisProp ) ){
				result[ thisProp ] = variables[ thisProp ];	
			} else {
				result[ thisProp ] = "";
			}
		}
		
		return result;
	}
	
}