/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manage site pages
*/
component extends="baseContentHandler"{

	// Dependencies
	property name="pageService"			inject="id:pageService@cb";
	property name="CKHelper"			inject="id:CKHelper@contentbox-ckeditor";
	property name="HTMLHelper"			inject="HTMLHelper@coldbox";

	// Public properties
	this.preHandler_except = "pager";

	/**
	 * pre handler
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		super.preHandler( argumentCollection=arguments );
		// exit Handlers
		prc.xehPages 		= "#prc.cbAdminEntryPoint#.pages";
		prc.xehPageEditor 	= "#prc.cbAdminEntryPoint#.pages.editor";
		prc.xehPageRemove 	= "#prc.cbAdminEntryPoint#.pages.remove";
	}

	/**
	* Index
	*/
	function index( event, rc, prc ){
		// params
		event.paramValue( "parent","" );

		// get all authors
		prc.authors    = authorService.getAll(sortOrder="lastName" );
		// get all categories
		prc.categories = categoryService.getAll(sortOrder="category" );

		// exit handlers
		prc.xehPageSearch 		= "#prc.cbAdminEntryPoint#.pages";
		prc.xehPageTable 		= "#prc.cbAdminEntryPoint#.pages.pageTable";
		prc.xehPageBulkStatus 	= "#prc.cbAdminEntryPoint#.pages.bulkstatus";
		prc.xehPageExportAll 	= "#prc.cbAdminEntryPoint#.pages.exportAll";
		prc.xehPageImport		= "#prc.cbAdminEntryPoint#.pages.importAll";
		prc.xehPageClone 		= "#prc.cbAdminEntryPoint#.pages.clone";
		prc.xehResetHits 		= "#prc.cbAdminEntryPoint#.content.resetHits";

		// view
		event.setView( "pages/index" );
	}

	/**
	 * Index page tables
	 */
	function pageTable( event, rc, prc ){
		// params
		event.paramValue( "page", 1 )
			.paramValue( "searchPages", "" )
			.paramValue( "fAuthors", "all" )
			.paramValue( "fStatus", "any" )
			.paramValue( "fCategories", "all" )
			.paramValue( "fCreators", "all" )
			.paramValue( "isFiltering", false,true )
			.paramValue( "parent", "" )
			.paramValue( "showAll", false );

		// JS null checks
		if( rc.parent eq "undefined" ){ rc.parent = ""; }

		// is Filtering?
		if( rc.fAuthors neq "all" OR
			rc.fStatus neq "any" OR
			rc.fCategories neq "all" OR
			rc.fCreators neq "all" OR
			rc.showAll ){
			prc.isFiltering = true;
		}

		// Doing a page search or filtering?
		if( len( rc.searchPages ) OR prc.isFiltering ){
			// remove parent for searches, we go site wide
			structDelete(rc, "parent" );
		}

		// search entries with filters and all
		var pageResults = pageService.search( 
			search		= rc.searchPages,
			isPublished	= rc.fStatus,
			category	= rc.fCategories,
			author		= rc.fAuthors,
			creator		= rc.fCreators,
			parent		= ( !isNull( rc.parent ) ? rc.parent : javaCast( "null", "" ) ),
			sortOrder	= "order asc" 
		);
		prc.pages 		= pageResults.pages;
		prc.pagesCount  = pageResults.count;

		// Do we have a parent?
		if( structKeyExists( rc, "parent" ) ){
			prc.page = pageService.get( rc.parent );
		}

		// exit handlers
		prc.xehPageSearch 		= "#prc.cbAdminEntryPoint#.pages";
		prc.xehPageQuickLook	= "#prc.cbAdminEntryPoint#.pages.quickLook";
		prc.xehPageOrder 		= "#prc.cbAdminEntryPoint#.pages.changeOrder";
		prc.xehPageHistory 		= "#prc.cbAdminEntryPoint#.versions.index";
		prc.xehPageExport 		= "#prc.cbAdminEntryPoint#.pages.export";
		prc.xehPageClone 		= "#prc.cbAdminEntryPoint#.pages.clone";
		
		// view
		event.setView( view="pages/indexTable", layout="ajax" );
	}

	// Quick Look
	function quickLook( event, rc, prc ){
		// get entry
		prc.page  = pageService.get( event.getValue( "contentID",0) );
		event.setView(view="pages/quickLook",layout="ajax" );
	}

	// editor
	function editor( event, rc, prc ){
		// cb helper reference
		prc.cbHelper = CBHelper;
		// CK Editor Helper
		prc.ckHelper = variables.CKHelper;
		// Get All registered editors so we can display them
		prc.editors = editorService.getRegisteredEditorsMap();
		// Get User's default editor
		prc.defaultEditor = getUserDefaultEditor( prc.oAuthor );
		// Get the editor driver object
		prc.oEditorDriver = editorService.getEditor( prc.defaultEditor );
		// Get All registered markups so we can display them
		prc.markups = editorService.getRegisteredMarkups();
		// Get User's default markup
		prc.defaultMarkup = prc.oAuthor.getPreference( "markup", editorService.getDefaultMarkup() );
		// get all categories for display purposes
		prc.categories = categoryService.getAll(sortOrder="category" );
		// get new page or persisted
		prc.page  = pageService.get( event.getValue( "contentID",0) );
		// load comments,versions and child pages viewlets if persisted
		if( prc.page.isLoaded() ){
			var args = {contentID=rc.contentID};
			// Get Comments viewlet
			prc.commentsViewlet = runEvent(event="contentbox-admin:comments.pager",eventArguments=args);
			// Get Child Pages Viewlet
			prc.childPagesViewlet = pager(event=arguments.event,rc=arguments.rc,prc=arguments.prc,parent=prc.page.getContentID());
			// Get Versions Viewlet
			prc.versionsViewlet = runEvent(event="contentbox-admin:versions.pager",eventArguments=args);
		}
		// Get all page names for parent drop downs
		prc.pages = pageService.getAllFlatPages( sortOrder="slug asc" );
		// Get active layout record and available page only layouts
		prc.themeRecord = themeService.getActiveTheme();
		prc.availableLayouts = REreplacenocase( prc.themeRecord.layouts,"blog,?","" );
		// Get parent from active page
		prc.parentcontentID = prc.page.getParentID();
		// Override the parent page if incoming via URL
		if( structKeyExistS(rc,"parentID" ) ){
			prc.parentcontentID = rc.parentID;
		}
		// get all authors
		prc.authors = authorService.getAll(sortOrder="lastName" );
		// get related content
		prc.relatedContent = prc.page.hasRelatedContent() ? prc.page.getRelatedContent() : [];
		prc.linkedContent = prc.page.hasLinkedContent() ? prc.page.getLinkedContent() : [];
		prc.relatedContentIDs = prc.page.getRelatedContentIDs();
		// exit handlers
		prc.xehPageSave 		= "#prc.cbAdminEntryPoint#.pages.save";
		prc.xehSlugify			= "#prc.cbAdminEntryPoint#.pages.slugify";
		prc.xehAuthorEditorSave = "#prc.cbAdminEntryPoint#.authors.changeEditor";
		prc.xehSlugCheck		= "#prc.cbAdminEntryPoint#.content.slugUnique";
		prc.xehRelatedContentSelector = "#prc.cbAdminEntryPoint#.content.relatedContentSelector";
		prc.xehShowRelatedContentSelector = "#prc.cbAdminEntryPoint#.content.showRelatedContentSelector";
		prc.xehBreakContentLink = "#prc.cbAdminEntryPoint#.content.breakContentLink";

		// view
		event.setView( "pages/editor" );
	}

	// save
	function save( event, rc, prc ){
		// params
		event.paramValue( "allowComments", prc.cbSettings.cb_comments_enabled );
		event.paramValue( "newCategories", "" );
		event.paramValue( "isPublished", true );
		event.paramValue( "slug", "" );
		event.paramValue( "creatorID", "" );
		event.paramValue( "changelog", "" );
		event.paramValue( "publishedDate", now() );
		event.paramValue( "publishedHour", timeFormat(rc.publishedDate,"HH" ) );
		event.paramValue( "publishedMinute", timeFormat(rc.publishedDate,"mm" ) );
		event.paramValue( "publishedTime", event.getValue( "publishedHour" ) & ":" & event.getValue( "publishedMinute" ) );
		event.paramValue( "expireHour", "" );
		event.paramValue( "expireMinute", "" );
		event.paramValue( "expireTime", "" );
		event.paramValue( "customFieldsCount", 0 );
		event.paramValue( "relatedContentIDs", [] );

		if( NOT len( rc.publishedDate ) ){
			rc.publishedDate = dateFormat( now() );
		}
		
		// slugify the incoming title or slug
		rc.slug = ( NOT len( rc.slug ) ? rc.title : variables.HTMLHelper.slugify( ListLast(rc.slug,"/") ) );

		// Verify permission for publishing, else save as draft
		if( !prc.oAuthor.checkPermission( "PAGES_ADMIN" ) ){
			rc.isPublished 	= "false";
		}

		// get new/persisted page and populate it with incoming data.
		var page 			= pageService.get( rc.contentID );
		var originalSlug 	= page.getSlug();
		populateModel( page )
			.addJoinedPublishedtime( rc.publishedTime )
			.addJoinedExpiredTime( rc.expireTime );
		var isNew = ( NOT page.isLoaded() );

		// Validate Page And Incoming Data
		var errors = page.validate();
		if( !len( trim( rc.content ) ) ){
			arrayAppend(errors, "Please enter the content to save!" );
		}
		if( arrayLen( errors ) ){
			cbMessageBox.warn(messageArray=errors);
			editor(argumentCollection=arguments);
			return;
		}

		// Attach creator if new page
		if( isNew ){ page.setCreator( prc.oAuthor ); }
		// Override creator?
		else if( !isNew and prc.oAuthor.checkPermission( "PAGES_ADMIN" ) and len( rc.creatorID ) and page.getCreator().getAuthorID() NEQ rc.creatorID ){
			page.setCreator( authorService.get( rc.creatorID ) );
		}
		// Register a new content in the page, versionized!
		page.addNewContentVersion(content=rc.content, changelog=rc.changelog, author=prc.oAuthor);

		// attach a parent page if it exists and not the same
		if( isNumeric(rc.parentPage) AND page.getContentID() NEQ rc.parentPage ){
			page.setParent( pageService.get( rc.parentPage ) );
			// update slug
			page.setSlug( page.getParent().getSlug() & "/" & page.getSlug() );
		}
		// Remove parent
		else if( rc.parentPage EQ "null" OR rc.parentPage EQ ""){
			page.setParent( javaCast( "null", "" ) );
		}

		// Create new categories?
		var categories = [];
		if( len(trim(rc.newCategories)) ){
			categories = categoryService.createCategories( trim(rc.newCategories) );
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
		announceInterception( "cbadmin_prePageSave", {
			page=page,
			isNew=isNew,
			originalSlug=originalSlug
		} );

		// save entry
		pageService.savePage( page, originalSlug );

		// announce event
		announceInterception( "cbadmin_postPageSave", {
			page=page,
			isNew=isNew,
			originalSlug=originalSlug
		} );

		// Ajax?
		if( event.isAjax() ){
			var rData = {
				"CONTENTID" = page.getContentID()
			};
			event.renderData(type="json",data=rData);
		}
		else{
			// relocate
			cbMessageBox.info( "Page Saved!" );
			if( page.hasParent() ){
				setNextEvent( event=prc.xehPages, querystring="parent=#page.getParent().getContentID()#" );
			} else {
				setNextEvent( event=prc.xehPages );
			}
		}
	}

	function clone( event, rc, prc ){
		// validation
		if( !event.valueExists( "title" ) OR !event.valueExists( "contentID" ) ){
			cbMessageBox.warn( "Can't clone the unclonable, meaning no contentID or title passed." );
			setNextEvent(event=prc.xehPages);
			return;
		}
		// decode the incoming title
		rc.title = urldecode( rc.title );
		// get the page to clone
		var original = pageService.get( rc.contentID );
		// Verify new Title, else do a new copy of it
		if( rc.title eq original.getTitle() ){
			rc.title = "Copy of #rc.title#";
		}
		// get a clone
		var clone = pageService.new( {title=rc.title,slug=variables.HTMLHelper.slugify( rc.title )} );
		clone.setCreator( prc.oAuthor );
		// attach to the original's parent.
		if( original.hasParent() ){
			clone.setParent( original.getParent() );
			clone.setSlug( original.getSlug() & "/" & clone.getSlug() );
		}
		// prepare descendants for cloning, might take a while if lots of children to copy.
		clone.prepareForClone(author=prc.oAuthor,
							  original=original,
							  originalService=pageService,
							  publish=rc.pageStatus,
							  originalSlugRoot=original.getSlug(),
							  newSlugRoot=clone.getSlug());
		// clone this sucker now!
		pageService.savePage( clone );
		// relocate
		cbMessageBox.info( "Page Cloned, isn't that cool!" );
		if( clone.hasParent() ){
			setNextEvent( event=prc.xehPages, querystring="parent=#clone.getParent().getContentID()#" );
		} else {
			setNextEvent( event=prc.xehPages );
		}
	}

	// Bulk Status Change
	function bulkStatus( event, rc, prc ){
		event.paramValue( "parent","" )
			.paramValue( "contentID","" )
			.paramValue( "contentStatus","draft" );

		// check if id list has length
		if( len( rc.contentID ) ){
			pageService.bulkPublishStatus( contentID=rc.contentID,status=rc.contentStatus );
			// announce event
			announceInterception( "cbadmin_onPageStatusUpdate", {contentID=rc.contentID,status=rc.contentStatus} );
			// Message
			cbMessageBox.info( "#listLen(rc.contentID)# Pages(s) where set to '#rc.contentStatus#'" );
		}
		else{
			cbMessageBox.warn( "No pages selected!" );
		}
		// relocate back
		if( len( rc.parent ) ){
			setNextEvent( event=prc.xehPages, queryString="parent=#rc.parent#" );
		} else {
			setNextEvent( event=prc.xehPages );
		}
	}

	/**
	* Remove a page
	*/
	function remove( event, rc, prc ){
		// params
		event.paramValue( "contentID", "" )
			.paramValue( "parent", "" );

		// verify if contentID sent
		if( !len( rc.contentID ) ){
			cbMessageBox.warn( "No pages sent to delete!" );
			setNextEvent( event=prc.xehPages, queryString="parent=#rc.parent#" );
		}

		// Inflate to array
		rc.contentID = listToArray( rc.contentID );
		var messages = [];

		// Iterate and remove pages
		for( var thisContentID in rc.contentID ){
			var page = pageService.get( thisContentID );
			if( isNull( page ) ){
				arrayAppend( messages, "Invalid page contentID sent: #thisContentID#, so skipped removal" );
			} else {
				// GET id to be sent for announcing later
				var contentID 	= page.getContentID();
				var title		= page.getTitle();
				// announce event
				announceInterception( "cbadmin_prePageRemove", { page = page } );
				// Diassociate it, bi-directional relationship
				if( page.hasParent() ){
					page.getParent().removeChild( page );
				}
				// Send for deletion
				pageService.deleteContent( page );
				arrayAppend( messages, "Page '#title#' removed" );
				// announce event
				announceInterception( "cbadmin_postPageRemove", { contentID = contentID } );
			}
		}
		// messagebox
		cbMessageBox.info( messageArray=messages );
		// relocate
		setNextEvent( event=prc.xehPages, queryString="parent=#rc.parent#" );
	}

	/**
	 * Change order of pages
	 * @return json
	 */
	function changeOrder( event, rc, prc ){
		// param values
		event.paramValue( "tableID", "pages" )
			.paramValue( "newRulesOrder", "" );

		// decode + cleanup incoming rules data
		rc.newRulesOrder = URLDecode( rc.newRulesOrder );
		rc.newRulesOrder = listToArray( REReplaceNoCase( rc.newRulesOrder, "&?#rc.tableID#\[\]\=", ",", "all" ) );

		// iterate and perform ordering
		var index 	= 1;
		var aPages 	= [];
		for( var thisPageID in rc.newRulesOrder ){
			var oPage = pageService.get( thisPageID );
			if( !isNull( oPage ) ){
				arrayAppend( aPages, oPage );
				// Update order
				oPage.setOrder( index++ );
				// remove caching
				pageService.clearPageWrapper( oPage.getSlug() );
				// Do we have a parent?
				if( oPage.hasParent() ){
					pageService.clearPageWrapperCaches( slug=oPage.getParent().getSlug() );
				}
			}
		}

		// save them
		if( arrayLen( aPages ) ){
			pageService.saveAll( aPages );
		}

		// render data back
		event.renderData( type="json", data='true' );
	}

	// pager viewlet
	function pager( event, rc, prc ,authorID="all",parent,max=0,pagination=true,latest=false,sorting=true){

		// check if authorID exists in rc to do an override, maybe it's the paging call
		if( event.valueExists( "pager_authorID" ) ){
			arguments.authorID = rc.pager_authorID;
		}
		// check if parent exists in rc to do an override, maybe it's the paging call
		if( event.valueExists( "pager_parentID" ) ){
			arguments.parent = rc.pager_parentID;
		}
		// check if pagination exists in rc to do an override, maybe it's the paging call
		if( event.valueExists( "pagePager_pagination" ) ){
			arguments.pagination = rc.pagePager_pagination;
		}
		// Check for sorting
		if( event.valueExists( "pagePager_sorting" ) ){
			arguments.sorting = rc.pagePager_sorting;
		}

		// Max rows incoming or take default for pagination.
		if( arguments.max eq 0 ){ arguments.max = prc.cbSettings.cb_paging_maxrows; }

		// paging default
		event.paramValue( "page",1);

		// exit handlers
		prc.xehPagePager 		= "#prc.cbAdminEntryPoint#.pages.pager";
		prc.xehPageEditor		= "#prc.cbAdminEntryPoint#.pages.editor";
		prc.xehPageQuickLook	= "#prc.cbAdminEntryPoint#.pages.quickLook";
		prc.xehPageOrder		= "#prc.cbAdminEntryPoint#.pages.changeOrder";
		prc.xehPageHistory		= "#prc.cbAdminEntryPoint#.versions.index";

		// prepare paging object
		prc.pagePager_oPaging 	= getModel( "Paging@cb" );
		prc.pagePager_paging 	  	= prc.pagePager_oPaging.getBoundaries();
		prc.pagePager_pagingLink 	= "javascript:pagerLink(@page@)";
		prc.pagePager_pagination	= arguments.pagination;

		// Sorting
		var sortOrder = "title asc";
		if( arguments.latest ){ sortOrder = "modifiedDate desc"; }

		// search entries with filters and all
		var pageResults = pageService.search( author=arguments.authorID,
											  parent=( structKeyExists( arguments, "parent" ) ? arguments.parent : javaCast( "null", "" ) ),
											  offset=prc.pagePager_paging.startRow-1,
											  max=arguments.max,
											  sortOrder=sortOrder );

		prc.pager_pages 	  = pageResults.pages;
		prc.pager_pagesCount  = pageResults.count;

		// author info
		prc.pagePager_authorID	= arguments.authorID;
		// Sorting
		prc.pagePager_sorting = arguments.sorting;
		// parent
		event.paramValue( "pagePager_parentID", "", true );
		if( structKeyExists( arguments, "parent" ) ){
			prc.pagePager_parentID = arguments.parent;
		}
		// view pager
		return renderView( view="pages/pager", module="contentbox-admin" );
	}

	// slugify remotely
	function slugify( event, rc, prc ){
		event.renderData( data=trim( variables.HTMLHelper.slugify( rc.slug ) ), type="plain" );
	}

	// editor selector
	function editorSelector( event, rc, prc ){
		// paging default
		event.paramValue( "page",1);
		event.paramValue( "search", "" );
		event.paramValue( "clear", false);

		// exit handlers
		prc.xehEditorSelector	= "#prc.cbAdminEntryPoint#.pages.editorSelector";

		// prepare paging object
		prc.oPaging 	= getModel( "Paging@cb" );
		prc.paging 	  		= prc.oPaging.getBoundaries();
		prc.pagingLink 		= "javascript:pagerLink(@page@)";

		// search entries with filters and all
		var pageResults = pageService.search(search=rc.search,
											 offset=prc.paging.startRow-1,
											 max=prc.cbSettings.cb_paging_maxrows,
											 sortOrder="slug asc",
											 searchActiveContent=false);
		// setup data for display
		prc.pages 	  	= pageResults.pages;
		prc.pagesCount  = pageResults.count;
		prc.CBHelper 	= CBHelper;

		// if ajax and searching, just return tables
		if( event.isAjax() and len( rc.search ) OR rc.clear ){
			return renderView(view="pages/editorSelectorPages", module="contentbox-admin" );
		}
		else{
			event.setView(view="pages/editorSelector",layout="ajax" );
		}
	}

	/**
	* Export a page hierarchy
	*/
	function export( event, rc, prc ){
		event.paramValue( "format", "json" );
		// get page
		prc.page = pageService.get( event.getValue( "contentID", 0 ) );

		// relocate if not existent
		if( !prc.page.isLoaded() ){
			cbMessageBox.warn( "ContentID sent is not valid" );
			setNextEvent( "#prc.cbAdminEntryPoint#.pages" );
		}
		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "#prc.page.getSlug()#." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData( data=prc.page.getMemento(), type=rc.format, xmlRootName="page" )
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#" );
				break;
			}
			default:{
				event.renderData( data="Invalid export type: #rc.format#" );
			}
		}
	}

	// Export All Pages
	function exportAll( event, rc, prc ){
		event.paramValue( "format", "json" );
		// get all prepared content objects
		var data  = pageService.getAllForExport();
		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "Pages." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=data, type=rc.format, xmlRootName="pages" )
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#" );
				break;
			}
			default:{
				event.renderData(data="Invalid export type: #rc.format#" );
			}
		}
	}

	// import settings
	function importAll( event, rc, prc ){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try{
			if( len( rc.importFile ) and fileExists( rc.importFile ) ){
				var importLog = pageService.importFromFile( importFile=rc.importFile, override=rc.overrideContent );
				cbMessageBox.info( "Pages imported sucessfully!" );
				flash.put( "importLog", importLog );
			}
			else{
				cbMessageBox.error( "The import file is invalid: #rc.importFile# cannot continue with import" );
			}
		}
		catch(any e){
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			cbMessageBox.error( errorMessage );
		}
		setNextEvent( prc.xehPages );
	}

}
