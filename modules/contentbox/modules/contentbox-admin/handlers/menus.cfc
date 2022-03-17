/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage custom site menus
 */
component extends="baseHandler" {

	// Dependencies
	property name="menuService" inject="menuService@contentbox";
	property name="menuItemService" inject="menuItemService@contentbox";
	property name="HTMLHelper" inject="HTMLHelper@coldbox";

	// Public properties
	this.preHandler_except = "pager";

	// pre handler
	function preHandler( event, action, eventArguments, rc, prc ){
		// exit Handlers
		prc.xehMenus      = "#prc.cbAdminEntryPoint#.menus";
		prc.xehMenuEditor = "#prc.cbAdminEntryPoint#.menus.editor";
		prc.xehMenuRemove = "#prc.cbAdminEntryPoint#.menus.remove";
		prc.tabContent    = true;
	}

	/**
	 * Menu Manager index
	 */
	function index( event, rc, prc ){
		// exit Handlers
		prc.xehMenuSave      = "#prc.cbAdminEntryPoint#.menus.save";
		prc.xehMenuExportAll = "#prc.cbAdminEntryPoint#.menus.exportAll";
		prc.xehMenuImport    = "#prc.cbAdminEntryPoint#.menus.importAll";
		prc.xehMenuEditor    = "#prc.cbAdminEntryPoint#.menus.editor";
		prc.xehMenuSearch    = "#prc.cbAdminEntryPoint#.menus";
		prc.xehMenuTable     = "#prc.cbAdminEntryPoint#.menus.menuTable";
		// Get all menus
		prc.menus            = variables.menuService.list(
			criteria : { "site" : prc.oCurrentSite },
			sortOrder: "title",
			asQuery  : false
		);

		// Light up
		prc.tabContent_menu = true;
		// view
		event.setView( "menus/index" );
	}

	/**
	 * custom filebrowser "widget" for media item selections
	 */
	function filebrowser( event, rc, prc ){
		// callback
		rc.callback              = "opener.fbMenuItemSelect";
		// get settings according to contentbox
		prc.cbSetting            = settingService.buildFileBrowserSettings();
		// load jquery as it is standalone
		prc.cbSetting.loadJQuery = true;

		var args = { widget : true, settings : prc.cbSetting };
		return runEvent( event = "contentbox-filebrowser:home.index", eventArguments = args );
	}

	/**
	 * slugify remotely
	 *
	 * @return plain
	 */
	function slugify( event, rc, prc ){
		event.renderData( data = trim( variables.HTMLHelper.slugify( rc.slug ) ), type = "plain" );
	}

	/**
	 * Verify if slug is unique
	 *
	 * @return json
	 */
	function slugUnique( event, rc, prc ){
		// Params
		event.paramValue( "slug", "" ).paramValue( "menuID", "" );
		// set default data result
		var data = { "UNIQUE" : false };
		// check slug if something is passed in
		if ( len( rc.slug ) ) {
			data[ "UNIQUE" ] = variables.menuService.isSlugUnique( trim( rc.slug ), trim( rc.menuID ) );
		}
		// render result
		event.renderData( data = data, type = "json" );
	}

	/**
	 * Show Editor
	 */
	function editor( event, rc, prc ){
		event.paramValue( "menuID", 0 );
		// get new or persisted
		prc.menuItems = "";
		prc.menu      = variables.menuService.get( rc.menuID );
		if ( prc.menu.isLoaded() ) {
			prc.menuItems = variables.menuService.buildEditableMenu( prc.menu.getMenuItems() );
		}

		// exit handlers
		prc.xehMenuSave    = "#prc.cbAdminEntryPoint#.menus.save";
		prc.xehMenuEditor  = "#prc.cbAdminEntryPoint#.menus.editor";
		prc.xehMenuPreview = "#prc.cbAdminEntryPoint#.menus.preview";
		prc.xehMenuItem    = "#prc.cbAdminEntryPoint#.menus.createMenuItem";
		prc.xehSlugify     = "#prc.cbAdminEntryPoint#.menus.slugify";
		prc.xehSlugCheck   = "#prc.cbAdminEntryPoint#.menus.slugUnique";

		// get registered providers
		prc.providers = menuItemService.getProviders();

		// add assets
		prc.cssAppendList = "";
		prc.jsAppendList  = "";

		// view
		event.setView( "menus/editor" );
	}

	/**
	 * Create a menu Item
	 *
	 * @return text
	 */
	function createMenuItem( event, rc, prc ){
		prc.provider = menuItemService.getProvider( arguments.rc.type );
		// get new or persisted
		var args     = {
			menuItem : entityNew( prc.provider.getEntityName() ),
			provider : prc.provider
		};
		var str             = "<li class=""dd-item dd3-item"" data-id=""new-#createUUID()#"">";
		savecontent variable="menuString" {
			writeOutput( renderView( view = "menus/provider", args = args ) );
		};
		str &= menuString & "</li>";
		event.renderData( data = str, type = "text" );
	}

	/**
	 * Build out the index table for the async loaded menus
	 *
	 * @return html
	 */
	function menuTable( event, rc, prc ){
		// params
		event.paramValue( "searchMenu", "" ).paramValue( "isFiltering", false, true );

		// search content with filters and all
		var results = variables.menuService.search(
			searchTerm = rc.searchMenu,
			sortOrder  = "createdDate desc",
			siteID     = prc.oCurrentSite.getSiteID()
		);
		prc.menus     = results.menus;
		prc.menuCount = results.count;

		// exit handlers
		prc.xehMenuSearch = "#prc.cbAdminEntryPoint#.menus";
		prc.xehMenuExport = "#prc.cbAdminEntryPoint#.menus.export";

		// view
		event.setView( view = "menus/indexTable", layout = "ajax" );
	}

	/**
	 * Save Menu
	 */
	function save( event, rc, prc ){
		event
			.paramValue( "slug", "" )
			.paramValue( "title", "" )
			.paramvalue( "menuID", 0 )
			.paramValue( "menuItems", "{}" );
		// slugify if not passed, and allow passed slugs to be saved as-is
		if ( !len( rc.slug ) ) {
			rc.slug = variables.HTMLHelper.slugify( rc.title );
		}
		var oMenu        = variables.menuService.get( rc.menuID );
		var originalSlug = oMenu.getSlug();
		// populate and get menu
		populateModel( model = oMenu, exclude = "menuID,menuItems" );
		writeDump( var = deserializeJSON( rc.menuItems ) );
		oMenu.populateMenuItems( deserializeJSON( rc.menuItems ) );
		// announce event
		announce( "cbadmin_preMenuSave", { menu : oMenu, menuID : rc.menuID } );
		// save menu
		variables.menuService.save( oMenu.setSite( prc.oCurrentSite ) );
		// announce event
		announce( "cbadmin_postMenuSave", { menu : oMenu, originalSlug : originalSlug } );
		// messagebox
		cbMessagebox.setMessage( "info", "Menu saved!" );
		// relocate
		var targetEvent = ( len( rc.saveEvent ) ? rc.saveEvent & "/menuID/#rc.menuID#" : prc.xehMenus );
		relocate( targetEvent );
	}

	/**
	 * Preview the menu built
	 *
	 * @return text
	 */
	function preview( event, rc, prc ){
		event
			.paramValue( "slug", "" )
			.paramValue( "title", "" )
			.paramvalue( "menuID", 0 )
			.paramValue( "menuItems", "{}" );
		// slugify if not passed, and allow passed slugs to be saved as-is
		if ( !len( rc.slug ) ) {
			rc.slug = variables.HTMLHelper.slugify( rc.title );
		}
		var oMenu        = menuService.new();
		var originalSlug = oMenu.getSlug();
		// populate and get menu
		populateModel( model = oMenu, exclude = "menuID,menuItems" );
		// populate items from form
		oMenu.populateMenuItems( rawData = deserializeJSON( rc.menuItems ) );
		// render data
		event.renderData( data = variables.cbHelper.buildProviderMenu( menu = oMenu ), type = "text" );
	}

	/**
	 * Remove a menu
	 */
	function remove( event, rc, prc ){
		// params
		event.paramValue( "menuID", "" );

		// verify if contentID sent
		if ( !len( rc.menuID ) ) {
			cbMessagebox.warn( "No menus sent to delete!" );
			relocate( event = prc.xehMenus );
		}

		// Inflate to array
		rc.menuID    = listToArray( rc.menuID );
		var messages = [];

		// Iterate and remove
		for ( var thisMenuID in rc.menuID ) {
			var oMenu = variables.menuService.get( thisMenuID );
			if ( isNull( oMenu ) ) {
				arrayAppend( messages, "Invalid menuID sent: #thisMenuID#, so skipped removal" );
			} else {
				// GET id to be sent for announcing later
				var menuID = oMenu.getMenuID();
				var title  = oMenu.getSlug();
				// announce event
				announce( "cbadmin_preMenuRemove", { menu : oMenu, menuID : menuID } );
				// Delete it
				variables.menuService.delete( oMenu );
				arrayAppend( messages, "Menu '#title#' removed" );
				// announce event
				announce( "cbadmin_postMenuRemove", { menuID : menuID } );
			}
		}

		// messagebox
		cbMessagebox.info( messages );
		relocate( prc.xehMenus );
	}

	/**
	 * Export a menu
	 *
	 * @return json,xml
	 */
	function export( event, rc, prc ){
		return variables.menuService.get( rc.menuID ).getMemento( profile: "export" );
	}

	/**
	 * Export Multiple menus
	 */
	function exportAll( event, rc, prc ){
		// Set a high timeout for long exports
		setting requestTimeout="9999";
		param rc.menuID       = "";
		// Export all or some
		if ( len( rc.menuID ) ) {
			return rc.menuID
				.listToArray()
				.map( function( id ){
					return variables.menuService.get( arguments.id ).getMemento( profile: "export" );
				} );
		} else {
			return variables.menuService.getAllForExport( prc.oCurrentSite );
		}
	}

	/**
	 * Import menu from json data
	 */
	function importAll( event, rc, prc ){
		event.paramValue( "importFile", "" ).paramValue( "overrideContent", false );
		try {
			if ( len( rc.importFile ) and fileExists( rc.importFile ) ) {
				var importLog = variables.menuService.importFromFile(
					importFile = rc.importFile,
					override   = rc.overrideContent
				);
				cbMessagebox.info( "Menus imported sucessfully!" );
				flash.put( "importLog", importLog );
			} else {
				cbMessagebox.error( "The import file is invalid: #rc.importFile# cannot continue with import" );
			}
		} catch ( any e ) {
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			cbMessagebox.error( errorMessage );
		}

		relocate( prc.xehMenus );
	}

}
