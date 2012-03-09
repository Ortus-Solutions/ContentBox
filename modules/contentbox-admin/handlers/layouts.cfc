/**
* Manage layouts
*/
component extends="baseHandler"{

	// Dependencies
	property name="layoutService"	inject="id:layoutService@cb";
	property name="contentService"	inject="id:contentService@cb";

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab control
		prc.tabLookAndFeel = true;
	}

	// index
	function index(event,rc,prc){
		// exit Handlers
		prc.xehLayoutRemove 	= "#prc.cbAdminEntryPoint#.layouts.remove";
		prc.xehLayoutUpload  = "#prc.cbAdminEntryPoint#.layouts.upload";
		prc.xehFlushRegistry = "#prc.cbAdminEntryPoint#.layouts.rebuildRegistry";
		prc.xehActivate		= "#prc.cbAdminEntryPoint#.layouts.activate";
		prc.xehPreview		= "#prc.cbEntryPoint#.__preview";
		prc.xehForgeBox		= "#prc.cbAdminEntryPoint#.forgebox.index";

		// Get all layouts
		prc.layouts = layoutService.getLayouts();
		prc.layoutsPath = layoutService.getLayoutsPath();

		// ForgeBox Entry URL
		prc.forgeBoxEntryURL = getModuleSettings("contentbox-admin").settings.forgeBoxEntryURL;
		// ForgeBox Stuff
		prc.forgeBoxSlug = "contentbox-layouts";
		prc.forgeBoxInstallDir = URLEncodedFormat(layoutService.getLayoutsPath());
		prc.forgeboxReturnURL = URLEncodedFormat( event.buildLink(prc.xehLayouts) );

		// Tab
		prc.tabLookAndFeel_layouts = true;
		// view
		event.setView("layouts/index");
	}

	// activate layout
	function activate(event,rc,prc){
		// Activate the layout
		layoutService.activateLayout( rc.layoutName );
		// clear caches
		contentService.clearAllCaches();
		// messages
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
