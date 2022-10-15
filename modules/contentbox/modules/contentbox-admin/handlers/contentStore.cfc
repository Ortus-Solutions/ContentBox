/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage content store
 */
component extends="baseContentHandler" {

	// Dependencies
	property name="ormService" inject="contentStoreService@contentbox";

	// Properties
	variables.handler         = "contentStore";
	variables.defaultOrdering = "order asc, createdDate desc";
	variables.entry           = "ContentStore";
	variables.entityPlural    = "content";
	variables.securityPrefix  = "CONTENTSTORE";

	/**
	 * Pre Handler interceptions
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		super.preHandler( argumentCollection = arguments );
		// exit Handlers
		prc.xehContentStore  = "#prc.cbAdminEntryPoint#.contentStore.index";
		prc.xehContentEditor = "#prc.cbAdminEntryPoint#.contentStore.editor";
		prc.xehContentRemove = "#prc.cbAdminEntryPoint#.contentStore.remove";
	}

	/**
	 * Show Content
	 */
	function index( event, rc, prc ){
		// exit handlers
		prc.xehContentSearch     = "#prc.cbAdminEntryPoint#.contentStore.index";
		prc.xehContentTable      = "#prc.cbAdminEntryPoint#.contentStore.contentTable";
		prc.xehContentBulkStatus = "#prc.cbAdminEntryPoint#.contentStore.bulkstatus";
		prc.xehContentExportAll  = "#prc.cbAdminEntryPoint#.contentStore.exportAll";
		prc.xehContentImport     = "#prc.cbAdminEntryPoint#.contentStore.importAll";
		prc.xehContentClone      = "#prc.cbAdminEntryPoint#.contentStore.clone";

		// Light up
		prc.tabContent_contentStore = true;

		// Super size it
		super.index( argumentCollection = arguments );
	}

	/**
	 * Content table brought via ajax
	 */
	function contentTable( event, rc, prc ){
		// exit handlers
		prc.xehContentSearch  = "#prc.cbAdminEntryPoint#.contentStore.index";
		prc.xehContentHistory = "#prc.cbAdminEntryPoint#.versions.index";
		prc.xehContentExport  = "#prc.cbAdminEntryPoint#.contentStore.export";
		prc.xehContentClone   = "#prc.cbAdminEntryPoint#.contentStore.clone";
		prc.xehContentOrder   = "#prc.cbAdminEntryPoint#.contentStore.changeOrder";
		// Super size it
		super.contentTable( argumentCollection = arguments );
	}

	/**
	 * Change the status of many content objects
	 */
	function bulkStatus( event, rc, prc ){
		arguments.relocateTo = prc.xehContentStore;
		super.bulkStatus( argumentCollection = arguments );
	}

	/**
	 * Show the editor
	 */
	function editor( event, rc, prc ){
		// Super size it
		super.editor( argumentCollection = arguments );
	}

	/**
	 * Save a new content store item
	 */
	function save( event, rc, prc ){
		arguments.adminPermission = "CONTENTSTORE_ADMIN,CONTENTSTORE_EDITOR";
		arguments.relocateTo      = prc.xehContentStore;
		super.save( argumentCollection = arguments );
	}

	/**
	 * Clone a content store item
	 */
	function clone( event, rc, prc ){
		arguments.relocateTo = prc.xehContentStore;
		super.clone( argumentCollection = arguments );
	}

	/**
	 * Remove a content store item
	 */
	function remove( event, rc, prc ){
		arguments.relocateTo = prc.xehContentStore;
		super.remove( argumentCollection = arguments );
	}

	/**
	 * Editor selector for contentstore UI
	 */
	function editorSelector( event, rc, prc ){
		// Sorting
		arguments.sortOrder = "createdDate asc";
		// Supersize me
		super.editorSelector( argumentCollection = arguments );
	}

	/**
	 * Import content store items
	 */
	function importAll( event, rc, prc ){
		arguments.relocateTo = prc.xehContentStore;
		super.importAll( argumentCollection = arguments );
	}

}
