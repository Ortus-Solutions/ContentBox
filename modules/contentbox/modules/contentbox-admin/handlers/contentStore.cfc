/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage content store
 */
component extends="baseContentHandler" {

	// Dependencies
	property name="ormService" inject="ormService@contentbox";

	// Properties
	variables.handler         = "contentStore";
	variables.defaultOrdering = "order asc, createdDate desc";
	variables.entry           = "ContentStore";
	variables.entityPlural    = "content";

	/**
	 * Pre Handler interceptions
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		super.preHandler( argumentCollection = arguments );
		// exit Handlers
		prc.xehContentStore  = "#prc.cbAdminEntryPoint#.contentStore";
		prc.xehContentEditor = "#prc.cbAdminEntryPoint#.contentStore.editor";
		prc.xehContentRemove = "#prc.cbAdminEntryPoint#.contentStore.remove";
	}

	/**
	 * Show Content
	 */
	function index( event, rc, prc ){
		// exit handlers
		prc.xehContentSearch     = "#prc.cbAdminEntryPoint#.contentStore";
		prc.xehContentTable      = "#prc.cbAdminEntryPoint#.contentStore.contentTable";
		prc.xehContentBulkStatus = "#prc.cbAdminEntryPoint#.contentStore.bulkstatus";
		prc.xehContentExportAll  = "#prc.cbAdminEntryPoint#.contentStore.exportAll";
		prc.xehContentImport     = "#prc.cbAdminEntryPoint#.contentStore.importAll";
		prc.xehContentClone      = "#prc.cbAdminEntryPoint#.contentStore.clone";
		prc.xehResetHits         = "#prc.cbAdminEntryPoint#.content.resetHits";

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
		prc.xehContentSearch  = "#prc.cbAdminEntryPoint#.contentStore";
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
		// exit handlers
		prc.xehContentSave = "#prc.cbAdminEntryPoint#.contentStore.save";
		prc.xehSlugify     = "#prc.cbAdminEntryPoint#.contentStore.slugify";
		// Super size it
		super.editor( argumentCollection = arguments );
	}

	/**
	 * Save a new content store item
	 */
	function save( event, rc, prc ){
		arguments.adminPermission = "CONTENTSTORE_ADMIN";
		arguments.relocateTo      = prc.xehContentStore;
		super.save( argumentCollection = arguments );
	}

	/**
	 * Clone a content store item
	 */
	function clone( event, rc, prc ){
		arguments.relocateTo = prc.xehContentStore;
		super.save( argumentCollection = arguments );
	}

	// remove
	function remove( event, rc, prc ){
		// params
		event.paramValue( "contentID", "" ).paramValue( "parent", "" );

		// verify if contentID sent
		if ( !len( rc.contentID ) ) {
			cbMessageBox.warn( "No content sent to delete!" );
			relocate( event = prc.xehContentStore, queryString = "parent=#rc.parent#" );
		}

		// Inflate to array
		rc.contentID = listToArray( rc.contentID );
		var messages = [];

		// Iterate and remove
		for ( var thisContentID in rc.contentID ) {
			var content = variables.ormService.get( thisContentID );
			if ( isNull( content ) ) {
				arrayAppend(
					messages,
					"Invalid content contentID sent: #thisContentID#, so skipped removal"
				);
			} else {
				// GET id to be sent for announcing later
				var contentID = content.getContentID();
				var title     = content.getTitle();
				// announce event
				announce( "cbadmin_preContentStoreRemove", { content : content } );
				// Delete it
				ormService.delete( content );
				arrayAppend( messages, "content '#title#' removed" );
				// announce event
				announce( "cbadmin_postContentStoreRemove", { contentID : contentID } );
			}
		}
		// messagebox
		cbMessageBox.info( messages );
		// relocate
		relocate( event = prc.xehContentStore, queryString = "parent=#rc.parent#" );
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
		latest     = false
	){
		// check if authorID exists in rc to do an override, maybe it's the paging call
		if ( event.valueExists( "pager_authorID" ) ) {
			arguments.authorID = rc.pager_authorID;
		}
		// check if parent exists in rc to do an override, maybe it's the paging call
		if ( event.valueExists( "pager_parentID" ) ) {
			arguments.parent = rc.pager_parentID;
		}
		// Max rows incoming or take default for pagination.
		if ( arguments.max eq 0 ) {
			arguments.max = prc.cbSettings.cb_paging_maxrows;
		}

		// paging default
		event.paramValue( "page", 1 );

		// exit handlers
		prc.xehPager          = "#prc.cbAdminEntryPoint#.contentStore.pager";
		prc.xehContentEditor  = "#prc.cbAdminEntryPoint#.contentStore.editor";
		prc.xehContentHistory = "#prc.cbAdminEntryPoint#.versions.index";

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

		// search content with filters and all
		var contentResults = variables.ormService.search(
			author = arguments.authorID,
			parent = (
				structKeyExists( arguments, "parent" ) ? arguments.parent : javacast( "null", "" )
			),
			offset    = prc.pager_paging.startRow - 1,
			max       = arguments.max,
			sortOrder = sortOrder
		);
		prc.pager_content      = contentResults.content;
		prc.pager_contentCount = contentResults.count;
		// author in RC
		prc.pager_authorID     = arguments.authorID;
		// parent
		event.paramValue( "pagePager_parentID", "", true );
		if ( structKeyExists( arguments, "parent" ) ) {
			prc.pagePager_parentID = arguments.parent;
		}
		// view pager
		return renderView( view = "contentStore/pager", module = "contentbox-admin" );
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
		prc.xehEditorSelector = "#prc.cbAdminEntryPoint#.contentStore.editorSelector";

		// prepare paging object
		prc.oPaging    = getInstance( "Paging@contentbox" );
		prc.paging     = prc.oPaging.getBoundaries();
		prc.pagingLink = "javascript:pagerLink(@page@)";

		// search content with filters and all
		var contentResults = variables.ormService.search(
			search             : rc.search,
			offset             : prc.paging.startRow - 1,
			max                : prc.cbSettings.cb_paging_maxrows,
			sortOrder          : "createdDate asc",
			searchActiveContent: false,
			siteID             : prc.oCurrentSite.getsiteID()
		);

		prc.content      = contentResults.content;
		prc.contentCount = contentResults.count;
		prc.CBHelper     = CBHelper;

		// if ajax and searching, just return tables
		if ( event.isAjax() and len( rc.search ) OR rc.clear ) {
			return renderView( view = "contentStore/editorSelectorEntries", prePostExempt = true );
		} else {
			event.setView( view = "contentStore/editorSelector", layout = "ajax" );
		}
	}

	// Export content
	function export( event, rc, prc ){
		return variables.ormService
			.get( event.getValue( "contentID", 0 ) )
			.getMemento( profile: "export" );
	}

	// Export All content
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

	// import contentstore
	function importAll( event, rc, prc ){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try {
			if ( len( rc.importFile ) and fileExists( rc.importFile ) ) {
				var importLog = variables.ormService.importFromFile(
					importFile = rc.importFile,
					override   = rc.overrideContent
				);
				cbMessageBox.info( "Content imported sucessfully!" );
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
		relocate( prc.xehContentStore );
	}

}
