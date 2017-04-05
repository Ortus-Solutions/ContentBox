/**
* Manage permissions
*/
component extends="baseHandler"{

	// Dependencies
	property name="permissionService"		inject="id:permissionService@cb";
	
	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab control
		prc.tabUsers = true;
	}
	
	// index
	function index(event,rc,prc){
		// exit Handlers
		prc.xehPermissionRemove = "#prc.cbAdminEntryPoint#.permissions.remove";
		prc.xehPermissionSave 	= "#prc.cbAdminEntryPoint#.permissions.save";
		prc.xehExportAll 		= "#prc.cbAdminEntryPoint#.permissions.exportAll";
		prc.xehImportAll		= "#prc.cbAdminEntryPoint#.permissions.importAll";
		
		// Get all permissions
		prc.permissions = permissionService.list(sortOrder="permission",asQuery=false);
		// Tab
		prc.tabUsers_Permissions = true;
		// view
		event.setView( "permissions/index" );
	}

	// save
	function save(event,rc,prc){
		// UCASE permission
		rc.permission = ucase( rc.permission );
		// populate and get
		var oPermission = populateModel( permissionService.get(id=rc.permissionID) );
    	// announce event
		announceInterception( "cbadmin_prePermissionSave",{permission=oPermission,permissionID=rc.permissionID} );
		// save permission
		permissionService.save( oPermission );
		// announce event
		announceInterception( "cbadmin_postPermissionSave",{permission=oPermission} );
		// messagebox
		cbMessagebox.setMessage( "info","Permission saved!" );
		// relocate
		setNextEvent( prc.xehPermissions );
	}
	
	// remove
	function remove(event,rc,prc){
		// announce event
		announceInterception( "cbadmin_prePermissionRemove",{permissionID=rc.permissionID} );
		// delete by id
		if( !permissionService.deletePermission( rc.permissionID ) ){
			cbMessagebox.setMessage( "warning","Invalid Permission detected!" );
		}
		else{
			// announce event
			announceInterception( "cbadmin_postPermissionRemove",{permissionID=rc.permissionID} );
			// Message
			cbMessagebox.setMessage( "info","Permission and all relationships Removed!" );
		}
		setNextEvent( prc.xehPermissions );
	}
	
	// Export All Permissions
	function exportAll(event,rc,prc){
		event.paramValue( "format", "json" );
		// get all prepared content objects
		var data  = permissionService.getAllForExport();
		
		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "Permissions." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=data, type=rc.format, xmlRootName="permissions" )
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#" ); ; 
				break;
			}
			default:{
				event.renderData(data="Invalid export type: #rc.format#" );
			}
		}
	}
	
	// import settings
	function importAll(event,rc,prc){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try{
			if( len( rc.importFile ) and fileExists( rc.importFile ) ){
				var importLog = permissionService.importFromFile( importFile=rc.importFile, override=rc.overrideContent );
				cbMessagebox.info( "Permissions imported sucessfully!" );
				flash.put( "importLog", importLog );
			}
			else{
				cbMessagebox.error( "The import file is invalid: #rc.importFile# cannot continue with import" );
			}
		}
		catch(any e){
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			cbMessagebox.error( errorMessage );
		}
		setNextEvent( prc.xehPermissions );
	}
}
