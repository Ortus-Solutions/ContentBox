/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage Permissions
 */
component extends="baseHandler" {

	// Dependencies
	property name="permissionService" inject="permissionService@contentbox";

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
		prc.xehPermissionSave   = "#prc.cbAdminEntryPoint#.permissions.save";
		prc.xehExport           = "#prc.cbAdminEntryPoint#.permissions.export";
		prc.xehExportAll        = "#prc.cbAdminEntryPoint#.permissions.exportAll";
		prc.xehImportAll        = "#prc.cbAdminEntryPoint#.permissions.importAll";

		// Get all permissions
		prc.permissions          = permissionService.list( sortOrder = "permission" );
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
		rc.permission   = uCase( rc.permission );
		// populate and get
		var oPermission = populateModel( model: permissionService.get( rc.permissionID ), exclude: "permissionID" );
		var vResults    = validate( oPermission );

		// Validation Results
		if ( !vResults.hasErrors() ) {
			// announce event
			announce( "cbadmin_prePermissionSave", { permission : oPermission, permissionID : rc.permissionID } );
			// save permission
			permissionService.save( oPermission );
			// announce event
			announce( "cbadmin_postPermissionSave", { permission : oPermission } );
			// messagebox
			cbMessagebox.setMessage( "info", "Permission saved!" );
		} else {
			// messagebox
			cbMessagebox.warning( vResults.getAllErrors() );
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
		announce( "cbadmin_prePermissionRemove", { permissionID : rc.permissionID } );
		// delete by id
		if ( !permissionService.deletePermission( rc.permissionID ) ) {
			cbMessagebox.setMessage( "warning", "Invalid Permission detected!" );
		} else {
			// announce event
			announce( "cbadmin_postPermissionRemove", { permissionID : rc.permissionID } );
			// Message
			cbMessagebox.setMessage( "info", "Permission and all relationships Removed!" );
		}
		relocate( prc.xehPermissions );
	}

	/**
	 * Export a permission
	 */
	function export( event, rc, prc ){
		return variables.permissionService.get( event.getValue( "permissionID", 0 ) ).getMemento();
	}

	/**
	 * Export all permissions as json/xml
	 */
	function exportAll( event, rc, prc ){
		param rc.permissionID = "";
		// Export all or some
		if ( len( rc.permissionID ) ) {
			return rc.permissionID
				.listToArray()
				.map( function( id ){
					return variables.permissionService.get( arguments.id ).getMemento( profile: "export" );
				} );
		} else {
			return variables.permissionService.getAllForExport();
		}
	}

	/**
	 * Import permissions
	 */
	function importAll( event, rc, prc ){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try {
			if ( len( rc.importFile ) and fileExists( rc.importFile ) ) {
				var importLog = variables.permissionService.importFromFile(
					importFile = rc.importFile,
					override   = rc.overrideContent
				);
				cbMessagebox.info( "Permissions imported sucessfully!" );
				flash.put( "importLog", importLog );
			} else {
				cbMessagebox.error( "The import file is invalid: #rc.importFile# cannot continue with import" );
			}
		} catch ( any e ) {
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			cbMessagebox.error( errorMessage );
		}
		relocate( prc.xehPermissions );
	}

}
