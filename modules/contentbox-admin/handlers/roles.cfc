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
		// Get all roles
		prc.roles = roleService.list(sortOrder="role",asQuery=false);
		// Tab
		prc.tabUsers_roles = true;
		// view
		event.setView("roles/index");
	}
	
	// save
	function save(event,rc,prc){
		// populate and get
		var orole = populateModel( roleService.get(id=rc.roleID) );
    	// announce event
		announceInterception("cbadmin_preRoleSave",{role=orole,roleID=rc.roleID});
		// save role
		roleService.save( orole );
		// announce event
		announceInterception("cbadmin_postRoleSave",{role=orole});
		// messagebox
		getPlugin("MessageBox").setMessage("info","Role saved!");
		// relocate
		setNextEvent( prc.xehroles );
	}
	
	// remove
	function remove(event,rc,prc){
		// announce event
		announceInterception("cbadmin_preRoleRemove",{roleID=rc.roleID});
		// delete by id
		if( !roleService.deleteByID( rc.roleID ) ){
			getPlugin("MessageBox").setMessage("warning","Invalid role detected!");
		}
		else{
			// announce event
			announceInterception("cbadmin_postRoleRemove",{roleID=rc.roleID});
			// Message
			getPlugin("MessageBox").setMessage("info","Role Removed!");
		}
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
		event.setView(view="roles/permissions",layout="ajax");
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
		event.renderData(data="true",type="json");
	}
	
	// remove permission to a role and gracefully end.
	function removePermission(event,rc,prc){
		
		var oRole 		= roleService.get( rc.roleID );
		var oPermission = permissionService.get( rc.permissionID );
		
		// Remove it
		oRole.removePermission( oPermission );
		roleService.save( oRole );
		
		// Saved
		event.renderData(data="true",type="json");
	}

}
