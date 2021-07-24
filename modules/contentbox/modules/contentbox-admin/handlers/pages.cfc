/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage site pages
 */
component extends="baseContentHandler" {

	// Dependencies
	property name="pageService" inject="pageService@contentbox";
	property name="CKHelper" inject="CKHelper@contentbox-ckeditor";
	property name="HTMLHelper" inject="HTMLHelper@coldbox";

	// Public properties
	this.preHandler_except = "pager";

	/**
	 * pre handler
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		super.preHandler( argumentCollection = arguments );
		// exit Handlers
		prc.xehPages      = "#prc.cbAdminEntryPoint#.pages";
		prc.xehPageEditor = "#prc.cbAdminEntryPoint#.pages.editor";
		prc.xehPageRemove = "#prc.cbAdminEntryPoint#.pages.remove";
	}

	/**
	 * Index
	 */
	function index( event, rc, prc ){
		// params
		event.paramValue( "parent", "" );

		// get all authors
		prc.authors    = authorService.getAll( sortOrder = "lastName" );
		// get all categories
		prc.categories = variables.categoryService.list(
			criteria : { "site" : prc.oCurrentSite },
			sortOrder: "category",
			asQuery  : false
		);

		// exit handlers
		prc.xehPageSearch     = "#prc.cbAdminEntryPoint#.pages";
		prc.xehPageTable      = "#prc.cbAdminEntryPoint#.pages.pageTable";
		prc.xehPageBulkStatus = "#prc.cbAdminEntryPoint#.pages.bulkstatus";
		prc.xehPageExportAll  = "#prc.cbAdminEntryPoint#.pages.exportAll";
		prc.xehPageImport     = "#prc.cbAdminEntryPoint#.pages.importAll";
		prc.xehPageClone      = "#prc.cbAdminEntryPoint#.pages.clone";
		prc.xehResetHits      = "#prc.cbAdminEntryPoint#.content.resetHits";

		prc.tabContent_Pages = true;

		// view
		event.setView( "pages/index" );
	}

	/**
	 * Index page tables
	 */
	function pageTable( event, rc, prc ){
		// params
		event
			.paramValue( "page", 1 )
			.paramValue( "searchPages", "" )
			.paramValue( "fAuthors", "all" )
			.paramValue( "fStatus", "any" )
			.paramValue( "fCategories", "all" )
			.paramValue( "fCreators", "all" )
			.paramValue( "isFiltering", false, true )
			.paramValue( "parent", "" )
			.paramValue( "showAll", false );

		// JS null checks
		if ( rc.parent eq "undefined" ) {
			rc.parent = "";
		}

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

		// Doing a page search or filtering?
		if ( len( rc.searchPages ) OR prc.isFiltering ) {
			// remove parent for searches, we go site wide
			structDelete( rc, "parent" );
		}

		// search entries with filters and all
		var pageResults = variables.pageService.search(
			search     : rc.searchPages,
			isPublished: rc.fStatus,
			category   : rc.fCategories,
			author     : rc.fAuthors,
			creator    : rc.fCreators,
			parent     : ( !isNull( rc.parent ) ? rc.parent : javacast( "null", "" ) ),
			sortOrder  : "order asc",
			siteID     : prc.oCurrentSite.getsiteID()
		);
		prc.pages      = pageResults.pages;
		prc.pagesCount = pageResults.count;

		// Do we have a parent?
		if ( structKeyExists( rc, "parent" ) ) {
			prc.page = variables.pageService.get( rc.parent );
		}

		// exit handlers
		prc.xehPageSearch    = "#prc.cbAdminEntryPoint#.pages";
		prc.xehPageQuickLook = "#prc.cbAdminEntryPoint#.pages.quickLook";
		prc.xehPageOrder     = "#prc.cbAdminEntryPoint#.pages.changeOrder";
		prc.xehPageHistory   = "#prc.cbAdminEntryPoint#.versions.index";
		prc.xehPageExport    = "#prc.cbAdminEntryPoint#.pages.export";
		prc.xehPageClone     = "#prc.cbAdminEntryPoint#.pages.clone";

		// view
		event.setView( view = "pages/indexTable", layout = "ajax" );
	}

	// Quick Look
	function quickLook( event, rc, prc ){
		// get entry
		prc.content          = variables.pageService.get( event.getValue( "contentID", 0 ) );
		prc.xehContentEditor = "#prc.cbAdminEntryPoint#.pages.editor";
		event.setView( view = "content/quickLook", layout = "ajax" );
	}

	// editor
	function editor( event, rc, prc ){
		// get new page or persisted
		prc.page          = variables.pageService.get( event.getValue( "contentID", 0 ) );
		// CK Editor Helper
		prc.ckHelper      = variables.CKHelper;
		// Get All registered editors so we can display them
		prc.editors       = variables.editorService.getRegisteredEditorsMap();
		// Get User's default editor
		prc.defaultEditor = getUserDefaultEditor( prc.oCurrentAuthor );
		// Check if the markup matches the choosen editor
		if (
			listFindNoCase( "markdown,json", prc.page.getMarkup() ) && prc.defaultEditor != "simplemde"
		) {
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

		// get all categories for display purposes
		prc.categories = variables.categoryService.list(
			criteria : { "site" : prc.oCurrentSite },
			sortOrder: "category",
			asQuery  : false
		);

		// load comments,versions and child pages viewlets if persisted
		if ( prc.page.isLoaded() ) {
			var args            = { contentID : rc.contentID };
			// Get Comments viewlet
			prc.commentsViewlet = runEvent(
				event          = "contentbox-admin:comments.pager",
				eventArguments = args
			);
			// Get Child Pages Viewlet
			prc.childPagesViewlet = pager(
				event  = arguments.event,
				rc     = arguments.rc,
				prc    = arguments.prc,
				parent = prc.page.getContentID()
			);
			// Get Versions Viewlet
			prc.versionsViewlet = runEvent(
				event          = "contentbox-admin:versions.pager",
				eventArguments = args
			);
		}
		// Get all page names for parent drop downs
		prc.pages            = variables.pageService.getAllFlatPages( sortOrder = "slug asc" );
		// Get active layout record and available page only layouts
		prc.themeRecord      = variables.themeService.getActiveTheme();
		prc.availableLayouts = reReplaceNoCase( prc.themeRecord.layouts, "blog,?", "" );
		// Get parent from active page
		prc.parentcontentID  = prc.page.getParentID();
		// Override the parent page if incoming via URL
		if ( structKeyExists( rc, "parentID" ) ) {
			prc.parentcontentID = rc.parentID;
		}
		// get all authors
		prc.authors                       = variables.authorService.getAll( sortOrder = "lastName" );
		// get related content
		prc.relatedContent                = prc.page.hasRelatedContent() ? prc.page.getRelatedContent() : [];
		prc.linkedContent                 = prc.page.hasLinkedContent() ? prc.page.getLinkedContent() : [];
		prc.relatedContentIDs             = prc.page.getRelatedContentIDs();
		// exit handlers
		prc.xehPageSave                   = "#prc.cbAdminEntryPoint#.pages.save";
		prc.xehSlugify                    = "#prc.cbAdminEntryPoint#.pages.slugify";
		prc.xehAuthorEditorSave           = "#prc.cbAdminEntryPoint#.authors.changeEditor";
		prc.xehSlugCheck                  = "#prc.cbAdminEntryPoint#.content.slugUnique";
		prc.xehRelatedContentSelector     = "#prc.cbAdminEntryPoint#.content.relatedContentSelector";
		prc.xehShowRelatedContentSelector = "#prc.cbAdminEntryPoint#.content.showRelatedContentSelector";
		prc.xehBreakContentLink           = "#prc.cbAdminEntryPoint#.content.breakContentLink";

		// view
		event.setView( "pages/editor" );
	}

	/**
	 * Save a page
	 */
	function save( event, rc, prc ){
		// params
		event
			.paramValue( "allowComments", prc.cbSiteSettings.cb_comments_enabled )
			.paramValue( "newCategories", "" )
			.paramValue( "isPublished", true )
			.paramValue( "slug", "" )
			.paramValue( "creatorID", "" )
			.paramValue( "changelog", "" )
			.paramValue( "parentPage", "null" )
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
			.paramValue( "customFieldsCount", 0 )
			.paramValue( "relatedContentIDs", [] )
			.paramValue( "site", prc.oCurrentSite.getsiteID() );

		if ( NOT len( rc.publishedDate ) ) {
			rc.publishedDate = dateFormat( now() );
		}

		// slugify the incoming title or slug
		rc.slug = (
			NOT len( rc.slug ) ? variables.HTMLHelper.slugify( rc.title ) : variables.HTMLHelper.slugify(
				listLast( rc.slug, "/" )
			)
		);

		// Verify permission for publishing, else save as draft
		if ( !prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN" ) ) {
			rc.isPublished = "false";
		}

		// get new/persisted page and populate it with incoming data.
		var page         = variables.pageService.get( rc.contentID );
		var originalSlug = page.getSlug();
		populateModel( model: page, exclude = "contentID" )
			.addJoinedPublishedtime( rc.publishedTime )
			.addJoinedExpiredTime( rc.expireTime )
			.setSite( variables.siteService.get( rc.site ) );
		var isNew = ( NOT page.isLoaded() );

		// Validate Page And Incoming Data
		var vResults = validate( page );
		if ( vResults.hasErrors() ) {
			variables.cbMessageBox.warn( vResults.getAllErrors() );
			editor( argumentCollection = arguments );
			return;
		}

		// Attach creator if new page
		if ( isNew ) {
			page.setCreator( prc.oCurrentAuthor );
		}
		// Override creator?
		else if (
			!isNew and
			prc.oCurrentAuthor.checkPermission( "PAGES_ADMIN" ) and
			len( rc.creatorID ) and
			page.getCreator().getAuthorID() NEQ rc.creatorID
		) {
			page.setCreator( variables.authorService.get( rc.creatorID ) );
		}

		// Register a new content in the page, versionized!
		page.addNewContentVersion(
			content   = rc.content,
			changelog = rc.changelog,
			author    = prc.oCurrentAuthor
		);

		// Inflate parent
		if ( rc.parentPage EQ "null" OR rc.parentPage EQ "" ) {
			page.setParent( javacast( "null", "" ) );
		} else {
			page.setParent( variables.pageService.get( rc.parentPage ) );
		}

		// Create new categories?
		var categories = [];
		if ( len( trim( rc.newCategories ) ) ) {
			categories = categoryService.createCategories( trim( rc.newCategories ) );
		}
		// Inflate sent categories from collection
		categories.addAll( categoryService.inflateCategories( rc ) );
		// Add categories to page
		page.removeAllCategories().setCategories( categories );
		// Inflate Custom Fields into the page
		page.inflateCustomFields( rc.customFieldsCount, rc );
		// Inflate Related Content into the page
		page.inflateRelatedContent( rc.relatedContentIDs );
		// announce event
		announce(
			"cbadmin_prePageSave",
			{ page : page, isNew : isNew, originalSlug : originalSlug }
		);

		// save entry
		variables.pageService.save( page, originalSlug );

		// announce event
		announce(
			"cbadmin_postPageSave",
			{ page : page, isNew : isNew, originalSlug : originalSlug }
		);

		// Ajax?
		if ( event.isAjax() ) {
			var rData = { "CONTENTID" : page.getContentID() };
			event.renderData( type = "json", data = rData );
		} else {
			// relocate
			cbMessageBox.info( "Page Saved!" );
			if ( page.hasParent() ) {
				relocate(
					event       = prc.xehPages,
					querystring = "parent=#page.getParent().getContentID()#"
				);
			} else {
				relocate( event = prc.xehPages );
			}
		}
	}

	/**
	 * Clone a page
	 */
	function clone( event, rc, prc ){
		// Defaults
		event.paramValue( "site", prc.oCurrentSite.getsiteID() );

		// validation
		if ( !event.valueExists( "title" ) OR !event.valueExists( "contentID" ) ) {
			cbMessageBox.warn( "Can't clone the unclonable, meaning no contentID or title passed." );
			relocate( prc.xehPages );
			return;
		}

		// get the page to clone
		var original = variables.pageService.get( rc.contentID );

		// Verify new Title, else do a new copy of it, but only if it's in the same site.
		if ( original.isSameSite( rc.site ) && rc.title eq original.getTitle() ) {
			rc.title = "Copy of #rc.title#";
		}

		// get a clone
		var clone = variables.pageService.new( {
			title        : rc.title,
			slug         : variables.HTMLHelper.slugify( rc.title ),
			layout       : original.getLayout(),
			mobileLayout : original.getMobileLayout(),
			order        : original.getOrder() + 1,
			showInMenu   : original.getShowInMenu(),
			excerpt      : original.getExcerpt(),
			SSLOnly      : original.getSSLonly(),
			creator      : prc.oCurrentAuthor,
			site         : variables.siteService.get( rc.site )
		} );

		// attach to the original's parent.
		if ( original.hasParent() ) {
			clone
				.setParent( original.getParent() )
				.setSlug( original.getSlug() & "/" & clone.getSlug() );
		}

		// prepare descendants for cloning, might take a while if lots of children to copy.
		clone.prepareForClone(
			author           = prc.oCurrentAuthor,
			original         = original,
			originalService  = pageService,
			publish          = rc.pageStatus,
			originalSlugRoot = original.getSlug(),
			newSlugRoot      = clone.getSlug()
		);

		// clone this sucker now!
		variables.pageService.save( clone );

		// relocate
		cbMessageBox.info( "Page Cloned!" );
		if ( original.hasParent() ) {
			relocate(
				event       = prc.xehPages,
				querystring = "parent=#original.getParent().getContentID()#"
			);
		} else {
			relocate( event = prc.xehPages );
		}
	}

	// Bulk Status Change
	function bulkStatus( event, rc, prc ){
		event
			.paramValue( "parent", "" )
			.paramValue( "contentID", "" )
			.paramValue( "contentStatus", "draft" );

		// check if id list has length
		if ( len( rc.contentID ) ) {
			variables.pageService.bulkPublishStatus(
				contentID = rc.contentID,
				status    = rc.contentStatus
			);
			// announce event
			announce(
				"cbadmin_onPageStatusUpdate",
				{ contentID : rc.contentID, status : rc.contentStatus }
			);
			// Message
			cbMessageBox.info(
				"#listLen( rc.contentID )# Pages(s) where set to '#rc.contentStatus#'"
			);
		} else {
			cbMessageBox.warn( "No pages selected!" );
		}
		// relocate back
		if ( len( rc.parent ) ) {
			relocate( event = prc.xehPages, queryString = "parent=#rc.parent#" );
		} else {
			relocate( event = prc.xehPages );
		}
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
			var page = variables.pageService.get( thisContentID );
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
				variables.pageService.delete( page );
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

	/**
	 * Change order of pages
	 * @return json
	 */
	function changeOrder( event, rc, prc ){
		// param values
		event.paramValue( "tableID", "pages" ).paramValue( "newRulesOrder", "" );

		// decode + cleanup incoming rules data
		// We replace _ to - due to the js plugin issue of not liking dashes
		var aOrderedContent = urlDecode( rc.newRulesOrder )
			.replace( "_", "-", "all" )
			.listToArray( "&" )
			.map( function( thisItem ){
				return reReplaceNoCase(
					arguments.thisItem,
					"#rc.tableID#\[\]\=",
					"",
					"all"
				);
			} )
			// Inflate to the page
			.map( function( thisId, index ){
				var oPage = variables.pageService
					.get( arguments.thisId )
					.setOrder( arguments.index );
				// remove caching once ordering changes
				variables.pageService.clearPageWrapper( oPage.getSlug() );
				// Do we have a parent?
				if ( oPage.hasParent() ) {
					variables.pageService.clearPageWrapperCaches(
						slug = oPage.getParent().getSlug()
					);
				}
				return oPage;
			} );

		// save them
		if ( arrayLen( aOrderedContent ) ) {
			variables.pageService.saveAll( aOrderedContent );
		}

		// Send response with the data in the right order
		event
			.getResponse()
			.setData(
				aOrderedContent.map( function( thisItem ){
					return arguments.thisItem.getContentID();
				} )
			)
			.addMessage( "Pages ordered successfully!" );
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
		var pageResults = variables.pageService.search(
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
		var pageResults = variables.pageService.search(
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
		return variables.pageService
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
					return variables.pageService.get( arguments.id ).getMemento( profile: "export" );
				} );
		} else {
			return variables.pageService.getAllForExport( prc.oCurrentSite );
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
				var importLog = variables.pageService.importFromFile(
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
