/**
* Manage layouts
*/
component extends="baseHandler"{

	// Dependencies
	property name="layoutService"	inject="id:layoutService@bb";
	
	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab control
		prc.tabSite = true;
	}
	
	// index
	function index(event,rc,prc){
		// exit Handlers
		rc.xehLayoutRemove 	= "#prc.bbAdminEntryPoint#.layouts.remove";
		rc.xehLayoutUpload  = "#prc.bbAdminEntryPoint#.layouts.upload";
		rc.xehFlushRegistry = "#prc.bbAdminEntryPoint#.layouts.rebuildRegistry";
		rc.xehActivate		= "#prc.bbAdminEntryPoint#.layouts.activate";
		rc.xehPreview		= "#prc.bbEntryPoint#.__preview";
		
		// Get all layouts
		rc.layouts = layoutService.getLayouts();
		rc.layoutsPath = layoutService.getLayoutsPath();
		
		// ForgeBox Entry URL
		rc.forgeBoxEntryURL = getModuleSettings("blogbox-admin").settings.forgeBoxEntryURL;
		
		// Tab
		prc.tabSite_layouts = true;
		// view
		event.setView("layouts/index");
	}
	
	// activate layout
	function activate(event,rc,prc){
		layoutService.activateLayout( rc.layoutName );
		getPlugin("MessageBox").info("#rc.layoutName# Activated!");
		setNextEvent(prc.xehLayouts);
	}
	
	// rebuild registry
	function rebuildRegistry(event,rc,prc){
		layoutService.buildLayoutRegistry();
		getPlugin("MessageBox").info("Layouts re-scanned and registered!");
		setNextEvent(prc.xehLayouts);
	}
	
	//Remove
	function remove(event,rc,prc){
		if( layoutService.removeLayout( rc.layoutName ) ){
			getPlugin("MessageBox").info("Layout Removed Forever!");
		}
		else{
			getPlugin("MessageBox").error("Error removing layout, please check your logs for more information!");
		}
		setNextEvent(prc.xehLayouts);
	}

	//upload
	function upload(event,rc,prc){
		var fp = event.getTrimValue("fileLayout","");
		
		// Verify
		if( len( fp ) eq 0){
			getPlugin("MessageBox").setMessage(type="warning", message="Please choose a file to upload");
		}
		else{
			// Upload File
			try{
				var results = layoutService.uploadLayout("fileLayout");
				
				if( !results.error ){
					// Good
					getPlugin("MessageBox").setMessage(type="info", message="Layout Installed Successfully");
				}
				else{
					// Bad
					getPlugin("MessageBox").error(results.messages);
				}
			}
			catch(Any e){
				getPlugin("MessageBox").error("Error uploading file: #e.detail# #e.message#");
			}
		}
		
		setNextEvent(prc.xehLayouts);		
	}
}
