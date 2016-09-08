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
* Permissions service for contentbox
*/
component extends="cborm.models.VirtualEntityService" singleton{
	
	// DI
	property name="populator" 			inject="wirebox:populator";
	property name="dateUtil"			inject="DateUtil@cb";
	
	/**
	* Constructor
	*/
	PermissionService function init(){
		// init it
		super.init( entityName="cbPermission" );
		
		return this;
	}
	
	/**
	* Delete a Permission which also removes itself from all many-to-many relationships
	* @permissionID The permission ID to remove
	*/
	boolean function deletePermission( required permissionID ){
		transaction{
			// We do SQL deletions as those relationships are not bi-directional
			// delete role relationships
			var q = new Query(sql="delete from cb_rolePermissions where FK_permissionID = :permissionID" );
			q.addParam(name="permissionID", value=arguments.permissionID, cfsqltype="numeric" );
			q.execute();
			// delete user relationships
			var q = new Query(sql="delete from cb_authorPermissions where FK_permissionID = :permissionID" );
			q.addParam(name="permissionID", value=arguments.permissionID, cfsqltype="numeric" );
			q.execute();
			// delete permission now
			var q = new Query(sql="delete from cb_permission where permissionID = :permissionID" );
			q.addParam(name="permissionID", value=arguments.permissionID, cfsqltype="numeric" );
			q.execute();
		}
		
		return true;
	}
	
	/**
	* Get all data prepared for export
	*/
	array function getAllForExport(){
		var c = newCriteria();
		
		return c.withProjections( property="permissionID,permission,description,createdDate,modifiedDate,isDeleted" )
			.resultTransformer( c.ALIAS_TO_ENTITY_MAP )
			.list( sortOrder="permission" );
			 
	}
	
	/**
	* Import data from a ContentBox JSON file. Returns the import log
	*/
	string function importFromFile(required importFile, boolean override=false){
		var data 		= fileRead( arguments.importFile );
		var importLog 	= createObject( "java", "java.lang.StringBuilder" ).init( "Starting import with override = #arguments.override#...<br>" );
		
		if( !isJSON( data ) ){
			throw(message="Cannot import file as the contents is not JSON", type="InvalidImportFormat" );
		}
		
		// deserialize packet: Should be array of { settingID, name, value }
		return	importFromData( deserializeJSON( data ), arguments.override, importLog );
	}
	
	/**
	* Import data from an array of structures of permissions or just one structure of permissions 
	*/
	string function importFromData(required importData, boolean override=false, importLog){
		var allPermissions = [];
		
		// if struct, inflate into an array
		if( isStruct( arguments.importData ) ){
			arguments.importData = [ arguments.importData ];
		}
		
		// iterate and import
		for( var thisPermission in arguments.importData ){
			// Get new or persisted
			var oPermission = this.findByPermission( thisPermission.permission );
			oPermission = ( isNull( oPermission) ? new() : oPermission );
			
			// date cleanups, just in case.
			var badDateRegex  				= " -\d{4}$";
			thisPermission.createdDate 		= reReplace( thisPermission.createdDate, badDateRegex, "" );
			thisPermission.modifiedDate 	= reReplace( thisPermission.modifiedDate, badDateRegex, "" );
			// Epoch to Local
			thisPermission.createdDate 		= dateUtil.epochToLocal( thisPermission.createdDate );
			thisPermission.modifiedDate 	= dateUtil.epochToLocal( thisPermission.modifiedDate );

			// populate content from data
			populator.populateFromStruct( 
				target 				= oPermission, 
				memento 			= thisPermission, 
				exclude 			= "permissionID", 
				composeRelationships= false 
			);
			
			// if new or persisted with override then save.
			if( !oPermission.isLoaded() ){
				arguments.importLog.append( "New permission imported: #thisPermission.permission#<br>" );
				arrayAppend( allPermissions, oPermission );
			}
			else if( oPermission.isLoaded() and arguments.override ){
				arguments.importLog.append( "Persisted permission overriden: #thisPermission.permission#<br>" );
				arrayAppend( allPermissions, oPermission );
			}
			else{
				arguments.importLog.append( "Skipping persisted permission: #thisPermission.permission#<br>" );
			}
		} // end import loop

		// Save them?
		if( arrayLen( allPermissions ) ){
			saveAll( allPermissions );
			arguments.importLog.append( "Saved all imported and overriden permissions!" );
		}
		else{
			arguments.importLog.append( "No permissions imported as none where found or able to be overriden from the import file." );
		}
		
		return arguments.importLog.toString(); 
	}
	
}