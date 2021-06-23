/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * ContentBox Media Manager handler
 */
component extends="baseHandler" {

	/**
	 * Pre handler
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		// widget runnable event
		prc.xehFileBrowser = "contentbox-filebrowser:home.index";
	}

	/**
	 * Display media manager
	 */
	function index( event, rc, prc ){
		// get settings according to contentbox
		prc.cbFileBrowserSettings       = variables.settingService.buildFileBrowserSettings();
		// this is the default, so ignore
		prc.cbFileBrowserSettings.title = "Content Library";

		// build argument list for widget
		prc.fbArgs = { widget : true, settings : prc.cbFileBrowserSettings };

		// Light up
		prc.tabContent_mediaManager = true;

		// view
		event.setView( "mediamanager/index" );
	}

}
