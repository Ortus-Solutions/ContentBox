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

	/**
	 * Pre Handler interceptions
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		super.preHandler( argumentCollection = arguments );
		// exit Handlers
		prc.xehEntries     = "#prc.cbAdminEntryPoint#.entries";
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
		prc.xehEntrySearch     = "#prc.cbAdminEntryPoint#.entries";
		prc.xehEntryTable      = "#prc.cbAdminEntryPoint#.entries.contentTable";
		prc.xehEntryBulkStatus = "#prc.cbAdminEntryPoint#.entries.bulkstatus";
		prc.xehEntryExportAll  = "#prc.cbAdminEntryPoint#.entries.exportAll";
		prc.xehEntryImport     = "#prc.cbAdminEntryPoint#.entries.importAll";
		prc.xehEntryClone      = "#prc.cbAdminEntryPoint#.entries.clone";
		prc.xehResetHits       = "#prc.cbAdminEntryPoint#.content.resetHits";
		// Light up
		prc.tabContent_blog    = true;
		// Super size it
		super.index( argumentCollection = arguments );
	}

	/**
	 * Content table brought via ajax
	 */
	function contentTable( event, rc, prc ){
		// exit handlers
		prc.xehEntrySearch    = "#prc.cbAdminEntryPoint#.entries";
		prc.xehEntryQuickLook = "#prc.cbAdminEntryPoint#.entries.quickLook";
		prc.xehEntryHistory   = "#prc.cbAdminEntryPoint#.versions.index";
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
		// exit handlers
		prc.xehEntrySave = "#prc.cbAdminEntryPoint#.entries.save";
		prc.xehSlugify   = "#prc.cbAdminEntryPoint#.entries.slugify";
		// Super size it
		super.editor( argumentCollection = arguments );
	}

	/**
	 * Save an entry
	 */
	function save( event, rc, prc ){
		arguments.adminPermission = "ENTRIES_ADMIN";
		arguments.relocateTo      = prc.xehEntries;
		super.save( argumentCollection = arguments );
	}

	/**
	 * Clone an entry
	 */
	function clone( event, rc, prc ){
		arguments.relocateTo = prc.xehEntries;
		super.save( argumentCollection = arguments );
	}

	/**
	 * Remove an entry
	 */
	function remove( event, rc, prc ){
		arguments.relocateTo = prc.xehEntries;
		super.save( argumentCollection = arguments );
	}

	/**
	 * A viewlet for showcasing mini views of blog entries
	 *
	 * @authorID Show entries from all authors or only specific author ids
	 * @max The max number fo entries to show, defaults to 0
	 * @pagination Show pagination or not
	 * @latest Show the by latest modified or created
	 */
	function pager(
		event,
		rc,
		prc,
		authorID   = "all",
		max        = 0,
		pagination = true,
		latest     = false
	){
		// check if authorID exists in rc to do an override, maybe it's the paging call
		if ( event.valueExists( "pager_authorID" ) ) {
			arguments.authorID = rc.pager_authorID;
		}
		// Max rows incoming or take default for pagination.
		if ( arguments.max eq 0 ) {
			arguments.max = prc.cbSettings.cb_paging_maxrows;
		}

		// paging default
		event.paramValue( "page", 1 );

		// exit handlers
		prc.xehPager          = "#prc.cbAdminEntryPoint#.entries.pager";
		prc.xehEntryEditor    = "#prc.cbAdminEntryPoint#.entries.editor";
		prc.xehEntryQuickLook = "#prc.cbAdminEntryPoint#.entries.quickLook";
		prc.xehEntryHistory   = "#prc.cbAdminEntryPoint#.versions.index";

		// prepare paging object
		prc.pager_oPaging    = getInstance( "Paging@contentbox" );
		prc.pager_paging     = prc.pager_oPaging.getBoundaries();
		prc.pager_pagingLink = "javascript:pagerLink(@page@)";
		prc.pager_pagination = arguments.pagination;

		// Sorting
		var sortOrder = "publishedDate DESC";
		if ( arguments.latest ) {
			sortOrder = "modifiedDate desc";
		}

		// search entries with filters and all
		var entryResults = variables.ormService.search(
			author    = arguments.authorID,
			offset    = prc.pager_paging.startRow - 1,
			max       = arguments.max,
			sortOrder = sortOrder
		);
		prc.pager_entries      = entryResults.entries;
		prc.pager_entriesCount = entryResults.count;

		// author in RC
		prc.pager_authorID = arguments.authorID;

		// view pager
		return renderView( view = "entries/pager", module = "contentbox-admin" );
	}

	/**
	 * Editor selector for entries UI
	 */
	function editorSelector( event, rc, prc ){
		// exit handlers
		prc.xehEditorSelector = "#prc.cbAdminEntryPoint#.entries.editorSelector";
		// Sorting
		arguments.sortOrder   = "publishedDate asc";
		// Supersize me
		super.editorSelector( argumentCollection = arguments );
	}

	/**
	 * Export an entry
	 */
	function export( event, rc, prc ){
		return variables.ormService
			.get( event.getValue( "contentID", 0 ) )
			.getMemento( profile: "export" );
	}

	/**
	 * Export Multiple Entries
	 */
	function exportAll( event, rc, prc ){
		// Set a high timeout for long exports
		setting requestTimeout="9999";
		param rc.contentID    = "";
		// Export all or some
		if ( len( rc.contentID ) ) {
			return rc.contentID
				.listToArray()
				.map( function( id ){
					return variables.ormService.get( arguments.id ).getMemento( profile: "export" );
				} );
		} else {
			return variables.ormService.getAllForExport( prc.oCurrentSite );
		}
	}

	/**
	 * Import entries
	 */
	function importAll( event, rc, prc ){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try {
			if ( len( rc.importFile ) and fileExists( rc.importFile ) ) {
				var importLog = variables.ormService.importFromFile(
					importFile = rc.importFile,
					override   = rc.overrideContent
				);
				cbMessageBox.info( "Entries imported sucessfully!" );
				flash.put( "importLog", importLog );
			} else {
				cbMessageBox.error(
					"The import file is invalid: #rc.importFile# cannot continue with import"
				);
			}
		} catch ( any e ) {
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			cbMessageBox.error( errorMessage );
		}
		relocate( prc.xehEntries );
	}

}
