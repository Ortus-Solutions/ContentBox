/**
* Manage roles
*/
component extends="baseHandler"{

	// Dependencies
	property name="roleService"			inject="id:roleService@cb";
	property name="permissionService"	inject="id:permissionService@cb";
	
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
	
	// save
	function save(event,rc,prc){
		// populate and get
		var orole = populateModel( roleService.get(id=rc.roleID) );
    	// announce event
		announceInterception( "cbadmin_preRoleSave",{role=orole,roleID=rc.roleID} );
		// save role
		roleService.save( orole );
		// announce event
		announceInterception( "cbadmin_postRoleSave",{role=orole} );
		// messagebox
		cbMessagebox.setMessage( "info","Role saved!" );
		// relocate
		setNextEvent( prc.xehroles );
	}
	
	// remove
	function remove(event,rc,prc){
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
		setNextEvent( prc.xehroles );
	}
	
	// permissions
	function permissions(event,rc,prc){
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
	
	// Save permission to a role and gracefully end.
	function savePermission(event,rc,prc){
		
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
	
	// remove permission to a role and gracefully end.
	function removePermission(event,rc,prc){
		
		var oRole 		= roleService.get( rc.roleID );
		var oPermission = permissionService.get( rc.permissionID );
		
		// Remove it
		oRole.removePermission( oPermission );
		roleService.save( oRole );
		
		// Saved
		event.renderData(data="true",type="json" );
	}
	
	// Export Entry
	function export(event,rc,prc){
		event.paramValue( "format", "json" );
		// get role
		prc.role  = roleService.get( event.getValue( "roleID",0) );
		
		// relocate if not existent
		if( !prc.role.isLoaded() ){
			cbMessagebox.warn( "roleID sent is not valid" );
			setNextEvent( "#prc.cbAdminEntryPoint#.roles" );
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
	
	// Export All Entries
	function exportAll(event,rc,prc){
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
	
	// import entries
	function importAll(event,rc,prc){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try{
			if( len( rc.importFile ) and fileExists( rc.importFile ) ){
				var importLog = roleService.importFromFile( importFile=rc.importFile, override=rc.overrideContent );
				cbMessagebox.info( "Roles imported sucessfully!" );
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
		setNextEvent( prc.xehRoles );
	}

}
