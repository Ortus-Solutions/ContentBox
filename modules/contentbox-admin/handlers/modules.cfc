/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manage modules
*/
component extends="baseHandler"{

	// Dependencies
	property name="moduleService"	inject="id:moduleService@cb";
	property name="cb" 				inject="cbHelper@cb";

	// PrePost Actions
	this.prehandler_except = "execute";

	// pre handler
	function preHandler( event, action, eventArguments, rc, prc ){
		// Tab control
		prc.tabModules = true;
	}

	// Build Module Links
	function buildModuleLink( event, rc, prc ){
		return cb.buildModuleLink(
			module		= event.getValue( "module","" ),
			linkTo		= event.getValue( "moduleEvent","" ),
			queryString	= event.getValue( "moduleQS","" ));
	}

	// proxy a call to a module, all module calls are supposed to return content
	function execute( event, rc, prc ){
		event.paramValue( "moduleEntryPoint", "" )
			.paramValue( "moduleHandler", "" )
			.paramValue( "moduleAction", "index" );

		// get module by moduleEntryPoint
		var module = moduleService.findWhere( {entryPoint = rc.moduleEntryPoint} );
		if( isNull( module ) ){
			cbMessagebox.warn( "No modules where found with the following entryPoint: #rc.moduleEntryPoint#. Please make sure your module has an entry point." );
			return setNextEvent( prc.xehModules );
		}
		if( !module.isLoaded() ){
			cbMessagebox.warn( "The requested module: #rc.moduleEntryPoint# is not valid!" );
			return setNextEvent( prc.xehModules );
		}
		if( !module.getIsActive() ){
			cbMessagebox.warn( "The requested module: #rc.moduleEntryPoint# is not active!" );
			return setNextEvent( prc.xehModules );
		}
		if( !len(rc.moduleHandler) ){
			cbMessagebox.warn( "The requested module: #rc.moduleEntryPoint# is valid but the incoming module handler is empty!" );
			return setNextEvent( prc.xehModules );
		}

		// store incoming module event so modules can use it
		prc.contentbox_moduleEvent = rc.moduleHandler & "." & rc.moduleAction;
		// execute module event
		var results = runEvent( event="#module.getname()#:#prc.contentbox_moduleEvent#" );
		// return results if returned
		if( !isNull( results ) ){ return results; }

		// stash the module view, so it renders in the admin layout if not set already
		if( !structKeyExists( prc, "viewModule" ) or !len( prc.viewModule )) {
			prc.viewModule = module.getName();
		}
		// Check for renderData
		if( structIsEmpty( event.getRenderData() ) ){
			// else normal ColdBox Rendering
			return controller.getRenderer().renderLayout();
		}

	}

	// index
	function index( event, rc, prc ){
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

		// Rescan modules
		if( event.valueExists( "rescan" ) ){ moduleService.startup(); }

		// Get all modules
		var modules = moduleService.findModules();
		prc.modules = modules.modules;
		prc.modulesCount = modules.count;

		// ForgeBox Entry URL
		prc.forgeBoxEntryURL = getModuleSettings( "contentbox-admin" ).forgeBoxEntryURL;
		// ForgeBox Stuff
		prc.forgeBoxSlug = "contentbox-modules";
		prc.forgeBoxInstallDir = URLEncodedFormat( moduleService.getModulesPath() );
		prc.forgeboxReturnURL = URLEncodedFormat( event.buildLink( linkto=prc.xehModules, querystring="rescan=true" ) );

		// view
		event.setView( "modules/index" );
	}

	//activate
	function activate( event, rc, prc ){
		moduleService.activateModule( rc.moduleName );
		cbMessagebox.info( "Modules Activated, woohoo!" );
		setNextEvent(prc.xehModules);
	}

	//deactivate
	function deactivate( event, rc, prc ){
		moduleService.deactivateModule( rc.moduleName );
		cbMessagebox.info( "Modules Deactivated!" );
		setNextEvent(prc.xehModules);
	}

	//reset
	function reset( event, rc, prc ){
		moduleService.resetModules();
		cbMessagebox.info( "Modules Reset!" );
		setNextEvent(prc.xehModules);
	}

	//rescan
	function rescan( event, rc, prc ){
		moduleService.startup();
		cbMessagebox.info( "Modules Rescaned and Revamped!" );
		setNextEvent(prc.xehModules);
	}

	//Remove
	function remove( event, rc, prc ){
		moduleService.deleteModule( rc.moduleName );
		cbMessagebox.info( "Module Removed Forever!" );
		setNextEvent(prc.xehModules);
	}

	//upload
	function upload( event, rc, prc ){
		var fp = event.getTrimValue( "fileModule","" );

		// Verify
		if( len( fp ) eq 0){
			cbMessagebox.warn( "Please choose a file to upload" );
		}
		else{
			// Upload File
			try{
				var results = moduleService.uploadModule( "fileModule" );
				if( results.error ){
					flash.put( "forgeboxInstallLog", results.logInfo );
					cbMessagebox.error( "Error installing module, please check out the log information." );
				}
				else{
					// Messagebox
					cbMessagebox.info( "Module Installed Successfully in your 'modules' folder." );
					flash.put( "forgeboxInstallLog", "Please verify if the module was
					registered successfully by looking below in your modules listing.  Some modules need some manual installations so please verify the file structure in your
					media manager modules library.  If the module does not appear below, then it was not a valid module installation and some manual work is needed." );
				}
			} catch( Any e ){
				cbMessagebox.error( "Error Installing Module: #e.detail# #e.message#" );
			}
		}

		setNextEvent( prc.xehModules );
	}
}