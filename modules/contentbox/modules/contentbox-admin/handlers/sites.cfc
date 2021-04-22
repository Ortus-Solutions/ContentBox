/**
 * Manage ContentBox Sites
 */
component extends="baseHandler" {

	// Dependencies
	property name="siteService" inject="siteService@cb";
	property name="themeService" inject="themeService@cb";
	property name="pageService" inject="pageService@cb";

	/**
	 * Pre handler
	 *
	 * @event
	 * @action
	 * @eventArguments
	 * @rc
	 * @prc
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		// Tab control
		prc.tabSystem = true;
	}

	/**
	 * Show sites
	 */
	function index( event, rc, prc ){
		// Exit Handler
		prc.xehSiteRemove = "#prc.cbAdminEntryPoint#.sites.remove";
		prc.xehSiteEditor = "#prc.cbAdminEntryPoint#.sites.editor";
		prc.xehExportAll  = "#prc.cbAdminEntryPoint#.sites.exportAll";
		prc.xehExport     = "#prc.cbAdminEntryPoint#.sites.export";
		prc.xehImportAll  = "#prc.cbAdminEntryPoint#.sites.importAll";

		// get content pieces
		prc.sites = variables.siteService.getAll( sortOrder = "name asc" );

		// tab
		prc.tabSystem_sites = true;

		// view
		event.setView( "sites/index" );
	}


	/**
	 * Site Editor
	 */
	function editor( event, rc, prc ){
		// tab
		prc.tabSystem_sites = true;
		// get new or persisted
		if( isNull( prc.site ) ){
			prc.site   = variables.siteService.get( event.getValue( "siteID", 0 ) );
		}
		// Get all registered themes
		prc.themes = variables.themeService.getThemes();
		// pages
		prc.pages  = variables.pageService.search(
			sortOrder   = "slug asc",
			isPublished = true,
			siteID      = prc.site.getsiteID()
		).pages;

		// exit handlers
		prc.xehSiteSave = "#prc.cbAdminEntryPoint#.sites.save";

		// view
		event.setView( "sites/editor" );
	}

	/**
	 * Save a Site
	 */
	function save( event, rc, prc ){
		// populate and get content
		prc.site    = populateModel( variables.siteService.get( rc.siteID ) );
		// validate it
		var vResults = validate( prc.site );
		if ( !vResults.hasErrors() ) {
			// announce event
			announce( "cbadmin_preSiteSave", { site : prc.site, siteID : rc.siteID } );
			// save rule
			variables.siteService.save( prc.site );
			// announce event
			announce( "cbadmin_postSiteSave", { site : prc.site } );
			// Message
			cbMessagebox.info( "Site saved!" );
			relocate( prc.xehSitesManager );
		} else {
			cbMessagebox.warn( vResults.getAllErrors() );
			return editor( argumentCollection = arguments );
		}
	}

	/**
	 * Remove a site
	 */
	function remove( event, rc, prc ){
		// Get requested site to remove
		var oSite = variables.siteService.get( rc.siteID );
		// announce event
		announce( "cbadmin_preSiteRemove", { site : oSite } );
		// Now delete it
		variables.siteService.delete( oSite );
		// announce event
		announce( "cbadmin_postSiteRemove", { siteID : rc.siteID } );
		// Message
		cbMessagebox.setMessage( "info", "Site Removed!" );
		// relocate
		relocate( prc.xehSitesManager );
	}

	/**
	 * Change current editing site
	 */
	function changeSite( event, rc, prc ){
		siteService.setCurrentWorkingsiteID( rc.siteID );
		relocate( prc.xehDashboard );
	}

}
