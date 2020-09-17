/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage Permission Groups
 */
component extends="baseHandler" {

	// Dependencies
	property name="permissionGroupService" inject="id:permissionGroupService@cb";
	property name="permissionService" inject="id:permissionService@cb";

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
			model               : permissionGroupService.get( id = rc.permissionGroupID ),
			composeRelationships: true
		);

		// Validate
		var vResults = validateModel( oGroup );
		if ( !vResults.hasErrors() ) {
			// announce event
			announce(
				"cbadmin_prePermissionGroupSave",
				{ group : oGroup, permissionGroupID : rc.permissionGroupID }
			);
			// save group
			permissionGroupService.save( oGroup );
			// announce event
			announce( "cbadmin_postPermissionGroupSave", { group : oGroup } );
			// messagebox
			cbMessagebox.setMessage( "info", "Permission Group saved!" );
		} else {
			// messagebox
			cbMessagebox.warning( messageArray = vResults.getAllErrors() );
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
		// Get requested role and remove permissions and authors
		var oGroup = permissionGroupService
			.get( id = rc.permissionGroupID )
			.clearPermissions()
			.clearAuthors();
		// finally delete
		permissionGroupService.delete( oGroup );
		// announce event
		announce(
			"cbadmin_postPermissionGroupRemove",
			{ permissionGroupID : rc.permissionGroupID }
		);
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
		prc.aPermissions           = variables.permissionService.list(
			sortOrder = "permission",
			asQuery   = false
		);
		// Exit handlers
		prc.xehGroupSave = "#prc.cbAdminEntryPoint#.permissionGroups.save";
		// View
		event.setView( "permissionGroups/editor" );
	}

	/**
	 * Export permission group
	 */
	function export( event, rc, prc ){
		event.paramValue( "format", "json" );
		// get group
		prc.oGroup = permissionGroupService.get( event.getValue( "permissionGroupID", 0 ) );

		// relocate if not existent
		if ( !prc.oGroup.isLoaded() ) {
			cbMessagebox.warn( "permissionGroupID sent is not valid" );
			relocate( prc.xehPermissionGroups );
		}

		// writeDump( prc.oGroup.getMemento() );abort;
		switch ( rc.format ) {
			case "xml":
			case "json": {
				var filename = "#prc.oGroup.getName()#." & ( rc.format eq "xml" ? "xml" : "json" );
				event
					.renderData(
						data        = prc.oGroup.getMemento(),
						type        = rc.format,
						xmlRootName = "permissionGroup"
					)
					.setHTTPHeader(
						name  = "Content-Disposition",
						value = " attachment; filename=#fileName#"
					);
				break;
			}
			default: {
				event.renderData( data = "Invalid export type: #rc.format#" );
			}
		}
	}

	/**
	 * Export all entries
	 */
	function exportAll( event, rc, prc ){
		event.paramValue( "format", "json" );
		// get all prepared content objects
		var data = permissionGroupService.getAllForExport();

		switch ( rc.format ) {
			case "xml":
			case "json": {
				var filename = "PermissionGroups." & ( rc.format eq "xml" ? "xml" : "json" );
				event
					.renderData(
						data        = data,
						type        = rc.format,
						xmlRootName = "permissionGroups"
					)
					.setHTTPHeader(
						name  = "Content-Disposition",
						value = " attachment; filename=#fileName#"
					);
				break;
			}
			default: {
				event.renderData( data = "Invalid export type: #rc.format#" );
			}
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
