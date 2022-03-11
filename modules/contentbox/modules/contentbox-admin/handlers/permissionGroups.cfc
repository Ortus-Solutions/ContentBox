/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage Permission Groups
 */
component extends="baseHandler" {

	// Dependencies
	property name="permissionGroupService" inject="permissionGroupService@contentbox";
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
	 * List Groups
	 */
	function index( event, rc, prc ){
		// exit Handlers
		prc.xehGroupRemove      = "#prc.cbAdminEntryPoint#.permissionGroups.remove";
		prc.xehGroupEditor      = "#prc.cbAdminEntryPoint#.permissionGroups.editor";
		prc.xehGroupSave        = "#prc.cbAdminEntryPoint#.permissionGroups.save";
		prc.xehGroupPermissions = "#prc.cbAdminEntryPoint#.permissionGroups.permissions";
		prc.xehExport           = "#prc.cbAdminEntryPoint#.permissionGroups.export";
		prc.xehExportAll        = "#prc.cbAdminEntryPoint#.permissionGroups.exportAll";
		prc.xehImportAll        = "#prc.cbAdminEntryPoint#.permissionGroups.importAll";

		// Get all groups
		prc.aGroups                   = permissionGroupService.list( sortOrder = "name", asQuery = false );
		// Tab
		prc.tabUsers_permissionGroups = true;
		// view
		event.setView( "permissionGroups/index" );
	}

	/**
	 * Save groups
	 */
	function save( event, rc, prc ){
		// Inflate the right Permissions according to toggle pattern: permissions_id_toggle
		rc.permissions = rc
			.filter( function( key, value ){
				return key.findNoCase( "permissions_" );
			} )
			.reduce( function( results, key, value ){
				results.append( getToken( key, "2", "_" ) );
				return results;
			}, [] );

		// populate and get
		var oGroup = populateModel(
			model               : permissionGroupService.get( rc.permissionGroupID ),
			composeRelationships: true,
			exclude             : "permissionGroupID"
		);

		// Validate
		var vResults = validate( oGroup );
		if ( !vResults.hasErrors() ) {
			// announce event
			announce( "cbadmin_prePermissionGroupSave", { group : oGroup, permissionGroupID : rc.permissionGroupID } );
			// save group
			permissionGroupService.save( oGroup );
			// announce event
			announce( "cbadmin_postPermissionGroupSave", { group : oGroup } );
			// messagebox
			cbMessagebox.setMessage( "info", "Permission Group saved!" );
		} else {
			// messagebox
			cbMessagebox.warning( vResults.getAllErrors() );
		}
		// relocate
		relocate( prc.xehPermissionGroups );
	}

	/**
	 * Remove a group
	 */
	function remove( event, rc, prc ){
		// announce event
		announce( "cbadmin_prePermissionGroupRemove", { permissionGroupID : rc.permissionGroupID } );

		var allGroups = permissionGroupService.getAll( rc.permissionGroupID );

		for ( var oGroup in allGroups ) {
			// Get requested role and remove permissions and authors
			oGroup.clearPermissions().clearAuthors();

			// finally delete
			permissionGroupService.delete( oGroup );
		}

		// announce event
		announce( "cbadmin_postPermissionGroupRemove", { permissionGroupID : rc.permissionGroupID } );
		// Message
		cbMessagebox.setMessage( "info", "Permission Group Removed!" );
		// relocate
		relocate( prc.xehPermissionGroups );
	}


	/**
	 * Create or Edit Groups
	 */
	function editor( event, rc, prc ){
		param rc.permissionGroupID = 0;
		// Get or fail
		prc.oGroup                 = variables.permissionGroupService.get( rc.permissionGroupID );
		// Load permissions
		prc.aPermissions           = variables.permissionService.list( sortOrder = "permission", asQuery = false );
		// Exit handlers
		prc.xehGroupSave           = "#prc.cbAdminEntryPoint#.permissionGroups.save";
		// View
		event.setView( "permissionGroups/editor" );
	}

	/**
	 * Export a permission group
	 */
	function export( event, rc, prc ){
		return variables.permissionGroupService.get( event.getValue( "permissionGroupID", 0 ) ).getMemento();
	}

	/**
	 * Export all entries
	 */
	function exportAll( event, rc, prc ){
		param rc.permissionGroupID = "";
		// Export all or some
		if ( len( rc.permissionGroupID ) ) {
			return rc.permissionGroupID
				.listToArray()
				.map( function( id ){
					return variables.permissionGroupService.get( arguments.id ).getMemento( profile: "export" );
				} );
		} else {
			return variables.permissionGroupService.getAllForExport();
		}
	}

	/**
	 * Import all permission groups
	 */
	function importAll( event, rc, prc ){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try {
			if ( len( rc.importFile ) and fileExists( rc.importFile ) ) {
				var importLog = permissionGroupService.importFromFile(
					importFile = rc.importFile,
					override   = rc.overrideContent
				);
				cbMessagebox.info( "Permission Groups imported sucessfully!" );
				flash.put( "importLog", importLog );
			} else {
				cbMessagebox.error(
					"The import file is invalid: #encodeForHTML( rc.importFile )# cannot continue with import"
				);
			}
		} catch ( any e ) {
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			cbMessagebox.error( errorMessage );
		}
		relocate( prc.xehPermissionGroups );
	}

}
