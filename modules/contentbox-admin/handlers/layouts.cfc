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
		prc.xehLayouts 			= "#prc.cbAdminEntryPoint#.layouts.index";
		prc.xehLayoutRemove 	= "#prc.cbAdminEntryPoint#.layouts.remove";
		prc.xehLayoutUpload  	= "#prc.cbAdminEntryPoint#.layouts.upload";
		prc.xehFlushRegistry 	= "#prc.cbAdminEntryPoint#.layouts.rebuildRegistry";
		prc.xehActivate			= "#prc.cbAdminEntryPoint#.layouts.activate";
		prc.xehPreview			= "#prc.cbEntryPoint#.__preview";
		prc.xehForgeBox			= "#prc.cbAdminEntryPoint#.forgebox.index";
		prc.xehSaveSettings 	= "#prc.cbAdminEntryPoint#.layouts.saveSettings";

		// Rescan if newly installed layout?
		if( event.getValue( "rescan", false ) ){
			layoutService.buildLayoutRegistry();
		}

		// Get all layouts
		prc.layouts 		= layoutService.getLayouts();
		prc.layoutsPath 	= layoutService.getLayoutsPath();
		prc.activeLayout 	= layoutService.getActiveLayout();
		prc.layoutService	= layoutService;

		// ForgeBox Entry URL
		prc.forgeBoxEntryURL = getModuleSettings( "contentbox-admin" ).settings.forgeBoxEntryURL;
		// ForgeBox Stuff
		prc.forgeBoxSlug 		= "contentbox-layouts";
		prc.forgeBoxInstallDir 	= URLEncodedFormat( layoutService.getLayoutsPath() );
		prc.forgeboxReturnURL 	= URLEncodedFormat( event.buildLink(linkto=prc.xehLayouts, querystring="rescan=true##manage") );

		// Tab
		prc.tabLookAndFeel_layouts = true;
		// view
		event.setView("layouts/index");
	}
	
	// save Settings
	function saveSettings(event,rc,prc){
		var vResults = validateModel( target=rc, constraints=layoutService.getSettingsConstraints( rc.layoutname ) );
		// Validate results
		if( vResults.hasErrors() ){
			getPlugin("MessageBox").error(messageArray=vResults.getAllErrors());
			return index(argumentCollection=arguments);
		}
		
		// Results validated, save settings
		layoutService.saveLayoutSettings( name=rc.layoutName, settings=rc );
		getPlugin("MessageBox").info(message="Layout settings saved!");
		// Relocate
		setNextEvent(event=prc.xehLayouts);
	}

	// activate layout
	function activate(event,rc,prc){
		// Activate the layout
		layoutService.activateLayout( rc.layoutName );
		// clear caches
		contentService.clearAllCaches();
		// messages
		getPlugin("MessageBox").info("#rc.layoutName# Activated!");
		// Relocate
		setNextEvent(prc.xehLayouts);
	}

	// rebuild registry
	function rebuildRegistry(event,rc,prc){
		layoutService.buildLayoutRegistry();
		getPlugin("MessageBox").info("Layouts re-scanned and registered!");
		setNextEvent(event=prc.xehLayouts, queryString="##manage");
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
