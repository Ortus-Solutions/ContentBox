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
		prc.site   = variables.siteService.get( event.getValue( "siteId", 0 ) );
		// Get all registered themes
		prc.themes = variables.themeService.getThemes();
		// pages
		prc.pages  = variables.pageService.search(
			sortOrder   = "slug asc",
			isPublished = true,
			siteId      = prc.site.getId()
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
		var oSite    = populateModel( siteService.get( id: rc.siteId ) );
		// validate it
		var vResults = validateModel( oSite );
		if ( !vResults.hasErrors() ) {
			// announce event
			announce( "cbadmin_preSiteSave", { site : oSite, siteId : rc.siteId } );
			// save rule
			variables.siteService.save( oSite );
			// announce event
			announce( "cbadmin_postSiteSave", { site : oSite } );
			// Message
			cbMessagebox.info( "Site saved!" );
			relocate( prc.xehSitesManager );
		} else {
			cbMessagebox.warn( messageArray = vResults.getAllErrors() );
			return editor( argumentCollection = arguments );
		}
	}

	/**
	 * Remove a site
	 */
	function remove( event, rc, prc ){
		// Get requested site to remove
		var oSite = variables.siteService.get( rc.siteId );
		// announce event
		announce( "cbadmin_preSiteRemove", { site : oSite } );
		// Now delete it
		variables.siteService.delete( oSite );
		// announce event
		announce( "cbadmin_postSiteRemove", { siteId : rc.siteId } );
		// Message
		cbMessagebox.setMessage( "info", "Site Removed!" );
		// relocate
		relocate( prc.xehSitesManager );
	}

	/**
	 * Change current editing site
	 */
	function changeSite( event, rc, prc ){
		siteService.setCurrentWorkingSiteId( rc.siteId );
		relocate( prc.xehDashboard );
	}

}
