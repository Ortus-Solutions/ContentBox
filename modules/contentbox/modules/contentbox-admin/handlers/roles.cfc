/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage roles
 */
component extends="baseHandler"{

	// Dependencies
	property name="roleService"			inject="id:roleService@cb";
	property name="permissionService"	inject="id:permissionService@cb";

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
		prc.xehRoleRemove 		= "#prc.cbAdminEntryPoint#.roles.remove";
		prc.xehRoleSave 		= "#prc.cbAdminEntryPoint#.roles.save";
		prc.xehRolePermissions 	= "#prc.cbAdminEntryPoint#.roles.permissions";
		prc.xehExport 			= "#prc.cbAdminEntryPoint#.roles.export";
		prc.xehExportAll 		= "#prc.cbAdminEntryPoint#.roles.exportAll";
		prc.xehImportAll		= "#prc.cbAdminEntryPoint#.roles.importAll";

		// Get all roles
		prc.roles = roleService.list(sortOrder="role",asQuery=false);
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
		// populate and get
		var oRole 		= populateModel( roleService.get( id= rc.roleID ) );
		var vResults 	= validateModel( oRole );

		// Validation Results
		if( !vResults.hasErrors() ){
			// announce event
			announceInterception( "cbadmin_preRoleSave", { role=oRole, roleID=rc.roleID } );
			// save role
			roleService.save( oRole );
			// announce event
			announceInterception( "cbadmin_postRoleSave", { role=oRole } );
			// messagebox
			cbMessagebox.setMessage( "info", "Role saved!" );

		} else {
			// messagebox
			cbMessagebox.warning( messageArray=vResults.getAllErrors() );
		}
		// relocate
		relocate( prc.xehroles );
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
		announceInterception( "cbadmin_preRoleRemove",{roleID=rc.roleID} );
		// Get requested role and remove permissions
		var oRole = roleService.get( id=rc.roleID ).clearPermissions();
		// finally delete
		roleService.delete( oRole );
		// announce event
		announceInterception( "cbadmin_postRoleRemove",{roleID=rc.roleID} );
		// Message
		cbMessagebox.setMessage( "info","Role Removed!" );
		// relocate
		relocate( prc.xehroles );
	}

	/**
	 * View role permissions
	 *
	 * @event
	 * @rc
	 * @prc
	 *
	 * @return HTML
	 */
	function permissions( event, rc, prc ){
		// exit Handlers
		prc.xehPermissionRemove = "#prc.cbAdminEntryPoint#.roles.removePermission";
		prc.xehPermissionSave 	= "#prc.cbAdminEntryPoint#.roles.savePermission";
		prc.xehRolePermissions 	= "#prc.cbAdminEntryPoint#.roles.permissions";
		// Get all permissions
		prc.permissions = permissionService.list(sortOrder="permission",asQuery=false);
		// Get role
		prc.role = roleService.get( rc.roleID );
		// view
		event.setView(view="roles/permissions",layout="ajax" );
	}

	/**
	 * Save permission to a role and gracefully end.
	 *
	 * @event
	 * @rc
	 * @prc
	 *
	 * @return json
	 */
	function savePermission( event, rc, prc ){
		var oRole 		= roleService.get( rc.roleID );
		var oPermission = permissionService.get( rc.permissionID );

		// Assign it only if it does not exist already
		if( !oRole.hasPermission( oPermission ) ){
			oRole.addPermission( oPermission );
			roleService.save( oRole );
		}

		// Saved
		event.renderData(data="true",type="json" );
	}

	/**
	 * remove permission to a role and gracefully end.
	 *
	 * @event
	 * @rc
	 * @prc
	 *
	 * @return json
	 */
	function removePermission( event, rc, prc ){

		var oRole 		= roleService.get( rc.roleID );
		var oPermission = permissionService.get( rc.permissionID );

		// Remove it
		oRole.removePermission( oPermission );
		roleService.save( oRole );

		// Saved
		event.renderData(data="true",type="json" );
	}

	/**
	 * Export a role
	 *
	 * @event
	 * @rc
	 * @prc
	 */
	function export( event, rc, prc ){
		event.paramValue( "format", "json" );
		// get role
		prc.role  = roleService.get( event.getValue( "roleID",0) );

		// relocate if not existent
		if( !prc.role.isLoaded() ){
			cbMessagebox.warn( "roleID sent is not valid" );
			relocate( "#prc.cbAdminEntryPoint#.roles" );
		}
		//writeDump( prc.role.getMemento() );abort;
		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "#prc.role.getRole()#." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=prc.role.getMemento(), type=rc.format, xmlRootName="role" )
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#" );
				break;
			}
			default:{
				event.renderData(data="Invalid export type: #rc.format#" );
			}
		}
	}

	/**
	 * Export all roles
	 *
	 * @event
	 * @rc
	 * @prc
	 */
	function exportAll( event, rc, prc ){
		event.paramValue( "format", "json" );
		// get all prepared content objects
		var data  = roleService.getAllForExport();

		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "Roles." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=data, type=rc.format, xmlRootName="roles" )
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#" );
				break;
			}
			default:{
				event.renderData(data="Invalid export type: #rc.format#" );
			}
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
		try{
			if( len( rc.importFile ) and fileExists( rc.importFile ) ){
				var importLog = roleService.importFromFile( importFile=rc.importFile, override=rc.overrideContent );
				cbMessagebox.info( "Roles imported sucessfully!" );
				flash.put( "importLog", importLog );
			} else {
				cbMessagebox.error( "The import file is invalid: #encodeForHTML( rc.importFile )# cannot continue with import" );
			}
		}
		catch(any e){
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			cbMessagebox.error( errorMessage );
		}
		relocate( prc.xehRoles );
	}

}
