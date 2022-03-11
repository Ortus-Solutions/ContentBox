/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage roles
 */
component extends="baseHandler" {

	// Dependencies
	property name="roleService" inject="roleService@contentbox";
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
	 * Manage roles
	 *
	 * @event
	 * @rc   
	 * @prc  
	 */
	function index( event, rc, prc ){
		// exit Handlers
		prc.xehRoleRemove      = "#prc.cbAdminEntryPoint#.roles.remove";
		prc.xehRoleEditor      = "#prc.cbAdminEntryPoint#.roles.editor";
		prc.xehRoleSave        = "#prc.cbAdminEntryPoint#.roles.save";
		prc.xehRolePermissions = "#prc.cbAdminEntryPoint#.roles.permissions";
		prc.xehExport          = "#prc.cbAdminEntryPoint#.roles.export";
		prc.xehExportAll       = "#prc.cbAdminEntryPoint#.roles.exportAll";
		prc.xehImportAll       = "#prc.cbAdminEntryPoint#.roles.importAll";

		// Get all roles
		prc.roles          = roleService.list( sortOrder = "role", asQuery = false );
		// Tab
		prc.tabUsers_roles = true;
		// view
		event.setView( "roles/index" );
	}

	/**
	 * Save Roles
	 *
	 * @event
	 * @rc   
	 * @prc  
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
		prc.oRole = populateModel(
			model               : roleService.get( rc.roleID ),
			composeRelationships: true,
			exclude             : "roleID"
		);

		// Validate
		var vResults = validate( prc.oRole );
		if ( !vResults.hasErrors() ) {
			// announce event
			announce( "cbadmin_preRoleSave", { role : prc.oRole, roleID : rc.roleID } );
			// save role
			roleService.save( prc.oRole );
			// announce event
			announce( "cbadmin_postRoleSave", { role : prc.oRole } );
			// messagebox
			cbMessagebox.setMessage( "info", "Role saved!" );
			// relocate
			relocate( prc.xehroles );
		} else {
			// messagebox
			cbMessagebox.warning( vResults.getAllErrors() );
			return editor( argumentCollection = arguments );
		}
	}

	/**
	 * Remove Roles
	 *
	 * @event
	 * @rc   
	 * @prc  
	 */
	function remove( event, rc, prc ){
		// announce event
		announce( "cbadmin_preRoleRemove", { roleID : rc.roleID } );

		var allRoles = roleService.getAll( rc.roleID );

		for ( var oRole in allRoles ) {
			// Get requested role and remove permissions
			oRole.clearPermissions();

			// finally delete
			roleService.delete( oRole );
		}

		// announce event
		announce( "cbadmin_postRoleRemove", { roleID : rc.roleID } );
		// Message
		cbMessagebox.setMessage( "info", "Role Removed!" );
		// relocate
		relocate( prc.xehroles );
	}

	/**
	 * Create or Edit Roles
	 */
	function editor( event, rc, prc ){
		param rc.roleId = 0;
		// Get or fail
		if ( isNull( prc.oRole ) ) {
			prc.oRole = variables.roleService.get( rc.roleId );
		}
		// Load permissions
		prc.aPermissions = variables.permissionService.list( sortOrder = "permission", asQuery = false );
		// Exit handlers
		prc.xehRoleSave  = "#prc.cbAdminEntryPoint#.roles.save";
		// View
		event.setView( "roles/editor" );
	}

	/**
	 * Export a role
	 *
	 * @event
	 * @rc   
	 * @prc  
	 */
	function export( event, rc, prc ){
		return variables.roleService.get( event.getValue( "roleID", 0 ) ).getMemento( includes = "permissions" );
	}

	/**
	 * Export all roles
	 *
	 * @event
	 * @rc   
	 * @prc  
	 */
	function exportAll( event, rc, prc ){
		param rc.roleID = "";
		// Export all or some
		if ( len( rc.roleID ) ) {
			return rc.roleID
				.listToArray()
				.map( function( id ){
					return variables.roleService.get( arguments.id ).getMemento( profile: "export" );
				} );
		} else {
			return variables.roleService.getAllForExport();
		}
	}

	/**
	 * Import roles
	 *
	 * @event
	 * @rc   
	 * @prc  
	 */
	function importAll( event, rc, prc ){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try {
			if ( len( rc.importFile ) and fileExists( rc.importFile ) ) {
				var importLog = roleService.importFromFile( importFile = rc.importFile, override = rc.overrideContent );
				cbMessagebox.info( "Roles imported sucessfully!" );
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
		relocate( prc.xehRoles );
	}

}
