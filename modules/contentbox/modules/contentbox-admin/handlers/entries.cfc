/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage blog entries
 */
component extends="baseContentHandler" {

	// Dependencies
	property name="ormService" inject="entryService@contentbox";

	// Properties
	variables.handler         = "entries";
	variables.defaultOrdering = "createdDate desc";
	variables.entity          = "Entry";
	variables.entityPlural    = "entries";
	variables.securityPrefix  = "ENTRIES";

	/**
	 * Pre Handler interceptions
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		super.preHandler( argumentCollection = arguments );
		// exit Handlers
		prc.xehEntries     = "#prc.cbAdminEntryPoint#.entries.index";
		prc.xehEntryEditor = "#prc.cbAdminEntryPoint#.entries.editor";
		prc.xehEntryRemove = "#prc.cbAdminEntryPoint#.entries.remove";
		// Verify if blog is disabled?
		if ( !prc.oCurrentSite.getIsBlogEnabled() ) {
			cbMessageBox.warn(
				"The blog has been currently disabled. You can activate it again in your ContentBox settings panel"
			);
			relocate( prc.xehDashboard );
		}
	}

	/**
	 * Show Content
	 */
	function index( event, rc, prc ){
		// exit handlers
		prc.xehEntrySearch     = "#prc.cbAdminEntryPoint#.entries.index";
		prc.xehEntryTable      = "#prc.cbAdminEntryPoint#.entries.contentTable";
		prc.xehEntryBulkStatus = "#prc.cbAdminEntryPoint#.entries.bulkstatus";
		prc.xehEntryExportAll  = "#prc.cbAdminEntryPoint#.entries.exportAll";
		prc.xehEntryImport     = "#prc.cbAdminEntryPoint#.entries.importAll";
		prc.xehEntryClone      = "#prc.cbAdminEntryPoint#.entries.clone";

		// Light up
		prc.tabContent_blog = true;

		// Super size it
		super.index( argumentCollection = arguments );
	}

	/**
	 * Content table brought via ajax
	 */
	function contentTable( event, rc, prc ){
		// exit handlers
		prc.xehEntrySearch    = "#prc.cbAdminEntryPoint#.entries.index";
		prc.xehEntryQuickLook = "#prc.cbAdminEntryPoint#.entries.quickLook";
		prc.xehEntryExport    = "#prc.cbAdminEntryPoint#.entries.export";
		prc.xehEntryClone     = "#prc.cbAdminEntryPoint#.entries.clone";
		// Super size it
		super.contentTable( argumentCollection = arguments );
	}

	/**
	 * Change the status of many content objects
	 */
	function bulkStatus( event, rc, prc ){
		arguments.relocateTo = prc.xehEntries;
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
	 * Save an entry
	 */
	function save( event, rc, prc ){
		arguments.adminPermission = "ENTRIES_ADMIN,ENTRIES_EDITOR";
		arguments.relocateTo      = prc.xehEntries;
		super.save( argumentCollection = arguments );
	}

	/**
	 * Clone an entry
	 */
	function clone( event, rc, prc ){
		arguments.relocateTo = prc.xehEntries;
		super.clone( argumentCollection = arguments );
	}

	/**
	 * Remove an entry
	 */
	function remove( event, rc, prc ){
		arguments.relocateTo = prc.xehEntries;
		super.remove( argumentCollection = arguments );
	}

	/**
	 * Editor selector for entries UI
	 */
	function editorSelector( event, rc, prc ){
		// Sorting
		arguments.sortOrder = "publishedDate asc";
		// Supersize me
		super.editorSelector( argumentCollection = arguments );
	}

	/**
	 * Import entries
	 */
	function importAll( event, rc, prc ){
		arguments.relocateTo = prc.xehEntries;
		super.importAll( argumentCollection = arguments );
	}

}
