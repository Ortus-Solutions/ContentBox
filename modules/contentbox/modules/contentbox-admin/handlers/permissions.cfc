/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage Permissions
 */
component extends="baseHandler"{

	// Dependencies
	property name="permissionService"		inject="id:permissionService@cb";

	/**
	 * Pre handler
	 *
	 * @event
	 * @action
	 * @eventArguments
	 * @rc
	 * @prc
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		// Tab control
		prc.tabUsers = true;
	}

	/**
	 * Manage permissions
	 *
	 * @event
	 * @rc
	 * @prc
	 */
	function index( event, rc, prc ){
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

	/**
	 * Save permissions
	 *
	 * @event
	 * @rc
	 * @prc
	 */
	function save( event, rc, prc ){
		// UCASE permission
		rc.permission = ucase( rc.permission );
		// populate and get
		var oPermission = populateModel( permissionService.get( id=rc.permissionID ) );
		var vResults 	= validateModel( oPermission );

		// Validation Results
		if( !vResults.hasErrors() ){
			// announce event
			announceInterception( "cbadmin_prePermissionSave", { permission=oPermission, permissionID=rc.permissionID } );
			// save permission
			permissionService.save( oPermission );
			// announce event
			announceInterception( "cbadmin_postPermissionSave", { permission=oPermission } );
			// messagebox
			cbMessagebox.setMessage( "info", "Permission saved!" );

		} else {
			// messagebox
			cbMessagebox.warning( messageArray=vResults.getAllErrors() );
		}
		// relocate
		relocate( prc.xehPermissions );
	}

	/**
	 * Remove permissions
	 *
	 * @event
	 * @rc
	 * @prc
	 */
	function remove( event, rc, prc ){
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
		relocate( prc.xehPermissions );
	}

	/**
	 * Export all permissions
	 */
	function exportAll( event, rc, prc ){
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

	/**
	 * Import permissions
	 *
	 * @event
	 * @rc
	 * @prc
	 */
	function importAll( event, rc, prc ){
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
		relocate( prc.xehPermissions );
	}
}
