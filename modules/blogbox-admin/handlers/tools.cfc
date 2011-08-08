/**
* Tools for BlogBox.
*/
component extends="baseHandler"{

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
		rc.xehImport 	= "#prc.bbEntryPoint#.tools.doImport";
		// tab
		prc.tabTools_import = true; 
		// view
		event.setView("tools/importer");
	}
	
	// do import
	function doImport(event,rc,prc){
		event.paramValue("dsn","");
		event.paramValue("dsnUsername","");
		event.paramValue("dsnPassword","");
		event.paramValue("defaultPassword","");
		
		// validate
		if( !len(rc.dsn) or !len(rc.defaultPassword) ){
			getPlugin("MessageBox").warn("Please fill out all required fields.");
			setNextEvent(rc.xehToolsImport);
		}
		
		try{
			// get importer
			var importer = getModel("#rc.importer#Importer@bb");
			importer.execute(dsn=rc.dsn,dsnUsername=rc.dsnUsername,dsnPassword=rc.dsnPassword,defaultPassword=rc.defaultPassword);
			getPlugin("MessageBox").info("Blog imported successfully! Please check out your blog now!");
		}
		catch(any e){
			getPlugin("MessageBox").error("Error importing from datasource: #e.message# #e.detail#");
		}
		setNextEvent(rc.xehToolsImport);
	}
	
	
	
}
