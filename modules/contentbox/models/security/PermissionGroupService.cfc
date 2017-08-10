/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Permission Group Service for contentbox
*/
component extends="cborm.models.VirtualEntityService" singleton{
	
	// DI
	property name="populator" 			inject="wirebox:populator";
	property name="permissionService" 	inject="permissionService@cb";
	property name="dateUtil"			inject="DateUtil@cb";
	
	/**
	* Constructor
	*/
	PermissionGroupService function init(){
		// init it
		super.init( entityName="cbPermissionGroup" );
		
		return this;
	}
	
	/**
	* Get all data prepared for export
	*/
	array function getAllForExport(){
		var result 	= [];
		var data 	= getAll();
		
		for( var thisItem in data ){
			arrayAppend( result, thisItem.getMemento() );	
		}
		
		return result;
	}
	
	/**
	* Import data from a ContentBox JSON file. Returns the import log
	*/
	string function importFromFile( required importFile, boolean override=false ){
		var data 		= fileRead( arguments.importFile );
		var importLog 	= createObject( "java", "java.lang.StringBuilder" ).init( "Starting import with override = #arguments.override#...<br>" );
		
		if( !isJSON( data ) ){
			throw( message="Cannot import file as the contents is not JSON", type="InvalidImportFormat" );
		}
		
		// deserialize packet: Should be array of { settingID, name, value }
		return	importFromData( deserializeJSON( data ), arguments.override, importLog );
	}
	
	/**
	* Import data from an array of structures of roles or just one structure of roles 
	*/
	string function importFromData(required importData, boolean override=false, importLog ){
		var allGroups = [];
		
		// if struct, inflate into an array
		if( isStruct( arguments.importData ) ){
			arguments.importData = [ arguments.importData ];
		}
		
		// iterate and import
		for( var thisGroup in arguments.importData ){
			// Get new or persisted
			var oGroup = this.findByName( thisGroup.name );
			oGroup = ( isNull( oGroup ) ? new() : oGroup );
			
			// date cleanups, just in case.
			var badDateRegex  	= " -\d{4}$";
			thisGroup.createdDate 	= reReplace( thisGroup.createdDate, badDateRegex, "" );
			thisGroup.modifiedDate 	= reReplace( thisGroup.modifiedDate, badDateRegex, "" );
			// Epoch to Local
			thisGroup.createdDate 	= dateUtil.epochToLocal( thisGroup.createdDate );
			thisGroup.modifiedDate 	= dateUtil.epochToLocal( thisGroup.modifiedDate );

			// populate content from data
			populator.populateFromStruct( 
				target				 = oGroup, 
				memento				 = thisGroup, 
				exclude				 = "permissionGroupID", 
				composeRelationships = false 
			);
			
			// PERMISSIONS
			if( arrayLen( thisGroup.permissions ) ){
				// Create permissions that don't exist first
				var allPermissions = [];
				for( var thisPermission in thisGroup.permissions ){
					var oPerm = permissionService.findByPermission( thisPermission.permission );
					oPerm = ( isNull( oPerm ) ? populator.populateFromStruct( target=permissionService.new(), memento=thisPermission, exclude="permissionID" ) : oPerm );	
					// save oPerm if new only
					if( !oPerm.isLoaded() ){ permissionService.save( entity=oPerm ); }
					// append to add.
					arrayAppend( allPermissions, oPerm );
				}
				// detach permissions and re-attach
				oGroup.setPermissions( allPermissions );
			}
			
			// if new or persisted with override then save.
			if( !oGroup.isLoaded() ){
				arguments.importLog.append( "New permission group imported: #thisGroup.name#<br>" );
				arrayAppend( allGroups, oGroup );
			}
			else if( oGroup.isLoaded() and arguments.override ){
				arguments.importLog.append( "Persisted permission group overriden: #thisGroup.name#<br>" );
				arrayAppend( allGroups, oGroup );
			}
			else{
				arguments.importLog.append( "Skipping permission group: #thisGroup.name#<br>" );
			}
		} // end import loop

		// Save them?
		if( arrayLen( allGroups ) ){
			saveAll( allGroups );
			arguments.importLog.append( "Saved all imported and overriden permission groups!" );
		}
		else{
			arguments.importLog.append( "No permission groups imported as none where found or able to be overriden from the import file." );
		}
		
		return arguments.importLog.toString(); 
	}
	
}