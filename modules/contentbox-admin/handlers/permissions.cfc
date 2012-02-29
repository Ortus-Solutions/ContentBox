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
		// Get all permissions
		prc.permissions = permissionService.list(sortOrder="permission",asQuery=false);
		// Tab
		prc.tabUsers_Permissions = true;
		// view
		event.setView("permissions/index");
	}

	// save
	function save(event,rc,prc){
		// UCASE permission
		rc.permission = ucase( rc.permission );
		// populate and get
		var oPermission = populateModel( permissionService.get(id=rc.permissionID) );
    	// announce event
		announceInterception("cbadmin_prePermissionSave",{permission=oPermission,permissionID=rc.permissionID});
		// save permission
		permissionService.save( oPermission );
		// announce event
		announceInterception("cbadmin_postPermissionSave",{permission=oPermission});
		// messagebox
		getPlugin("MessageBox").setMessage("info","Permission saved!");
		// relocate
		setNextEvent( prc.xehPermissions );
	}
	
	// remove
	function remove(event,rc,prc){
		// announce event
		announceInterception("cbadmin_prePermissionRemove",{permissionID=rc.permissionID});
		// delete by id
		if( !permissionService.deletePermission( rc.permissionID ) ){
			getPlugin("MessageBox").setMessage("warning","Invalid Permission detected!");
		}
		else{
			// announce event
			announceInterception("cbadmin_postPermissionRemove",{permissionID=rc.permissionID});
			// Message
			getPlugin("MessageBox").setMessage("info","Permission and all relationships Removed!");
		}
		setNextEvent( prc.xehPermissions );
	}
}
