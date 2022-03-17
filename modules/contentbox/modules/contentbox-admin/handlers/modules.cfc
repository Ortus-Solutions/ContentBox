/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage modules
 */
component extends="baseHandler" {

	// Dependencies
	property name="moduleService" inject="moduleService@contentbox";
	property name="routingService" inject="coldbox:routingService";

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
			module      = event.getValue( "module", "" ),
			linkTo      = event.getValue( "moduleEvent", "" ),
			queryString = event.getValue( "moduleQS", "" )
		);
	}

	/**
	 * proxy a call to a module, all module calls are supposed to return content
	 * This is used to proxy /cbadmin/{module} type of calls
	 */
	function execute( event, rc, prc ){
		event
			.paramValue( "moduleEntryPoint", "" )
			.paramValue( "moduleHandler", "" )
			.paramValue( "moduleAction", "index" );

		// Clean incoming routed URL from base proxy: cbadmin/module
		var routedURL    = event.getCurrentRoutedURL().replacenocase( "cbadmin/module", "" );
		// Discover it's route
		var routeResults = routingService.findRoute( routedURL, event );

		// Check if route is discovered, basically if we get handler => contentbox-ui:page then it was not found
		if ( routeResults.route.handler == "contentbox-ui:page" ) {
			variables.cbMessagebox.warn( "No module where found with the incoming route: #encodeForHTML( routedURL )#" );
			return relocate( prc.xehModules );
		}

		// Process the route, this discovers the route
		prc.contentbox_moduleEvent = routingService.processRoute( routeResults, event, rc, prc );

		// Default module actions
		if ( isSimpleValue( routeResults.route.action ) and !routeResults.route.action.len() ) {
			prc.contentbox_moduleEvent &= ".index";
		}

		// execute module event
		var results = runEvent( event = prc.contentbox_moduleEvent );

		// return results if returned
		if ( !isNull( results ) ) {
			return results;
		}

		// stash the module view, so it renders in the admin layout if not set already
		if ( !structKeyExists( prc, "viewModule" ) or !len( prc.viewModule ) ) {
			prc.viewModule = routeResults.route.module;
		}

		// Check for renderData
		if ( structIsEmpty( event.getRenderData() ) ) {
			// else normal ColdBox Rendering
			return controller.getRenderer().renderLayout();
		}
	}

	/**
	 * Module Manager
	 */
	function index( event, rc, prc ){
		// exit Handlers
		prc.xehModuleRemove     = "#prc.cbAdminEntryPoint#.modules.remove";
		prc.xehModuleUpload     = "#prc.cbAdminEntryPoint#.modules.upload";
		prc.xehModuleReset      = "#prc.cbAdminEntryPoint#.modules.reset";
		prc.xehModuleRescan     = "#prc.cbAdminEntryPoint#.modules.rescan";
		prc.xehModuleActivate   = "#prc.cbAdminEntryPoint#.modules.activate";
		prc.xehmoduleDeactivate = "#prc.cbAdminEntryPoint#.modules.deactivate";

		// tab
		prc.tabModules_manage = true;

		// Rescan modules
		if ( event.valueExists( "rescan" ) ) {
			variables.moduleService.startup();
		}

		// Get all modules
		var modules      = variables.moduleService.findModules();
		prc.modules      = modules.modules;
		prc.modulesCount = modules.count;

		// view
		event.setView( "modules/index" );
	}

	/**
	 * Activate a module
	 */
	function activate( event, rc, prc ){
		variables.moduleService.activateModule( rc.moduleName );
		variables.cbMessagebox.info( "Modules Activated, woohoo!" );
		relocate( prc.xehModules );
	}

	/**
	 * Deactivate a module
	 */
	function deactivate( event, rc, prc ){
		variables.moduleService.deactivateModule( rc.moduleName );
		variables.cbMessagebox.info( "Modules Deactivated!" );
		relocate( prc.xehModules );
	}

	/**
	 * Reset all modules
	 */
	function reset( event, rc, prc ){
		variables.moduleService.resetModules();
		variables.cbMessagebox.info( "Modules Reset!" );
		relocate( prc.xehModules );
	}

	/**
	 * Rescan all modules
	 */
	function rescan( event, rc, prc ){
		variables.moduleService.startup();
		variables.cbMessagebox.info( "Modules Rescaned and Revamped!" );
		relocate( prc.xehModules );
	}

	/**
	 * Remove a module
	 */
	function remove( event, rc, prc ){
		variables.moduleService.deleteModule( rc.moduleName );
		variables.cbMessagebox.info( "Module Removed Forever!" );
		relocate( prc.xehModules );
	}

}
