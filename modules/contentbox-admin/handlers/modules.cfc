/**
* Manage modules
*/
component extends="baseHandler"{

	// Dependencies
	property name="moduleService"	inject="id:moduleService@cb";
	property name="cb" 				inject="cbHelper@cb";

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab control
		prc.tabModules = true;
	}

	// Build Module Links
	function buildModuleLink(event,rc,prc){
		return cb.buildModuleLink(module=event.getValue("module",""),
								  linkTo=event.getValue("moduleEvent",""),
								  queryString=event.getValue("moduleQS",""));
	}

	// proxy a call to a module, all module calls are supposed to return content
	function execute(){
		event.paramValue("moduleEntryPoint","");
		event.paramValue("moduleHandler","");
		event.paramValue("moduleAction","index");

		// get module by moduleEntryPoint
		var module = moduleService.findWhere({entryPoint=rc.moduleEntryPoint});
		if( isNull( module ) ){
			getPlugin("MessageBox").warn("No modules where found with the following entryPoint: #rc.moduleEntryPoint#. Please make sure your module has an entry point.");
			setNextEvent(prc.xehModules);
		}
		if( !module.isLoaded() ){
			getPlugin("MessageBox").warn("The requested module: #rc.moduleEntryPoint# is not valid!");
			setNextEvent(prc.xehModules);
		}
		if( !module.getIsActive() ){
			getPlugin("MessageBox").warn("The requested module: #rc.moduleEntryPoint# is not active!");
			setNextEvent(prc.xehModules);
		}
		if( !len(rc.moduleHandler) ){
			getPlugin("MessageBox").warn("The requested module: #rc.moduleEntryPoint# is valid but the incoming module handler is empty!");
			setNextEvent(prc.xehModules);
		}

		// store incoming module event so modules can use it
		prc.contentbox_moduleEvent = rc.moduleHandler & "." & rc.moduleAction;
		// execute module event
		var results = runEvent(event="#module.getname()#:#prc.contentbox_moduleEvent#");
		// return results if returned
		if( !isNull( results ) ){ return results; }
		// stash the module view, so it renders in the admin layout
		prc.viewModule = module.getName();
		// else normal ColdBox Rendering
		return controller.getPlugin("Renderer").renderLayout();
	}

	// index
	function index(event,rc,prc){
		// exit Handlers
		prc.xehModuleRemove	= "#prc.cbAdminEntryPoint#.modules.remove";
		prc.xehModuleUpload = "#prc.cbAdminEntryPoint#.modules.upload";
		prc.xehModuleReset  = "#prc.cbAdminEntryPoint#.modules.reset";
		prc.xehModuleRescan = "#prc.cbAdminEntryPoint#.modules.rescan";
		prc.xehModuleActivate = "#prc.cbAdminEntryPoint#.modules.activate";
		prc.xehmoduleDeactivate = "#prc.cbAdminEntryPoint#.modules.deactivate";
		prc.xehForgeBox		= "#prc.cbAdminEntryPoint#.forgebox.index";

		//tab
		prc.tabModules_manage = true;

		// Get all modules
		var modules = moduleService.findModules();
		prc.modules = modules.modules;
		prc.modulesCount = modules.count;

		// ForgeBox Entry URL
		prc.forgeBoxEntryURL = getModuleSettings("contentbox-admin").settings.forgeBoxEntryURL;
		// ForgeBox Stuff
		prc.forgeBoxSlug = "contentbox-modules";
		prc.forgeBoxInstallDir = URLEncodedFormat( moduleService.getModulesPath() );
		prc.forgeboxReturnURL = URLEncodedFormat( event.buildLink(prc.xehModules) );

		// view
		event.setView("modules/index");
	}

	//activate
	function activate(event,rc,prc){
		moduleService.activateModule( rc.moduleName );
		getPlugin("MessageBox").info("Modules Activated, woohoo!");
		setNextEvent(prc.xehModules);
	}

	//deactivate
	function deactivate(event,rc,prc){
		moduleService.deactivateModule( rc.moduleName );
		getPlugin("MessageBox").info("Modules Deactivated!");
		setNextEvent(prc.xehModules);
	}

	//reset
	function reset(event,rc,prc){
		moduleService.resetModules();
		getPlugin("MessageBox").info("Modules Reset!");
		setNextEvent(prc.xehModules);
	}

	//rescan
	function rescan(event,rc,prc){
		moduleService.startup();
		getPlugin("MessageBox").info("Modules Rescaned and Revamped!");
		setNextEvent(prc.xehModules);
	}

	//Remove
	function remove(event,rc,prc){
		moduleService.deleteModule( rc.moduleName );
		getPlugin("MessageBox").info("Module Removed Forever!");
		setNextEvent(prc.xehModules);
	}

	//upload
	function upload(event,rc,prc){
		var fp = event.getTrimValue("fileModule","");

		// Verify
		if( len( fp ) eq 0){
			getPlugin("MessageBox").setMessage(type="warning", message="Please choose a file to upload");
		}
		else{
			// Upload File
			try{
				var results = moduleService.uploadModule("fileModule");
				if( results.error ){
					flash.put("forgeboxInstallLog", results.logInfo );
					getPlugin("MessageBox").error("Error installing module, please check out the log information.");
				}
				else{
					getPlugin("MessageBox").info("Module Installed Successfully in your 'modules' folder.");
					flash.put("forgeboxInstallLog", "Please verify if the module was
					registered successfully by looking below in your modules listing.  Some modules need some manual installations so please verify the file structure in your
					media manager modules library.  If the module does not appear below, then it was not a valid module installation and some manual work is needed.");
				}
			}
			catch(Any e){
				getPlugin("MessageBox").error("Error Installing Module: #e.detail# #e.message#");
			}
		}

		setNextEvent(prc.xehModules);
	}
}
