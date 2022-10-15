/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage site pages
 */
component extends="baseContentHandler" {

	// Dependencies
	property name="ormService" inject="pageService@contentbox";

	// Properties
	variables.handler         = "pages";
	variables.defaultOrdering = "order asc, createdDate desc";
	variables.entity          = "Page";
	variables.entityPlural    = "pages";
	variables.securityPrefix  = "PAGES";

	/**
	 * Pre Handler interceptions
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		super.preHandler( argumentCollection = arguments );
		// exit Handlers
		prc.xehPages      = "#prc.cbAdminEntryPoint#.pages.index";
		prc.xehPageEditor = "#prc.cbAdminEntryPoint#.pages.editor";
		prc.xehPageRemove = "#prc.cbAdminEntryPoint#.pages.remove";
	}

	/**
	 * Show Content
	 */
	function index( event, rc, prc ){
		// exit handlers
		prc.xehPageSearch     = "#prc.cbAdminEntryPoint#.pages.index";
		prc.xehPageTable      = "#prc.cbAdminEntryPoint#.pages.contentTable";
		prc.xehPageBulkStatus = "#prc.cbAdminEntryPoint#.pages.bulkstatus";
		prc.xehPageExportAll  = "#prc.cbAdminEntryPoint#.pages.exportAll";
		prc.xehPageImport     = "#prc.cbAdminEntryPoint#.pages.importAll";
		prc.xehPageClone      = "#prc.cbAdminEntryPoint#.pages.clone";

		// Light up
		prc.tabContent_Pages = true;

		// Super size it
		super.index( argumentCollection = arguments );
	}

	/**
	 * Content table brought via ajax
	 */
	function contentTable( event, rc, prc ){
		// exit handlers
		prc.xehPageSearch    = "#prc.cbAdminEntryPoint#.pages.index";
		prc.xehPageQuickLook = "#prc.cbAdminEntryPoint#.pages.quickLook";
		prc.xehPageOrder     = "#prc.cbAdminEntryPoint#.pages.changeOrder";
		prc.xehPageExport    = "#prc.cbAdminEntryPoint#.pages.export";
		prc.xehPageClone     = "#prc.cbAdminEntryPoint#.pages.clone";
		// Super size it
		super.contentTable( argumentCollection = arguments );
	}

	/**
	 * Change the status of many content objects
	 */
	function bulkStatus( event, rc, prc ){
		arguments.relocateTo = prc.xehPages;
		super.bulkStatus( argumentCollection = arguments );
	}

	/**
	 * Show the editor
	 */
	function editor( event, rc, prc ){
		// Get active layout record and available page only layouts
		prc.themeRecord      = variables.themeService.getActiveTheme();
		prc.availableLayouts = reReplaceNoCase( prc.themeRecord.layouts, "blog,?", "" );
		// Super size it
		super.editor( argumentCollection = arguments );
	}

	/**
	 * Save a page
	 */
	function save( event, rc, prc ){
		arguments.adminPermission = "PAGES_ADMIN,PAGES_EDITOR";
		arguments.relocateTo      = prc.xehPages;
		super.save( argumentCollection = arguments );
	}

	/**
	 * Clone a page
	 */
	function clone( event, rc, prc ){
		arguments.relocateTo = prc.xehPages;
		super.clone( argumentCollection = arguments );
	}

	/**
	 * Remove a page
	 */
	function remove( event, rc, prc ){
		arguments.relocateTo = prc.xehPages;
		super.remove( argumentCollection = arguments );
	}

	/**
	 * Called by editors to bring a modal selector of content
	 */
	function editorSelector( event, rc, prc ){
		// Sorting
		arguments.sortOrder = "slug asc";
		// Supersize me
		super.editorSelector( argumentCollection = arguments );
	}

	/**
	 * Import pages
	 */
	function importAll( event, rc, prc ){
		arguments.relocateTo = prc.xehPages;
		super.importAll( argumentCollection = arguments );
	}

}
