/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage blog entries
 */
component extends="baseContentHandler" {

	// Dependencies
	property name="entryService" inject="entryService@cb";
	property name="CKHelper" inject="CKHelper@contentbox-ckeditor";
	property name="HTMLHelper" inject="HTMLHelper@coldbox";

	// Public properties
	this.preHandler_except = "pager";

	/**
	 * Pre Handler interceptions
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		super.preHandler( argumentCollection = arguments );

		// exit Handlers
		prc.xehEntries     = "#prc.cbAdminEntryPoint#.entries";
		prc.xehEntryEditor = "#prc.cbAdminEntryPoint#.entries.editor";
		prc.xehEntryRemove = "#prc.cbAdminEntryPoint#.entries.remove";

		// Verify if disabled?
		if ( !prc.oCurrentSite.getIsBlogEnabled() ) {
			cbMessageBox.warn(
				"The blog has been currently disabled. You can activate it again in your ContentBox settings panel"
			);
			relocate( prc.xehDashboard );
		}
	}

	/**
	 * Show blog entries
	 */
	function index( event, rc, prc ){
		// get all authors
		prc.authors = authorService.getAll( sortOrder = "lastName" );

		// get all categories
		prc.categories = variables.categoryService.list(
			criteria  = { "site" : prc.oCurrentSite },
			sortOrder = "category",
			asQuery   = false
		);

		// exit handlers
		prc.xehEntrySearch     = "#prc.cbAdminEntryPoint#.entries";
		prc.xehEntryTable      = "#prc.cbAdminEntryPoint#.entries.entriesTable";
		prc.xehEntryBulkStatus = "#prc.cbAdminEntryPoint#.entries.bulkstatus";
		prc.xehEntryExportAll  = "#prc.cbAdminEntryPoint#.entries.exportAll";
		prc.xehEntryImport     = "#prc.cbAdminEntryPoint#.entries.importAll";
		prc.xehEntryClone      = "#prc.cbAdminEntryPoint#.entries.clone";
		prc.xehResetHits       = "#prc.cbAdminEntryPoint#.content.resetHits";

		// Light up
		prc.tabContent_blog = true;

		// view
		event.setView( "entries/index" );
	}

	/**
	 * The entries table called via Ajax
	 */
	function entriesTable( event, rc, prc ){
		// params
		event
			.paramValue( "page", 1 )
			.paramValue( "searchEntries", "" )
			.paramValue( "fAuthors", "all" )
			.paramValue( "fCreators", "all" )
			.paramValue( "fCategories", "all" )
			.paramValue( "fStatus", "any" )
			.paramValue( "isFiltering", false, true )
			.paramValue( "showAll", false );

		// prepare paging object
		prc.oPaging    = getInstance( "Paging@cb" );
		prc.paging     = prc.oPaging.getBoundaries();
		prc.pagingLink = "javascript:contentPaginate(@page@)";

		// is Filtering?
		if (
			rc.fAuthors neq "all" OR
			rc.fStatus neq "any" OR
			rc.fCategories neq "all" OR
			rc.fCreators neq "all" OR
			rc.showAll
		) {
			prc.isFiltering = true;
		}

		// search entries with filters and all
		var entryResults = variables.entryService.search(
			search     : rc.searchEntries,
			isPublished: rc.fStatus,
			category   : rc.fCategories,
			author     : rc.fAuthors,
			creator    : rc.fCreators,
			offset     : ( rc.showAll ? 0 : prc.paging.startRow - 1 ),
			max        : ( rc.showAll ? 0 : prc.cbSettings.cb_paging_maxrows ),
			sortOrder  : "createdDate desc",
			siteID     : prc.oCurrentSite.getsiteID()
		);
		prc.entries      = entryResults.entries;
		prc.entriesCount = entryResults.count;

		// exit handlers
		prc.xehEntrySearch    = "#prc.cbAdminEntryPoint#.entries";
		prc.xehEntryQuickLook = "#prc.cbAdminEntryPoint#.entries.quickLook";
		prc.xehEntryHistory   = "#prc.cbAdminEntryPoint#.versions.index";
		prc.xehEntryExport    = "#prc.cbAdminEntryPoint#.entries.export";
		prc.xehEntryClone     = "#prc.cbAdminEntryPoint#.entries.clone";

		// view
		event.setView( view = "entries/indexTable", layout = "ajax" );
	}

	/**
	 * Entries quick look
	 */
	function quickLook( event, rc, prc ){
		// get entry
		prc.content          = variables.entryService.get( event.getValue( "contentID", 0 ) );
		prc.xehContentEditor = "#prc.cbAdminEntryPoint#.entries.editor";
		event.setView( view = "content/quickLook", layout = "ajax" );
	}

	/**
	 * Bulk Status Change
	 */
	function bulkStatus( event, rc, prc ){
		event.paramValue( "contentID", "" );
		event.paramValue( "contentStatus", "draft" );

		// check if id list has length
		if ( len( rc.contentID ) ) {
			entryService.bulkPublishStatus( contentID = rc.contentID, status = rc.contentStatus );
			// announce event
			announce(
				"cbadmin_onEntryStatusUpdate",
				{ contentID : rc.contentID, status : rc.contentStatus }
			);
			// Message
			cbMessageBox.info(
				"#listLen( rc.contentID )# Entries where set to '#rc.contentStatus#'"
			);
		} else {
			cbMessageBox.warn( "No entries selected!" );
		}

		// relocate back
		relocate( event = prc.xehEntries );
	}

	/**
	 * Show the editor
	 */
	function editor( event, rc, prc ){
		// get all categories
		prc.categories = variables.categoryService.list(
			criteria : { "site" : prc.oCurrentSite },
			sortOrder: "category",
			asQuery  : false
		);
		// get new or persisted
		prc.entry = variables.entryService.get( event.getValue( "contentID", 0 ) );
		// load comments viewlet if persisted
		if ( prc.entry.isLoaded() ) {
			var args            = { contentID : rc.contentID };
			// Get Comments viewlet
			prc.commentsViewlet = runEvent(
				event          = "contentbox-admin:comments.pager",
				eventArguments = args
			);
			// Get Versions Viewlet
			prc.versionsViewlet = runEvent(
				event          = "contentbox-admin:versions.pager",
				eventArguments = args
			);
		}
		// CK Editor Helper
		prc.ckHelper = variables.CKHelper;

		// Get All registered editors so we can display them
		prc.editors       = variables.editorService.getRegisteredEditorsMap();
		// Get User's default editor
		prc.defaultEditor = getUserDefaultEditor( prc.oCurrentAuthor );
		// Check if the entry's markup matches the choosen editor
		if ( prc.entry.getMarkup() == "markdown" && prc.defaultEditor != "simplemde" ) {
			prc.defaultEditor = "simplemde";
		}

		// Get the editor driver object
		prc.oEditorDriver = variables.editorService.getEditor( prc.defaultEditor );

		// Get All registered markups so we can display them
		prc.markups       = variables.editorService.getRegisteredMarkups();
		// Get User's default markup
		prc.defaultMarkup = prc.oCurrentAuthor.getPreference(
			"markup",
			variables.editorService.getDefaultMarkup()
		);

		// get all authors
		prc.authors                       = variables.authorService.getAll( sortOrder = "lastName" );
		// get related content
		prc.relatedContent                = prc.entry.hasRelatedContent() ? prc.entry.getRelatedContent() : [];
		prc.linkedContent                 = prc.entry.hasLinkedContent() ? prc.entry.getLinkedContent() : [];
		prc.relatedContentIDs             = prc.entry.getRelatedContentIDs();
		// exit handlers
		prc.xehEntrySave                  = "#prc.cbAdminEntryPoint#.entries.save";
		prc.xehSlugify                    = "#prc.cbAdminEntryPoint#.entries.slugify";
		prc.xehAuthorEditorSave           = "#prc.cbAdminEntryPoint#.authors.changeEditor";
		prc.xehSlugCheck                  = "#prc.cbAdminEntryPoint#.content.slugUnique";
		prc.xehRelatedContentSelector     = "#prc.cbAdminEntryPoint#.content.relatedContentSelector";
		prc.xehShowRelatedContentSelector = "#prc.cbAdminEntryPoint#.content.showRelatedContentSelector";
		prc.xehBreakContentLink           = "#prc.cbAdminEntryPoint#.content.breakContentLink";

		// view
		event.setView( "entries/editor" );
	}

	/**
	 * Clone an entry
	 */
	function clone( event, rc, prc ){
		// Defaults
		event.paramValue( "site", prc.oCurrentSite.getsiteID() );

		// Validation
		if ( !event.valueExists( "title" ) OR !event.valueExists( "contentID" ) ) {
			cbMessageBox.warn( "Can't clone the unclonable, meaning no contentID or title passed." );
			relocate( event = prc.xehEntries );
			return;
		}

		// get the entry to clone
		var original = variables.entryService.get( rc.contentID );

		// Verify new Title, else do a new copy of it, but only if it's in the same site.
		if ( original.isSameSite( rc.site ) && rc.title eq original.getTitle() ) {
			rc.title = "Copy of #rc.title#";
		}

		// Build up the clone army...
		var clone = variables.entryService.new( {
			title   : rc.title,
			slug    : variables.HTMLHelper.slugify( rc.title ),
			excerpt : original.getExcerpt(),
			site    : variables.siteService.get( rc.site ),
			creator : prc.oCurrentAuthor
		} );

		// Prepare For Cloning: Relationships, author checks, and much more.
		clone.prepareForClone(
			author           = prc.oCurrentAuthor,
			original         = original,
			originalService  = entryService,
			publish          = rc.entryStatus,
			originalSlugRoot = original.getSlug(),
			newSlugRoot      = clone.getSlug()
		);

		// clone this sucker now!
		entryService.save( clone );

		// relocate
		cbMessageBox.info( "Entry cloned!" );
		relocate( event = prc.xehEntries );
	}

	/**
	 * Save an entry
	 */
	function save( event, rc, prc ){
		// params
		event
			.paramValue( "allowComments", prc.cbSiteSettings.cb_comments_enabled )
			.paramValue( "newCategories", "" )
			.paramValue( "isPublished", true )
			.paramValue( "slug", "" )
			.paramValue( "changelog", "" )
			.paramValue( "customFieldsCount", 0 )
			.paramValue( "publishedDate", now() )
			.paramValue( "publishedHour", timeFormat( rc.publishedDate, "HH" ) )
			.paramValue( "publishedMinute", timeFormat( rc.publishedDate, "mm" ) )
			.paramValue(
				"publishedTime",
				event.getValue( "publishedHour" ) & ":" & event.getValue( "publishedMinute" )
			)
			.paramValue( "expireHour", "" )
			.paramValue( "expireMinute", "" )
			.paramValue( "expireTime", "" )
			.paramValue( "content", "" )
			.paramValue( "creatorID", "" )
			.paramValue( "customFieldsCount", 0 )
			.paramValue( "relatedContentIDs", [] )
			.paramValue( "site", prc.oCurrentSite.getsiteID() );

		if ( NOT len( rc.publishedDate ) ) {
			rc.publishedDate = dateFormat( now() );
		}

		// slugify the incoming title or slug
		if ( NOT len( rc.slug ) ) {
			rc.slug = rc.title;
		}
		rc.slug = variables.HTMLHelper.slugify( rc.slug );

		// Verify permission for publishing, else save as draft
		if ( !prc.oCurrentAuthor.checkPermission( "ENTRIES_ADMIN" ) ) {
			rc.isPublished = "false";
		}

		// get new/persisted entry and populate it
		var entry        = variables.entryService.get( rc.contentID );
		var originalSlug = entry.getSlug();
		var isNew        = ( NOT entry.isLoaded() );

		// Populate the entry
		populateModel( entry )
			.addJoinedPublishedtime( rc.publishedTime )
			.addJoinedExpiredTime( rc.expireTime )
			.setSite( variables.siteService.get( rc.site ) );

		// Validate it
		var vResults = validate( entry );
		if ( vResults.hasErrors() ) {
			variables.cbMessageBox.warn( vResults.getAllErrors() );
			editor( argumentCollection = arguments );
			return;
		}

		// Attach creator if new page
		if ( isNew ) {
			entry.setCreator( prc.oCurrentAuthor );
		}

		// Override creator?
		if (
			!isNew and prc.oCurrentAuthor.checkPermission( "ENTRIES_ADMIN" ) and len( rc.creatorID ) and entry
				.getCreator()
				.getAuthorID() NEQ rc.creatorID
		) {
			entry.setCreator( authorService.get( rc.creatorID ) );
		}

		// Register a new content in the page, versionized!
		entry.addNewContentVersion(
			content   = rc.content,
			changelog = rc.changelog,
			author    = prc.oCurrentAuthor
		);

		// Create new categories?
		var categories = [];
		if ( len( trim( rc.newCategories ) ) ) {
			categories = categoryService.createCategories( trim( rc.newCategories ) );
		}
		// Inflate sent categories from collection
		categories.addAll( categoryService.inflateCategories( rc ) );
		// Add categories to page
		entry.removeAllCategories().setCategories( categories );
		// Inflate Custom Fields into the page
		entry.inflateCustomFields( rc.customFieldsCount, rc );
		// Inflate Related Content into the page
		entry.inflateRelatedContent( rc.relatedContentIDs );
		// announce event
		announce(
			"cbadmin_preEntrySave",
			{
				entry        : entry,
				isNew        : isNew,
				originalSlug : originalSlug
			}
		);
		// save entry
		entryService.save( entry );
		// announce event
		announce(
			"cbadmin_postEntrySave",
			{
				entry        : entry,
				isNew        : isNew,
				originalSlug : originalSlug
			}
		);

		// Ajax?
		if ( event.isAjax() ) {
			var rData = { "CONTENTID" : entry.getContentID() };
			event.renderData( type = "json", data = rData );
		} else {
			// relocate
			cbMessageBox.info( "Entry Saved!" );
			relocate( prc.xehEntries );
		}
	}

	/**
	 * Remove an entry
	 */
	function remove( event, rc, prc ){
		// params
		event.paramValue( "contentID", "" );

		// verify if contentID sent
		if ( !len( rc.contentID ) ) {
			cbMessageBox.warn( "No entries sent to delete!" );
			relocate( event = prc.xehEntries );
		}

		// Inflate to array
		rc.contentID = listToArray( rc.contentID );
		var messages = [];

		// Iterate and remove
		for ( var thisContentID in rc.contentID ) {
			var entry = variables.entryService.get( thisContentID );
			if ( isNull( entry ) ) {
				arrayAppend(
					messages,
					"Invalid entry contentID sent: #thisContentID#, so skipped removal"
				);
			} else {
				// GET id to be sent for announcing later
				var contentID = entry.getContentID();
				var title     = entry.getTitle();
				// announce event
				announce( "cbadmin_preEntryRemove", { entry : entry } );
				// Delete it
				entryService.delete( entry );
				arrayAppend( messages, "Entry '#title#' removed" );
				// announce event
				announce( "cbadmin_postEntryRemove", { contentID : contentID } );
			}
		}
		// messagebox
		cbMessageBox.info( messages );
		// relocate
		relocate( event = prc.xehEntries );
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
		prc.pager_oPaging    = getInstance( "Paging@cb" );
		prc.pager_paging     = prc.pager_oPaging.getBoundaries();
		prc.pager_pagingLink = "javascript:pagerLink(@page@)";
		prc.pager_pagination = arguments.pagination;

		// Sorting
		var sortOrder = "publishedDate DESC";
		if ( arguments.latest ) {
			sortOrder = "modifiedDate desc";
		}

		// search entries with filters and all
		var entryResults = variables.entryService.search(
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
	 * Slugify the incoming slug
	 */
	function slugify( event, rc, prc ){
		event.renderData( data = trim( variables.HTMLHelper.slugify( rc.slug ) ), type = "plain" );
	}

	/**
	 * Editor selector for entries UI
	 */
	function editorSelector( event, rc, prc ){
		// paging default
		event.paramValue( "page", 1 );
		event.paramValue( "search", "" );
		event.paramValue( "clear", false );

		// exit handlers
		prc.xehEditorSelector = "#prc.cbAdminEntryPoint#.entries.editorSelector";

		// prepare paging object
		prc.oPaging    = getInstance( "Paging@cb" );
		prc.paging     = prc.oPaging.getBoundaries();
		prc.pagingLink = "javascript:pagerLink(@page@)";

		// search entries with filters and all
		var entryResults = variables.entryService.search(
			search             : rc.search,
			offset             : prc.paging.startRow - 1,
			max                : prc.cbSettings.cb_paging_maxrows,
			sortOrder          : "publishedDate desc",
			searchActiveContent: false,
			siteID             : prc.oCurrentSite.getsiteID()
		);

		prc.entries      = entryResults.entries;
		prc.entriesCount = entryResults.count;
		prc.CBHelper     = variables.CBHelper;
		prc.contentType  = "Blog Entries";

		// if ajax and searching, just return tables
		if ( event.isAjax() and len( rc.search ) OR rc.clear ) {
			return renderView( view = "content/editorSelectorEntries", prePostExempt = true );
		} else {
			event.setView( view = "content/editorSelector", layout = "ajax" );
		}
	}

	/**
	 * Export an entry
	 */
	function export( event, rc, prc ){
		event.paramValue( "format", "json" );
		// get entry
		prc.entry = variables.entryService.get( event.getValue( "contentID", 0 ) );

		// relocate if not existent
		if ( !prc.entry.isLoaded() ) {
			cbMessageBox.warn( "ContentID sent is not valid" );
			relocate( "#prc.cbAdminEntryPoint#.entries" );
		}

		switch ( rc.format ) {
			case "xml":
			case "json": {
				var filename = "#prc.entry.getSlug()#." & ( rc.format eq "xml" ? "xml" : "json" );
				event
					.renderData(
						data        = prc.entry.getMemento(),
						type        = rc.format,
						xmlRootName = "entry"
					)
					.setHTTPHeader(
						name  = "Content-Disposition",
						value = " attachment; filename=#fileName#"
					);
				break;
			}
			default: {
				event.renderData( data = "Invalid export type: #rc.format#" );
			}
		}
	}

	/**
	 * Export All Entries
	 */
	function exportAll( event, rc, prc ){
		event.paramValue( "format", "json" );
		// get all prepared content objects
		var data = variables.entryService.getAllForExport();

		switch ( rc.format ) {
			case "xml":
			case "json": {
				var filename = "Entries." & ( rc.format eq "xml" ? "xml" : "json" );
				event
					.renderData(
						data        = data,
						type        = rc.format,
						xmlRootName = "entries"
					)
					.setHTTPHeader(
						name  = "Content-Disposition",
						value = " attachment; filename=#fileName#"
					);
				break;
			}
			default: {
				event.renderData( data = "Invalid export type: #rc.format#" );
			}
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
				var importLog = variables.entryService.importFromFile(
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
