/**
* Tools for ContentBox.
*/
component extends="baseHandler"{
	
	// DI
	property name="roleService" inject="id:roleService@cb";
	
	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab control
		prc.tabTools = true;
	}
	
	// importer
	function importer(event,rc,prc){
		// Exit Handler
		rc.xehImport 	= "#prc.cbAdminEntryPoint#.tools.doImport";
		// tab
		prc.tabTools_import = true; 
		prc.roles = roleService.list(sortOrder="role");
		// view
		event.setView("tools/importer");
	}
	
	// do import
	function doImport(event,rc,prc){
		event.paramValue("dsn","");
		event.paramValue("dsnUsername","");
		event.paramValue("dsnPassword","");
		event.paramValue("defaultPassword","");
		event.paramValue("tableprefix","");
		event.paramValue("roleID","");
		
		// validate
		if( !len(rc.dsn) or !len(rc.defaultPassword) ){
			getPlugin("MessageBox").warn("Please fill out all required fields.");
			setNextEvent(prc.xehToolsImport);
		}
		
		try{
			// get importer
			var importer = getModel("#rc.importer#Importer@cb");
			importer.execute(argumentCollection=rc);
			getPlugin("MessageBox").info("Content imported successfully! Please check out your ContentBox now!");
		}
		catch(any e){
			getPlugin("MessageBox").error("Error importing from datasource: #e.message# #e.detail#");
		}
		
		setNextEvent(prc.xehToolsImport);
	}
	
	
	
}
