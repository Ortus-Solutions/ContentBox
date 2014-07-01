/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
* Manage content store
*/
component extends="baseHandler"{

	// Dependencies
	property name="categoryService"		inject="id:categoryService@cb";
	property name="contentStoreService"	inject="id:contentStoreService@cb";
	property name="authorService"		inject="id:authorService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";
	property name="editorService"		inject="id:editorService@cb";

	// Public properties
	this.preHandler_except = "pager";

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// exit Handlers
		prc.xehContentEditor 	= "#prc.cbAdminEntryPoint#.contentStore.editor";
		prc.xehContentRemove 	= "#prc.cbAdminEntryPoint#.contentStore.remove";
		// Tab control
		prc.tabContent = true;
	}

	// index
	function index( event, rc, prc ){
		// get all authors
		prc.authors    = authorService.getAll(sortOrder="lastName");
		// get all categories
		prc.categories = categoryService.getAll(sortOrder="category");

		// exit handlers
		prc.xehContentSearch 	 	= "#prc.cbAdminEntryPoint#.contentStore";
		prc.xehContentTable 	 	= "#prc.cbAdminEntryPoint#.contentStore.contentTable";
		prc.xehContentBulkStatus 	= "#prc.cbAdminEntryPoint#.contentStore.bulkstatus";
		prc.xehContentExportAll 	= "#prc.cbAdminEntryPoint#.contentStore.exportAll";
		prc.xehContentImport		= "#prc.cbAdminEntryPoint#.contentStore.importAll";
		prc.xehContentClone 		= "#prc.cbAdminEntryPoint#.contentStore.clone";
		
		// Tab
		prc.tabContent_contentStore = true;
		// view
		event.setView("contentStore/index");
	}
	
	// contentTable
	function contentTable( event, rc, prc ){
		// params
		event.paramValue( "page", 1 )
			.paramValue( "searchContent", "" )
			.paramValue( "fAuthors", "all" )
			.paramValue( "fCategories", "all" )
			.paramValue( "fStatus", "any" )
			.paramValue( "isFiltering", false, true )
			.paramValue( "showAll", false );

		// prepare paging plugin
		prc.pagingPlugin 	= getMyPlugin( plugin="Paging", module="contentbox" );
		prc.paging 			= prc.pagingPlugin.getBoundaries();
		prc.pagingLink 		= "javascript:contentPaginate(@page@)";
		
		// is Filtering?
		if( rc.fAuthors neq "all" OR 
			rc.fStatus neq "any" OR 
			rc.fCategories neq "all" OR 
			rc.fCreators neq "all" OR
			rc.showAll ){ 
			prc.isFiltering = true;
		}
		
		// search content with filters and all
		var contentResults = contentStoreService.search( search=rc.searchContent,
													   	 isPublished=rc.fStatus,
													   	 category=rc.fCategories,
													   	 author=rc.fAuthors,
													   	 creator=rc.fCreators,
													   	 offset=( rc.showAll ? 0 : prc.paging.startRow-1 ),
													   	 max=( rc.showAll ? 0 : prc.cbSettings.cb_paging_maxrows ),
													   	 sortOrder="createdDate desc" );
		prc.content 	 = contentResults.content;
		prc.contentCount = contentResults.count;

		// exit handlers
		prc.xehContentSearch 	 	= "#prc.cbAdminEntryPoint#.contentStore";
		prc.xehContentHistory  		= "#prc.cbAdminEntryPoint#.versions.index";
		prc.xehContentExport 		= "#prc.cbAdminEntryPoint#.contentStore.export";
		prc.xehContentClone 		= "#prc.cbAdminEntryPoint#.contentStore.clone";
		
		// view
		event.setView( view="contentStore/indexTable", layout="ajax" );
	}

	// Bulk Status Change
	function bulkStatus( event, rc, prc ){
		event.paramValue("contentID","")
			.paramValue("contentStatus","draft");

		// check if id list has length
		if( len( rc.contentID ) ){
			contentStoreService.bulkPublishStatus(contentID=rc.contentID,status=rc.contentStatus);
			// announce event
			announceInterception("cbadmin_onContentStoreStatusUpdate",{contentID=rc.contentID,status=rc.contentStatus});
			// Message
			getPlugin( "MessageBox" ).info("#listLen(rc.contentID)# content where set to '#rc.contentStatus#'");
		}
		else{
			getPlugin( "MessageBox" ).warn("No content selected!");
		}

		// relocate back
		setNextEvent(event=prc.xehContentStore);
	}

	// editor
	function editor( event, rc, prc ){
		// cb helper
		prc.cbHelper = CBHelper;
		// get all categories
		prc.categories = categoryService.getAll(sortOrder="category");
		// get new or persisted
		prc.content  = contentStoreService.get( event.getValue("contentID",0) );
		// load comments viewlet if persisted
		if( prc.content.isLoaded() ){
			var args = {contentID=rc.contentID};
			// Get Versions Viewlet
			prc.versionsViewlet = runEvent(event="contentbox-admin:versions.pager",eventArguments=args);
		}
		// CK Editor Helper
		prc.ckHelper = getMyPlugin(plugin="CKHelper",module="contentbox-admin");
		
		// Get All registered editors so we can display them
		prc.editors = editorService.getRegisteredEditorsMap();
		// Get User's default editor
		prc.defaultEditor = prc.oAuthor.getPreference("editor", editorService.getDefaultEditor() );
		// Get the editor driver object
		prc.oEditorDriver = editorService.getEditor( prc.defaultEditor );
		
		// Get All registered markups so we can display them
		prc.markups = editorService.getRegisteredMarkups();
		// Get User's default markup
		prc.defaultMarkup = prc.oAuthor.getPreference( "markup", editorService.getDefaultMarkup() );
		
		// get all authors
		prc.authors = authorService.getAll(sortOrder="lastName");
		// get related content
		prc.relatedContent = prc.content.hasRelatedContent() ? prc.content.getRelatedContent() : [];
		prc.linkedContent = prc.content.hasLinkedContent() ? prc.content.getLinkedContent() : [];
		prc.relatedContentIDs = prc.content.getRelatedContentIDs();

		// exit handlers
		prc.xehContentSave 		= "#prc.cbAdminEntryPoint#.contentStore.save";
		prc.xehSlugify			= "#prc.cbAdminEntryPoint#.contentStore.slugify";
		prc.xehSlugCheck		= "#prc.cbAdminEntryPoint#.content.slugUnique";
		prc.xehAuthorEditorSave = "#prc.cbAdminEntryPoint#.authors.changeEditor";
		prc.xehRelatedContentSelector = "#prc.cbAdminEntryPoint#.content.relatedContentSelector";
		prc.xehShowRelatedContentSelector = "#prc.cbAdminEntryPoint#.content.showRelatedContentSelector";
		prc.xehBreakContentLink = "#prc.cbAdminEntryPoint#.content.breakContentLink";

		// Tab
		prc.tabContent_contentStore = true;
		// view
		event.setView("contentStore/editor");
	}
	
	// clone
	function clone( event, rc, prc ){
		// validation
		if( !event.valueExists("title") OR !event.valueExists("contentID") ){
			getPlugin( "MessageBox" ).warn("Can't clone the unclonable, meaning no contentID or title passed.");
			setNextEvent(event=prc.xehPages);
			return;
		}
		// decode the incoming title
		rc.title = urldecode( rc.title );
		// get the content to clone
		var original = contentStoreService.get( rc.contentID );
		// Verify new Title, else do a new copy of it
		if( rc.title eq original.getTitle() ){
			rc.title = "Copy of #rc.title#";
		}
		// get a clone
		var clone = contentStoreService.new( { title=rc.title, slug=getPlugin("HTMLHelper").slugify( rc.title ) } );
		clone.setCreator( prc.oAuthor );
		// prepare for cloning
		clone.prepareForClone(author=prc.oAuthor, 
							  original=original, 
							  originalService=contentStoreService, 
							  publish=rc.contentStatus, 
							  originalSlugRoot=original.getSlug(),
							  newSlugRoot=clone.getSlug());
		// clone this sucker now!
		contentStoreService.saveContent( clone );
		// relocate
		getPlugin( "MessageBox" ).info("Content Cloned, isn't that cool!");
		setNextEvent(event=prc.xehContentStore);
	}

	// save
	function save( event, rc, prc){
		// params
		event.paramValue( "newCategories", "" );
		event.paramValue( "isPublished", true );
		event.paramValue( "slug", "" );
		event.paramValue( "changelog", "" );
		event.paramValue( "customFieldsCount", 0 );
		event.paramValue( "publishedDate", now() );
		event.paramValue( "publishedHour", timeFormat(rc.publishedDate,"HH") );
		event.paramValue( "publishedMinute", timeFormat(rc.publishedDate,"mm") );
		event.paramValue( "expireHour", "" );
		event.paramValue( "expireMinute", "" );
		event.paramValue( "content", "" );
		event.paramValue( "creatorID","" );
		event.paramValue( "customFieldsCount", 0 );
		event.paramValue( "relatedContentIDs", [] );

		// Quick content check
		if( structKeyExists(rc,"quickcontent") ){
			rc.content = rc.quickcontent;
		}

		// slugify the incoming title or slug
		if( NOT len(rc.slug) ){ rc.slug = rc.title; }
		rc.slug = getPlugin("HTMLHelper").slugify( rc.slug );

		// Verify permission for publishing, else save as draft
		if( !prc.oAuthor.checkPermission("CONTENTSTORE_ADMIN") ){
			rc.isPublished = "false";
		}

		// get new/persisted content and populate it
		var content = populateModel( contentStoreService.get( rc.contentID ) )
			.addPublishedtime( rc.publishedHour, rc.publishedMinute)
			.addExpiredTime( rc.expireHour, rc.expireMinute );
		var isNew = ( NOT content.isLoaded() );

		// Validate it
		var errors = content.validate();
		if( !len(trim(rc.content)) ){
			arrayAppend(errors, "Please enter the content to save!");
		}
		if( arrayLen(errors) ){
			getPlugin( "MessageBox" ).warn(messageArray=errors);
			editor(argumentCollection=arguments);
			return;
		}
		
		// Attach creator if new page
		if( isNew ){ content.setCreator( prc.oAuthor ); }
		
		// Override creator?
		if( !isNew and prc.oAuthor.checkPermission("CONTENTSTORE_ADMIN") and len( rc.creatorID ) and content.getCreator().getAuthorID() NEQ rc.creatorID ){
			content.setCreator( authorService.get( rc.creatorID ) );
		}

		// Register a new content in the page, versionized!
		content.addNewContentVersion(content=rc.content, changelog=rc.changelog, author=prc.oAuthor);

		// Create new categories?
		var categories = [];
		if( len(trim(rc.newCategories)) ){
			categories = categoryService.createCategories( trim(rc.newCategories) );
		}
		// Inflate sent categories from collection
		categories.addAll( categoryService.inflateCategories( rc ) );
		// detach categories and re-attach
		content.setCategories( categories );
		// Inflate Custom Fields into the page
		content.inflateCustomFields( rc.customFieldsCount, rc );
		// Inflate Related Content into the content
		content.inflateRelatedContent( rc.relatedContentIDs );
		// announce event
		announceInterception("cbadmin_preContentStoreSave", {content=content, isNew=isNew});
		// save content
		contentStoreService.saveContent( content );
		// announce event
		announceInterception("cbadmin_postContentStoreSave", {content=content, isNew=isNew});

		// Ajax?
		if( event.isAjax() ){
			var rData = {
				"CONTENTID" = content.getContentID()
			};
			event.renderData(type="json",data=rData);
		}
		else{
			// relocate
			getPlugin( "MessageBox" ).info("content Saved!");
			setNextEvent( prc.xehContentStore );
		}
	}

	// remove
	function remove( event, rc, prc ){
		// params
		event.paramValue( "contentID", "" );
		
		// verify if contentID sent
		if( !len( rc.contentID ) ){
			getPlugin( "MessageBox" ).warn( "No content sent to delete!" );
			setNextEvent( prc.xehContentStore );
		}
		
		// Inflate to array
		rc.contentID = listToArray( rc.contentID );
		var messages = [];
		
		// Iterate and remove
		for( var thisContentID in rc.contentID ){
			var content = contentStoreService.get( thisContentID );
			if( isNull( content ) ){
				arrayAppend( messages, "Invalid content contentID sent: #thisContentID#, so skipped removal" );
			}
			else{
				// GET id to be sent for announcing later
				var contentID 	= content.getContentID();
				var title		= content.getTitle();
				// announce event
				announceInterception("cbadmin_preContentStoreRemove", { content=content } );
				// Delete it
				contentStoreService.deleteContent( content );
				arrayAppend( messages, "content '#title#' removed" );
				// announce event
				announceInterception("cbadmin_postContentStoreRemove", { contentID=contentID });
			}
		}
		// messagebox
		getPlugin( "MessageBox" ).info(messageArray=messages);
		// relocate
		setNextEvent(event=prc.xehContentStore);
	}

	// pager viewlet
	function pager( event, rc, prc ,authorID="all",max=0,pagination=true,latest=false){

		// check if authorID exists in rc to do an override, maybe it's the paging call
		if( event.valueExists("pager_authorID") ){
			arguments.authorID = rc.pager_authorID;
		}
		// Max rows incoming or take default for pagination.
		if( arguments.max eq 0 ){ arguments.max = prc.cbSettings.cb_paging_maxrows; }

		// paging default
		event.paramValue("page",1);

		// exit handlers
		prc.xehPager 			= "#prc.cbAdminEntryPoint#.contentStore.pager";
		prc.xehContentEditor	= "#prc.cbAdminEntryPoint#.contentStore.editor";
		prc.xehContentHistory 	= "#prc.cbAdminEntryPoint#.versions.index";

		// prepare paging plugin
		prc.pager_pagingPlugin 	= getMyPlugin(plugin="Paging", module="contentbox");
		prc.pager_paging 	  	= prc.pager_pagingPlugin.getBoundaries();
		prc.pager_pagingLink 	= "javascript:pagerLink(@page@)";
		prc.pager_pagination	= arguments.pagination;
		
		// Sorting
		var sortOrder = "publishedDate DESC";
		if( arguments.latest ){ sortOrder = "modifiedDate desc"; }
		
		// search content with filters and all
		var contentResults = contentStoreService.search(author=arguments.authorID,
													    offset=prc.pager_paging.startRow-1,
													    max=arguments.max,
													    sortOrder=sortOrder);
		prc.pager_content 	    = contentResults.content;
		prc.pager_contentCount  = contentResults.count;

		// author in RC
		prc.pager_authorID		= arguments.authorID;

		// view pager
		return renderView(view="contentStore/pager", module="contentbox-admin");
	}

	// slugify remotely
	function slugify( event, rc, prc ){
		event.renderData(data=trim( getPlugin("HTMLHelper").slugify( rc.slug ) ),type="plain");
	}

	// editor selector
	function editorSelector( event, rc, prc ){
		// paging default
		event.paramValue("page",1);
		event.paramValue("search", "");
		event.paramValue("clear", false);

		// exit handlers
		prc.xehEditorSelector	= "#prc.cbAdminEntryPoint#.contentStore.editorSelector";

		// prepare paging plugin
		prc.pagingPlugin 	= getMyPlugin(plugin="Paging",module="contentbox");
		prc.paging 	  		= prc.pagingPlugin.getBoundaries();
		prc.pagingLink 		= "javascript:pagerLink(@page@)";

		// search content with filters and all
		var contentResults = contentStoreService.search(search=rc.search,
													    offset=prc.paging.startRow-1,
													    max=prc.cbSettings.cb_paging_maxrows,
													    sortOrder="createdDate asc",
													    searchActiveContent=false);

		prc.content 		= contentResults.content;
		prc.contentCount  	= contentResults.count;
		prc.CBHelper 		= CBHelper;
		
		// if ajax and searching, just return tables
		if( event.isAjax() and len( rc.search ) OR rc.clear ){
			return renderView(view="contentStore/editorSelectorEntries", module="contentbox-admin");
		}
		else{
			event.setView(view="contentStore/editorSelector",layout="ajax");
		}
	}

	// Export content
	function export( event, rc, prc ){
		event.paramValue("format", "json");
		// get content
		prc.content  = contentStoreService.get( event.getValue("contentID",0) );
		
		// relocate if not existent
		if( !prc.content.isLoaded() ){
			getPlugin( "MessageBox" ).warn("ContentID sent is not valid");
			setNextEvent( prc.xehContentStore );
		}
		
		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "#prc.content.getSlug()#." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=prc.content.getMemento(), type=rc.format, xmlRootName="content")
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#"); 
				break;
			}
			default:{
				event.renderData(data="Invalid export type: #rc.format#");
			}
		}
	}
	
	// Export All content
	function exportAll( event, rc, prc ){
		event.paramValue("format", "json");
		// get all prepared content objects
		var data  = contentStoreService.getAllForExport();
		
		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "ContentStore." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=data, type=rc.format, xmlRootName="ContentStore")
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#"); 
				break;
			}
			default:{
				event.renderData(data="Invalid export type: #rc.format#");
			}
		}
	}
	
	// import contentstore
	function importAll( event, rc, prc ){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try{
			if( len( rc.importFile ) and fileExists( rc.importFile ) ){
				var importLog = contentStoreService.importFromFile( importFile=rc.importFile, override=rc.overrideContent );
				getPlugin( "MessageBox" ).info( "Content imported sucessfully!" );
				flash.put( "importLog", importLog );
			}
			else{
				getPlugin( "MessageBox" ).error( "The import file is invalid: #rc.importFile# cannot continue with import" );
			}
		}
		catch(any e){
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			getPlugin( "MessageBox" ).error( errorMessage );
		}
		setNextEvent( prc.xehContentStore );
	}
	
}
