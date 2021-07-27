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

	/**
	 * Pre Handler interceptions
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		super.preHandler( argumentCollection = arguments );
		// exit Handlers
		prc.xehPages      = "#prc.cbAdminEntryPoint#.pages";
		prc.xehPageEditor = "#prc.cbAdminEntryPoint#.pages.editor";
		prc.xehPageRemove = "#prc.cbAdminEntryPoint#.pages.remove";
	}

	/**
	 * Show Content
	 */
	function index( event, rc, prc ){
		// exit handlers
		prc.xehPageSearch     = "#prc.cbAdminEntryPoint#.pages";
		prc.xehPageTable      = "#prc.cbAdminEntryPoint#.pages.contentTable";
		prc.xehPageBulkStatus = "#prc.cbAdminEntryPoint#.pages.bulkstatus";
		prc.xehPageExportAll  = "#prc.cbAdminEntryPoint#.pages.exportAll";
		prc.xehPageImport     = "#prc.cbAdminEntryPoint#.pages.importAll";
		prc.xehPageClone      = "#prc.cbAdminEntryPoint#.pages.clone";
		prc.xehResetHits      = "#prc.cbAdminEntryPoint#.content.resetHits";

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
		prc.xehPageSearch    = "#prc.cbAdminEntryPoint#.pages";
		prc.xehPageQuickLook = "#prc.cbAdminEntryPoint#.pages.quickLook";
		prc.xehPageOrder     = "#prc.cbAdminEntryPoint#.pages.changeOrder";
		prc.xehPageHistory   = "#prc.cbAdminEntryPoint#.versions.index";
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
		// exit handlers
		prc.xehPageSave      = "#prc.cbAdminEntryPoint#.pages.save";
		prc.xehSlugify       = "#prc.cbAdminEntryPoint#.pages.slugify";
		// Super size it
		super.editor( argumentCollection = arguments );
	}

	/**
	 * Save a page
	 */
	function save( event, rc, prc ){
		arguments.adminPermission = "PAGES_ADMIN";
		arguments.relocateTo      = prc.xehPages;
		super.save( argumentCollection = arguments );
	}

	/**
	 * Clone a page
	 */
	function clone( event, rc, prc ){
		arguments.relocateTo = prc.xehPages;
		super.save( argumentCollection = arguments );
	}

	/**
	 * Remove a page
	 */
	function remove( event, rc, prc ){
		// params
		event.paramValue( "contentID", "" ).paramValue( "parent", "" );

		// verify if contentID sent
		if ( !len( rc.contentID ) ) {
			cbMessageBox.warn( "No pages sent to delete!" );
			relocate( event = prc.xehPages, queryString = "parent=#rc.parent#" );
		}

		// Inflate to array
		rc.contentID = listToArray( rc.contentID );
		var messages = [];

		// Iterate and remove pages
		for ( var thisContentID in rc.contentID ) {
			var page = variables.ormService.get( thisContentID );
			if ( isNull( page ) ) {
				arrayAppend(
					messages,
					"Invalid page contentID sent: #thisContentID#, so skipped removal"
				);
			} else {
				// GET id to be sent for announcing later
				var contentID = page.getContentID();
				var title     = page.getTitle();
				// announce event
				announce( "cbadmin_prePageRemove", { page : page } );
				// Diassociate it, bi-directional relationship
				if ( page.hasParent() ) {
					page.getParent().removeChild( page );
				}
				// Send for deletion
				variables.ormService.delete( page );
				arrayAppend( messages, "Page '#title#' removed" );
				// announce event
				announce( "cbadmin_postPageRemove", { contentID : contentID } );
			}
		}
		// messagebox
		cbMessageBox.info( messages );
		// relocate
		relocate( event = prc.xehPages, queryString = "parent=#rc.parent#" );
	}

	// pager viewlet
	function pager(
		event,
		rc,
		prc,
		authorID = "all",
		parent,
		max        = 0,
		pagination = true,
		latest     = false,
		sorting    = true
	){
		// check if authorID exists in rc to do an override, maybe it's the paging call
		if ( event.valueExists( "pager_authorID" ) ) {
			arguments.authorID = rc.pager_authorID;
		}
		// check if parent exists in rc to do an override, maybe it's the paging call
		if ( event.valueExists( "pager_parentID" ) ) {
			arguments.parent = rc.pager_parentID;
		}
		// check if pagination exists in rc to do an override, maybe it's the paging call
		if ( event.valueExists( "pagePager_pagination" ) ) {
			arguments.pagination = rc.pagePager_pagination;
		}
		// Check for sorting
		if ( event.valueExists( "pagePager_sorting" ) ) {
			arguments.sorting = rc.pagePager_sorting;
		}

		// Max rows incoming or take default for pagination.
		if ( arguments.max eq 0 ) {
			arguments.max = prc.cbSettings.cb_paging_maxrows;
		}

		// paging default
		event.paramValue( "page", 1 );

		// exit handlers
		prc.xehPagePager     = "#prc.cbAdminEntryPoint#.pages.pager";
		prc.xehPageEditor    = "#prc.cbAdminEntryPoint#.pages.editor";
		prc.xehPageQuickLook = "#prc.cbAdminEntryPoint#.pages.quickLook";
		prc.xehPageOrder     = "#prc.cbAdminEntryPoint#.pages.changeOrder";
		prc.xehPageHistory   = "#prc.cbAdminEntryPoint#.versions.index";

		// prepare paging object
		prc.pagePager_oPaging    = getInstance( "Paging@contentbox" );
		prc.pagePager_paging     = prc.pagePager_oPaging.getBoundaries();
		prc.pagePager_pagingLink = "javascript:pagerLink(@page@)";
		prc.pagePager_pagination = arguments.pagination;

		// Sorting
		var sortOrder = "title asc";
		if ( arguments.latest ) {
			sortOrder = "modifiedDate desc";
		}

		// search entries with filters and all
		var pageResults = variables.ormService.search(
			author = arguments.authorID,
			parent = (
				structKeyExists( arguments, "parent" ) ? arguments.parent : javacast( "null", "" )
			),
			offset    = prc.pagePager_paging.startRow - 1,
			max       = arguments.max,
			sortOrder = sortOrder
		);

		prc.pager_pages      = pageResults.pages;
		prc.pager_pagesCount = pageResults.count;

		// author info
		prc.pagePager_authorID = arguments.authorID;
		// Sorting
		prc.pagePager_sorting  = arguments.sorting;
		// parent
		event.paramValue( "pagePager_parentID", "", true );
		if ( structKeyExists( arguments, "parent" ) ) {
			prc.pagePager_parentID = arguments.parent;
		}
		// view pager
		return renderView( view = "pages/pager", module = "contentbox-admin" );
	}

	// slugify remotely
	function slugify( event, rc, prc ){
		event.renderData( data = trim( variables.HTMLHelper.slugify( rc.slug ) ), type = "plain" );
	}

	// editor selector
	function editorSelector( event, rc, prc ){
		// paging default
		event.paramValue( "page", 1 );
		event.paramValue( "search", "" );
		event.paramValue( "clear", false );

		// exit handlers
		prc.xehEditorSelector = "#prc.cbAdminEntryPoint#.pages.editorSelector";

		// prepare paging object
		prc.oPaging    = getInstance( "Paging@contentbox" );
		prc.paging     = prc.oPaging.getBoundaries();
		prc.pagingLink = "javascript:pagerLink(@page@)";

		// search entries with filters and all
		var pageResults = variables.ormService.search(
			search             : rc.search,
			offset             : prc.paging.startRow - 1,
			max                : prc.cbSettings.cb_paging_maxrows,
			sortOrder          : "slug asc",
			searchActiveContent: false,
			siteID             : prc.oCurrentSite.getsiteID()
		);
		// setup data for display
		prc.entries      = pageResults.pages;
		prc.entriesCount = pageResults.count;
		prc.CBHelper     = CBHelper;
		prc.contentType  = "Pages";

		// if ajax and searching, just return tables
		if ( event.isAjax() and len( rc.search ) OR rc.clear ) {
			return renderView( view = "content/editorSelectorPages", prePostExempt = true );
		} else {
			event.setView( view = "content/editorSelector", layout = "ajax" );
		}
	}

	/**
	 * Export a page hierarchy
	 */
	function export( event, rc, prc ){
		return variables.ormService
			.get( event.getValue( "contentID", 0 ) )
			.getMemento( profile: "export" );
	}

	/**
	 * Export Multiple Pages
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
	 * Import pages
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
				cbMessageBox.info( "Pages imported sucessfully!" );
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
		relocate( prc.xehPages );
	}

}
