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
	property name="routingService"	inject="coldbox:interceptor:ses";

	// PrePost Actions
	this.prehandler_except = "execute";

	// pre handler
	function preHandler( event, action, eventArguments, rc, prc ){
		// Tab control
		prc.tabModules = true;
	}

	/**
	 * Build Module Links
	 */
	function buildModuleLink( event, rc, prc ){
		return cb.buildModuleLink(
			module		= event.getValue( "module","" ),
			linkTo		= event.getValue( "moduleEvent","" ),
			queryString	= event.getValue( "moduleQS","" ));
	}

	/**
	 * proxy a call to a module, all module calls are supposed to return content
	 * This is used to proxy /cbadmin/{module} type of calls
	 */
	function execute( event, rc, prc ){
		event.paramValue( "moduleEntryPoint", "" )
			.paramValue( "moduleHandler", "" )
			.paramValue( "moduleAction", "index" );

		// Clean incoming routed URL from base proxy: cbadmin/module
		var routedURL = event.getCurrentRoutedURL().replacenocase( "cbadmin/module", "" );
		// Discover it's route
		var route = routingService.findRoute( routedURL, event );

		// Check if route is discovered, basically if we get handler => contentbox-ui:page then it was not found
		if( route.handler == "contentbox-ui:page" ){
			cbMessagebox.warn( "No module where found with the incoming route: #encodeForHTML( routedURL )#" );
			return setNextEvent( prc.xehModules );
		}

		// Setup discovered data
		var thisModule 	= route.module;
		var thisHandler = route.handler ?: "";
		var thisAction 	= route.action ?: "index";

		// store incoming module event so modules can use it
		prc.contentbox_moduleEvent = "#thisModule#:#thisHandler#.#thisAction#";

		// execute module event
		var results = runEvent( event=prc.contentbox_moduleEvent );

		// return results if returned
		if( !isNull( results ) ){
			return results;
		}

		// stash the module view, so it renders in the admin layout if not set already
		if( !structKeyExists( prc, "viewModule" ) or !len( prc.viewModule )) {
			prc.viewModule = thisModule;
		}

		// Check for renderData
		if( structIsEmpty( event.getRenderData() ) ){
			// else normal ColdBox Rendering
			return controller.getRenderer().renderLayout();
		}

	}

	/**
	 * Module Manager
	 */
	function index( event, rc, prc ){
		// exit Handlers
		prc.xehModuleRemove	    = "#prc.cbAdminEntryPoint#.modules.remove";
		prc.xehModuleUpload     = "#prc.cbAdminEntryPoint#.modules.upload";
		prc.xehModuleReset      = "#prc.cbAdminEntryPoint#.modules.reset";
		prc.xehModuleRescan     = "#prc.cbAdminEntryPoint#.modules.rescan";
		prc.xehModuleActivate   = "#prc.cbAdminEntryPoint#.modules.activate";
		prc.xehmoduleDeactivate = "#prc.cbAdminEntryPoint#.modules.deactivate";
		prc.xehForgeBox		    = "#prc.cbAdminEntryPoint#.forgebox.index";

		// tab
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
		prc.forgeBoxInstallDir = "modules";
		prc.forgeboxReturnURL = URLEncodedFormat( event.buildLink( linkto=prc.xehModules, querystring="rescan=true" ) );

		// view
		event.setView( "modules/index" );
	}

	/**
	 * Activate a module
	 */
	function activate( event, rc, prc ){
		moduleService.activateModule( rc.moduleName );
		cbMessagebox.info( "Modules Activated, woohoo!" );
		setNextEvent(prc.xehModules);
	}

	/**
	 * Deactivate a module
	 */
	function deactivate( event, rc, prc ){
		moduleService.deactivateModule( rc.moduleName );
		cbMessagebox.info( "Modules Deactivated!" );
		setNextEvent(prc.xehModules);
	}

	/**
	 * Reset all modules
	 */
	function reset( event, rc, prc ){
		moduleService.resetModules();
		cbMessagebox.info( "Modules Reset!" );
		setNextEvent(prc.xehModules);
	}

	/**
	 * Rescan all modules
	 */
	function rescan( event, rc, prc ){
		moduleService.startup();
		cbMessagebox.info( "Modules Rescaned and Revamped!" );
		setNextEvent(prc.xehModules);
	}

	/**
	 * Remove a module
	 */
	function remove( event, rc, prc ){
		moduleService.deleteModule( rc.moduleName );
		cbMessagebox.info( "Module Removed Forever!" );
		setNextEvent(prc.xehModules);
	}

	/**
	 * Upload a new module
	 */
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