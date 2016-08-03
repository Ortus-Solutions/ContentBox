/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manage blog entries
*/
component extends="baseContentHandler"{

	// Dependencies
	property name="entryService"		inject="id:entryService@cb";
	property name="CKHelper"			inject="CKHelper@contentbox-ckeditor";
	property name="HTMLHelper"			inject="HTMLHelper@coldbox";

	// Public properties
	this.preHandler_except = "pager";

	// pre handler
	function preHandler( event, action, eventArguments, rc, prc ){
		super.preHandler( argumentCollection=arguments );

		// exit Handlers
		prc.xehEntries 		= "#prc.cbAdminEntryPoint#.entries";
		prc.xehEntryEditor 	= "#prc.cbAdminEntryPoint#.entries.editor";
		prc.xehEntryRemove 	= "#prc.cbAdminEntryPoint#.entries.remove";

		// Verify if disabled?
		if( prc.cbSettings.cb_site_disable_blog ){
			cbMessageBox.warn( "The blog has been currently disabled. You can activate it again in your ContentBox settings panel" );
			setNextEvent(prc.xehDashboard);
		}
	}

	// index
	function index( event, rc, prc ){
		// get all authors
		prc.authors    = authorService.getAll(sortOrder="lastName" );
		// get all categories
		prc.categories = categoryService.getAll(sortOrder="category" );

		// exit handlers
		prc.xehEntrySearch 	 	= "#prc.cbAdminEntryPoint#.entries";
		prc.xehEntryTable 	 	= "#prc.cbAdminEntryPoint#.entries.entriesTable";
		prc.xehEntryBulkStatus 	= "#prc.cbAdminEntryPoint#.entries.bulkstatus";
		prc.xehEntryExportAll 	= "#prc.cbAdminEntryPoint#.entries.exportAll";
		prc.xehEntryImport		= "#prc.cbAdminEntryPoint#.entries.importAll";
		prc.xehEntryClone 		= "#prc.cbAdminEntryPoint#.entries.clone";
		prc.xehResetHits 		= "#prc.cbAdminEntryPoint#.content.resetHits";

		// view
		event.setView( "entries/index" );
	}

	// entriesTable
	function entriesTable( event, rc, prc ){
		// params
		event.paramValue( "page",1 )
			.paramValue( "searchEntries","" )
			.paramValue( "fAuthors","all" )
			.paramValue( "fCreators","all" )
			.paramValue( "fCategories","all" )
			.paramValue( "fStatus","any" )
			.paramValue( "isFiltering", false, true )
			.paramValue( "showAll", false );

		// prepare paging object
		prc.oPaging 	= getModel( "Paging@cb" );
		prc.paging 			= prc.oPaging.getBoundaries();
		prc.pagingLink 		= "javascript:contentPaginate(@page@)";

		// is Filtering?
		if( rc.fAuthors neq "all" OR
			rc.fStatus neq "any" OR
			rc.fCategories neq "all" OR
			rc.fCreators neq "all" OR
			rc.showAll ){
			prc.isFiltering = true;
		}

		// search entries with filters and all
		var entryResults = entryService.search(	search=rc.searchEntries,
											   	isPublished=rc.fStatus,
											   	category=rc.fCategories,
											   	author=rc.fAuthors,
											   	creator=rc.fCreators,
											   	offset=( rc.showAll ? 0 : prc.paging.startRow-1 ),
											   	max=( rc.showAll ? 0 : prc.cbSettings.cb_paging_maxrows ),
											   	sortOrder="createdDate desc" );
		prc.entries 	 = entryResults.entries;
		prc.entriesCount = entryResults.count;

		// exit handlers
		prc.xehEntrySearch 	 	= "#prc.cbAdminEntryPoint#.entries";
		prc.xehEntryQuickLook	= "#prc.cbAdminEntryPoint#.entries.quickLook";
		prc.xehEntryHistory  	= "#prc.cbAdminEntryPoint#.versions.index";
		prc.xehEntryExport 		= "#prc.cbAdminEntryPoint#.entries.export";
		prc.xehEntryClone 		= "#prc.cbAdminEntryPoint#.entries.clone";

		// view
		event.setView( view="entries/indexTable", layout="ajax" );
	}

	// Quick Look
	function quickLook( event, rc, prc ){
		// get entry
		prc.entry  = entryService.get( event.getValue( "contentID",0) );
		event.setView( view="entries/quickLook", layout="ajax" );
	}

	// Bulk Status Change
	function bulkStatus( event, rc, prc ){
		event.paramValue( "contentID","" );
		event.paramValue( "contentStatus","draft" );

		// check if id list has length
		if( len( rc.contentID ) ){
			entryService.bulkPublishStatus(contentID=rc.contentID,status=rc.contentStatus);
			// announce event
			announceInterception( "cbadmin_onEntryStatusUpdate",{contentID=rc.contentID,status=rc.contentStatus} );
			// Message
			cbMessageBox.info( "#listLen(rc.contentID)# Entries where set to '#rc.contentStatus#'" );
		}
		else{
			cbMessageBox.warn( "No entries selected!" );
		}

		// relocate back
		setNextEvent(event=prc.xehEntries);
	}

	// editor
	function editor( event, rc, prc ){
		// cb helper
		prc.cbHelper = CBHelper;
		// get all categories
		prc.categories = categoryService.getAll(sortOrder="category" );
		// get new or persisted
		prc.entry  = entryService.get( event.getValue( "contentID",0) );
		// load comments viewlet if persisted
		if( prc.entry.isLoaded() ){
			var args = {contentID=rc.contentID};
			// Get Comments viewlet
			prc.commentsViewlet = runEvent(event="contentbox-admin:comments.pager",eventArguments=args);
			// Get Versions Viewlet
			prc.versionsViewlet = runEvent(event="contentbox-admin:versions.pager",eventArguments=args);
		}
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

		// get all authors
		prc.authors = authorService.getAll(sortOrder="lastName" );
		// get related content
		prc.relatedContent = prc.entry.hasRelatedContent() ? prc.entry.getRelatedContent() : [];
		prc.linkedContent = prc.entry.hasLinkedContent() ? prc.entry.getLinkedContent() : [];
		prc.relatedContentIDs = prc.entry.getRelatedContentIDs();
		// exit handlers
		prc.xehEntrySave 		= "#prc.cbAdminEntryPoint#.entries.save";
		prc.xehSlugify			= "#prc.cbAdminEntryPoint#.entries.slugify";
		prc.xehAuthorEditorSave = "#prc.cbAdminEntryPoint#.authors.changeEditor";
		prc.xehSlugCheck		= "#prc.cbAdminEntryPoint#.content.slugUnique";
		prc.xehRelatedContentSelector = "#prc.cbAdminEntryPoint#.content.relatedContentSelector";
		prc.xehShowRelatedContentSelector = "#prc.cbAdminEntryPoint#.content.showRelatedContentSelector";
		prc.xehBreakContentLink = "#prc.cbAdminEntryPoint#.content.breakContentLink";

		// view
		event.setView( "entries/editor" );
	}

	// clone
	function clone( event, rc, prc ){
		// validation
		if( !event.valueExists( "title" ) OR !event.valueExists( "contentID" ) ){
			cbMessageBox.warn( "Can't clone the unclonable, meaning no contentID or title passed." );
			setNextEvent(event=prc.xehPages);
			return;
		}
		// decode the incoming title
		rc.title = urldecode( rc.title );
		// get the entry to clone
		var original = entryService.get( rc.contentID );
		// Verify new Title, else do a new copy of it
		if( rc.title eq original.getTitle() ){
			rc.title = "Copy of #rc.title#";
		}
		// get a clone
		var clone = entryService.new( { title=rc.title, slug=variables.HTMLHelper.slugify( rc.title ) } );
		clone.setCreator( prc.oAuthor );
		// prepare for clone
		clone.prepareForClone(author=prc.oAuthor,
							  original=original,
							  originalService=entryService,
							  publish=rc.entryStatus,
							  originalSlugRoot=original.getSlug(),
							  newSlugRoot=clone.getSlug());
		// clone this sucker now!
		entryService.saveEntry( clone );
		// relocate
		cbMessageBox.info( "Entry Cloned, isn't that cool!" );
		setNextEvent(event=prc.xehEntries);
	}

	// save
	function save( event, rc, prc ){
		// params
		event.paramValue( "allowComments", prc.cbSettings.cb_comments_enabled );
		event.paramValue( "newCategories", "" );
		event.paramValue( "isPublished", true );
		event.paramValue( "slug", "" );
		event.paramValue( "changelog", "" );
		event.paramValue( "customFieldsCount", 0 );
		event.paramValue( "publishedDate", now() );
		event.paramValue( "publishedHour", timeFormat(rc.publishedDate,"HH" ) );
		event.paramValue( "publishedMinute", timeFormat(rc.publishedDate,"mm" ) );
		event.paramValue( "publishedTime", event.getValue( "publishedHour" ) & ":" & event.getValue( "publishedMinute" ) );
		event.paramValue( "expireHour", "" );
		event.paramValue( "expireMinute", "" );
		event.paramValue( "expireTime", "" );
		event.paramValue( "content", "" );
		event.paramValue( "creatorID", "" );
		event.paramValue( "customFieldsCount", 0 );
		event.paramValue( "relatedContentIDs", [] );

		if( NOT len( rc.publishedDate ) ){
			rc.publishedDate = dateFormat( now() );
		}

		// Quick content check
		if( structKeyExists(rc,"quickcontent" ) ){
			rc.content = rc.quickcontent;
		}

		// slugify the incoming title or slug
		if( NOT len(rc.slug) ){ rc.slug = rc.title; }
		rc.slug = variables.HTMLHelper.slugify( rc.slug );

		// Verify permission for publishing, else save as draft
		if( !prc.oAuthor.checkPermission( "ENTRIES_ADMIN" ) ){
			rc.isPublished = "false";
		}

		// get new/persisted entry and populate it
		var entry 			= entryService.get( rc.contentID );
		var originalSlug 	= entry.getSlug();
		populateModel( entry )
			.addJoinedPublishedtime( rc.publishedTime )
			.addJoinedExpiredTime( rc.expireTime );
		var isNew = ( NOT entry.isLoaded() );

		// Validate it
		var errors = entry.validate();
		if( !len(trim(rc.content)) ){
			arrayAppend(errors, "Please enter the content to save!" );
		}
		if( arrayLen(errors) ){
			cbMessageBox.warn(messageArray=errors);
			editor(argumentCollection=arguments);
			return;
		}

		// Attach creator if new page
		if( isNew ){ entry.setCreator( prc.oAuthor ); }

		// Override creator?
		if( !isNew and prc.oAuthor.checkPermission( "ENTRIES_ADMIN" ) and len( rc.creatorID ) and entry.getCreator().getAuthorID() NEQ rc.creatorID ){
			entry.setCreator( authorService.get( rc.creatorID ) );
		}

		// Register a new content in the page, versionized!
		entry.addNewContentVersion(content=rc.content, changelog=rc.changelog, author=prc.oAuthor);

		// Create new categories?
		var categories = [];
		if( len(trim(rc.newCategories)) ){
			categories = categoryService.createCategories( trim(rc.newCategories) );
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
		announceInterception( "cbadmin_preEntrySave", {
			entry=entry,
			isNew=isNew,
			originalSlug=originalSlug
		} );
		// save entry
		entryService.saveEntry( entry );
		// announce event
		announceInterception( "cbadmin_postEntrySave", {
			entry=entry,
			isNew=isNew,
			originalSlug=originalSlug
		} );

		// Ajax?
		if( event.isAjax() ){
			var rData = {
				"CONTENTID" = entry.getContentID()
			};
			event.renderData(type="json",data=rData);
		}
		else{
			// relocate
			cbMessageBox.info( "Entry Saved!" );
			setNextEvent(prc.xehEntries);
		}
	}

	// remove
	function remove( event, rc, prc ){
		// params
		event.paramValue( "contentID", "" );

		// verify if contentID sent
		if( !len( rc.contentID ) ){
			cbMessageBox.warn( "No entries sent to delete!" );
			setNextEvent(event=prc.xehEntries);
		}

		// Inflate to array
		rc.contentID = listToArray( rc.contentID );
		var messages = [];

		// Iterate and remove
		for( var thisContentID in rc.contentID ){
			var entry = entryService.get( thisContentID );
			if( isNull( entry ) ){
				arrayAppend( messages, "Invalid entry contentID sent: #thisContentID#, so skipped removal" );
			}
			else{
				// GET id to be sent for announcing later
				var contentID 	= entry.getContentID();
				var title		= entry.getTitle();
				// announce event
				announceInterception( "cbadmin_preEntryRemove", { entry=entry } );
				// Delete it
				entryService.deleteContent( entry );
				arrayAppend( messages, "Entry '#title#' removed" );
				// announce event
				announceInterception( "cbadmin_postEntryRemove", { contentID=contentID } );
			}
		}
		// messagebox
		cbMessageBox.info(messageArray=messages);
		// relocate
		setNextEvent(event=prc.xehEntries);
	}

	// pager viewlet
	function pager( event, rc, prc ,authorID="all",max=0,pagination=true,latest=false){

		// check if authorID exists in rc to do an override, maybe it's the paging call
		if( event.valueExists( "pager_authorID" ) ){
			arguments.authorID = rc.pager_authorID;
		}
		// Max rows incoming or take default for pagination.
		if( arguments.max eq 0 ){ arguments.max = prc.cbSettings.cb_paging_maxrows; }

		// paging default
		event.paramValue( "page",1);

		// exit handlers
		prc.xehPager 		= "#prc.cbAdminEntryPoint#.entries.pager";
		prc.xehEntryEditor	= "#prc.cbAdminEntryPoint#.entries.editor";
		prc.xehEntryQuickLook= "#prc.cbAdminEntryPoint#.entries.quickLook";
		prc.xehEntryHistory = "#prc.cbAdminEntryPoint#.versions.index";

		// prepare paging object
		prc.pager_oPaging 	= getModel( "Paging@cb" );
		prc.pager_paging 	  	= prc.pager_oPaging.getBoundaries();
		prc.pager_pagingLink 	= "javascript:pagerLink(@page@)";
		prc.pager_pagination	= arguments.pagination;

		// Sorting
		var sortOrder = "publishedDate DESC";
		if( arguments.latest ){ sortOrder = "modifiedDate desc"; }

		// search entries with filters and all
		var entryResults = entryService.search(author=arguments.authorID,
											   offset=prc.pager_paging.startRow-1,
											   max=arguments.max,
											   sortOrder=sortOrder);
		prc.pager_entries 	    = entryResults.entries;
		prc.pager_entriesCount  = entryResults.count;

		// author in RC
		prc.pager_authorID		= arguments.authorID;

		// view pager
		return renderView(view="entries/pager",module="contentbox-admin" );
	}

	// slugify remotely
	function slugify( event, rc, prc ){
		event.renderData(data=trim( variables.HTMLHelper.slugify( rc.slug ) ),type="plain" );
	}

	// editor selector
	function editorSelector( event, rc, prc ){
		// paging default
		event.paramValue( "page",1);
		event.paramValue( "search", "" );
		event.paramValue( "clear", false);

		// exit handlers
		prc.xehEditorSelector	= "#prc.cbAdminEntryPoint#.entries.editorSelector";

		// prepare paging object
		prc.oPaging 	= getModel( "Paging@cb" );
		prc.paging 	  		= prc.oPaging.getBoundaries();
		prc.pagingLink 		= "javascript:pagerLink(@page@)";

		// search entries with filters and all
		var entryResults = entryService.search(search=rc.search,
											   offset=prc.paging.startRow-1,
											   max=prc.cbSettings.cb_paging_maxrows,
											   sortOrder="publishedDate desc",
											   searchActiveContent=false);

		prc.entries 		= entryResults.entries;
		prc.entriesCount  	= entryResults.count;
		prc.CBHelper 		= CBHelper;

		// if ajax and searching, just return tables
		if( event.isAjax() and len( rc.search ) OR rc.clear ){
			return renderView(view="entries/editorSelectorEntries", module="contentbox-admin" );
		}
		else{
			event.setView(view="entries/editorSelector",layout="ajax" );
		}
	}

	// Export Entry
	function export( event, rc, prc ){
		event.paramValue( "format", "json" );
		// get entry
		prc.entry  = entryService.get( event.getValue( "contentID",0) );

		// relocate if not existent
		if( !prc.entry.isLoaded() ){
			cbMessageBox.warn( "ContentID sent is not valid" );
			setNextEvent( "#prc.cbAdminEntryPoint#.entries" );
		}

		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "#prc.entry.getSlug()#." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=prc.entry.getMemento(), type=rc.format, xmlRootName="entry" )
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#" );
				break;
			}
			default:{
				event.renderData(data="Invalid export type: #rc.format#" );
			}
		}
	}

	// Export All Entries
	function exportAll( event, rc, prc ){
		event.paramValue( "format", "json" );
		// get all prepared content objects
		var data  = entryService.getAllForExport();

		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "Entries." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=data, type=rc.format, xmlRootName="entries" )
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#" );
				break;
			}
			default:{
				event.renderData(data="Invalid export type: #rc.format#" );
			}
		}
	}

	// import entries
	function importAll( event, rc, prc ){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try{
			if( len( rc.importFile ) and fileExists( rc.importFile ) ){
				var importLog = entryService.importFromFile( importFile=rc.importFile, override=rc.overrideContent );
				cbMessageBox.info( "Entries imported sucessfully!" );
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
		setNextEvent( prc.xehEntries );
	}

}
