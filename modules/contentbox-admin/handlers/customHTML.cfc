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
* Manage system settings
*/
component extends="baseHandler"{

	// Dependencies
	property name="settingsService"		inject="id:settingService@cb";
	property name="htmlService"			inject="id:customHTMLService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";
	property name="editorService"		inject="id:editorService@cb";
	property name="authorService"		inject="id:authorService@cb";
	property name="categoryService"		inject="id:categoryService@cb";
	
	// index
	function index(event,rc,prc){
		// get all authors
		prc.authors    = authorService.getAll(sortOrder="lastName");
		// get all categories
		prc.categories = categoryService.getAll(sortOrder="category");

		// Exit Handler
		prc.xehEntrySearch 		= "#prc.cbAdminEntryPoint#.customHTML";
		prc.xehEditorHTML		= "#prc.cbAdminEntryPoint#.customHTML.editor";
		prc.xehRemoveHTML		= "#prc.cbAdminEntryPoint#.customHTML.remove";
		prc.xehEntryTable	 	= "#prc.cbAdminEntryPoint#.customHTML.entriesTable";
		prc.xehEntryBulkStatus 	= "#prc.cbAdminEntryPoint#.customHTML.bulkstatus";
		prc.xehExportAllHTML	= "#prc.cbAdminEntryPoint#.customHTML.exportAll";
		prc.xehImportHTML		= "#prc.cbAdminEntryPoint#.customHTML.importAll";
		prc.xehEntryClone 		= "#prc.cbAdminEntryPoint#.customHTML.clone";
		
		// tab
		prc.tabContent_customHTML	= true; 
		
		// view
		event.setView( "customHTML/index" );
	}
	
	// entriesTable
	function entriesTable(event,rc,prc){
		event.paramValue("page",1);
		event.paramValue("searchEntries","");
		event.paramValue("fAuthors","all");
		event.paramValue("fCategories","all");
		event.paramValue("fStatus","any");
		event.paramValue("isFiltering",false,true);
		event.paramValue("showAll", false);
		
		// prepare paging plugin
		prc.pagingPlugin = getMyPlugin(plugin="Paging",module="contentbox");
		prc.paging 		 = prc.pagingPlugin.getBoundaries();
		prc.pagingLink 	 = "javascript:contentPaginate(@page@)";
		
		// is Filtering?
		if( rc.fAuthors neq "all" OR rc.fStatus neq "any" OR rc.fCategories neq "all" or rc.showAll ){ 
			prc.isFiltering = true;
		}
		
		// get content pieces
		var entryResults = htmlService.search(search=rc.searchEntries,
											  isPublished=rc.fStatus,
											  author=rc.fAuthors,
											  offset=( rc.showAll ? 0 : prc.paging.startRow-1 ),
											  max=( rc.showAll ? 0 : prc.cbSettings.cb_paging_maxrows ));
		prc.entries 		= entryResults.entries;
		prc.entriesCount  	= entryResults.count;
		
		// Exit Handler
		prc.xehContentSearch 	= "#prc.cbAdminEntryPoint#.customHTML";
		prc.xehRemoveHTML		= "#prc.cbAdminEntryPoint#.customHTML.remove";
		prc.xehEditorHTML		= "#prc.cbAdminEntryPoint#.customHTML.editor";
		prc.xehExportHTML		= "#prc.cbAdminEntryPoint#.customHTML.export";
		
		// view
		event.setView(view="customHTML/indexTable", layout="ajax");
	}
	
	// slugify remotely
	function slugify(event,rc,prc){
		event.renderData(data=getPlugin("HTMLHelper").slugify( rc.slug ),type="plain");
	}
	
	// editor
	function editor(event,rc,prc){
		
		// tab
		prc.tabContent				= true;
		prc.tabContent_customHTML	= true; 
		
		// CK Editor Helper
		prc.ckHelper = getMyPlugin(plugin="CKHelper", module="contentbox-admin");
		
		// get new or persisted
		prc.content  = htmlService.get( event.getValue("contentID",0) );
		
		// Get All registered editors so we can display them
		prc.editors = editorService.getRegisteredEditorsMap();
		// Get User's default editor
		prc.defaultEditor = prc.oAuthor.getPreference( "editor", editorService.getDefaultEditor() );
		// Get the editor driver object
		prc.oEditorDriver = editorService.getEditor( prc.defaultEditor );
		
		// Get All registered markups so we can display them
		prc.markups = editorService.getRegisteredMarkups();
		// Get User's default markup
		prc.defaultMarkup = prc.oAuthor.getPreference( "markup", editorService.getDefaultMarkup() );
		
		// exit handlers
		prc.xehContentSave 		= "#prc.cbAdminEntryPoint#.customHTML.save";
		prc.xehSlugify	  		= "#prc.cbAdminEntryPoint#.customHTML.slugify";
		prc.xehAuthorEditorSave = "#prc.cbAdminEntryPoint#.authors.changeEditor";
		prc.xehSlugify			= "#prc.cbAdminEntryPoint#.entries.slugify";
		prc.xehSlugCheck		= "#prc.cbAdminEntryPoint#.customHTML.slugUnique";
		
		// get all authors
		prc.authors    = authorService.getAll(sortOrder="lastName");
		
		// view
		event.setView(view="customHTML/editor");
	}
	
	// save html
	function save(event,rc,prc){
		// param values
		event.paramValue( "creatorID", "" );
		event.paramValue( "isPublished", true );
		event.paramValue( "slug", "" );
		event.paramValue( "changelog", "" );
		event.paramValue( "publishedDate", now() );
		event.paramValue( "publishedHour", timeFormat( rc.publishedDate, "HH" ) );
		event.paramValue( "publishedMinute", timeFormat( rc.publishedDate, "mm" ) );
		
		// slugify the incoming title or slug
		rc.slug = ( NOT len( rc.slug ) ? rc.title : getPlugin("HTMLHelper").slugify( rc.slug ) );
		
		// Verify permission for publishing, else save as draft
		if( !prc.oAuthor.checkPermission("CUSTOMHTML_ADMIN") ){
			rc.isPublished 	= "false";
		}
		
		// populate and get content
		var oContent = htmlService.get( id=rc.contentID );
		populateModel( oContent )
			.addPublishedtime( rc.publishedHour, rc.publishedMinute )
			.addExpiredTime( rc.expireHour, rc.expireMinute );
		
		// Attach creator if new customHTML or no author registered
		var isNew = ( NOT oContent.isLoaded() );
		if( isNew OR !oContent.hasCreator() ){ 
			oContent.setCreator( prc.oAuthor ); 
		}
		// Override creator?
		else if( !isNew and prc.oAuthor.checkPermission("CUSTOMHTML_ADMIN") and len( rc.creatorID ) and oContent.getCreator().getAuthorID() NEQ rc.creatorID ){
			oContent.setCreator( authorService.get( rc.creatorID ) );
		}
		
		// validate it
		var errors = oContent.validate();
		if( !arrayLen(errors) ){
			// announce event
			announceInterception("cbadmin_preCustomHTMLSave",{content=oContent,contentID=rc.contentID});
			// save content
			htmlService.saveCustomHTML( oContent );
			// announce event
			announceInterception("cbadmin_postCustomHTMLSave",{content=oContent});
			// Message
			getPlugin("MessageBox").info("Custom HTML saved! Isn't that majestic!");
		}
		else{
			getPlugin("MessageBox").warn(errorMessages=errors);
		}
		
		// Ajax Save?
		if( event.isAjax() ){
			var rData = {
				"CONTENTID" = oContent.getContentID()
			};
			event.renderData(type="json", data=rData);
		}
		else{
			// relocate back to editor
			setNextEvent(prc.xehCustomHTML);
		}
	}
	
	// Bulk Status Change
	function bulkStatus(event,rc,prc){
		event.paramValue("contentID","");
		event.paramValue("contentStatus","draft");

		// check if id list has length
		if( len( rc.contentID ) ){
			// save in bulk
			htmlService.bulkPublishStatus(contentID=rc.contentID, status=rc.contentStatus);
			// announce event
			announceInterception("cbadmin_onCustomHTMLStatusUpdate", { contentID=rc.contentID, status=rc.contentStatus } );
			// Message
			getPlugin("MessageBox").info("#listLen(rc.contentID)# CustomHTML where set to '#rc.contentStatus#'");
		}
		else{
			getPlugin("MessageBox").warn("No content selected!");
		}
		// relocate back
		setNextEvent( event=prc.xehCustomHTML );
	}
	
	// remove
	function remove(event,rc,prc){
		// params
		event.paramValue( "contentID", "" );
		event.paramValue("page","1");
		
		// verify if contentID sent
		if( !len( rc.contentID ) ){
			getPlugin("MessageBox").warn( "No entries sent to delete!" );
			setNextEvent(event=prc.xehCustomHTML, queryString="page=#rc.page#");
		}
		
		// Inflate to array
		rc.contentID = listToArray( rc.contentID );
		var messages = [];
		
		// Iterate and remove
		for( var thisContentID in rc.contentID ){
			var entry = htmlService.get( thisContentID );
			if( isNull( entry ) ){
				arrayAppend( messages, "Invalid entry contentID sent: #thisContentID#, so skipped removal" );
			}
			else{
				// GET id to be sent for announcing later
				var contentID 	= entry.getContentID();
				var title		= entry.getTitle();
				// announce event
				announceInterception("cbadmin_preCustomHTMLRemove", { entry=entry, contentID=contentID } );
				// Delete it
				htmlService.delete( entry );
				arrayAppend( messages, "Entry '#title#' removed" );
				// announce event
				announceInterception("cbadmin_postCustomHTMLRemove", { contentID=contentID });
			}
		}
		// messagebox
		getPlugin("MessageBox").info(messageArray=messages);
		setNextEvent(event=prc.xehCustomHTML,queryString="page=#rc.page#");
	}
	
	// editor selector
	function editorSelector(event,rc,prc){
		// paging default
		event.paramValue("page",1);
		event.paramValue("search", "");
		event.paramValue("clear", false);

		// exit handlers
		prc.xehEditorSelector	= "#prc.cbAdminEntryPoint#.customHTML.editorSelector";

		// prepare paging plugin
		prc.pagingPlugin 	= getMyPlugin(plugin="Paging",module="contentbox");
		prc.paging 	  		= prc.pagingPlugin.getBoundaries();
		prc.pagingLink 		= "javascript:pagerLink(@page@)";

		// search entries with filters and all
		var htmlResults = htmlService.search(search=rc.search,
											 isPublished=true,
											 offset=prc.paging.startRow-1,
											 max=prc.cbSettings.cb_paging_maxrows,
											 searchActiveContent=false);

		prc.entries 		= htmlResults.entries;
		prc.entriesCount  	= htmlResults.count;
		prc.CBHelper 		= CBHelper;
		
		// if ajax and searching, just return tables
		if( event.isAjax() and len( rc.search ) OR rc.clear ){
			return renderView(view="customHTML/editorSelectorEntries", module="contentbox-admin");
		}
		else{
			event.setView(view="customHTML/editorSelector",layout="ajax");
		}
	}
	
	// check if a slug unique
	function slugUnique(event,rc,prc){
		event.paramValue( "slug", "" );
		event.paramValue( "contentID", "" );
		
		var data = {
			"UNIQUE" = false
		};
		
		if( len( rc.slug ) ){
			data[ "UNIQUE" ] = htmlService.isSlugUnique( trim( rc.slug ), trim( rc.contentID ) );
		}
		
		event.renderData(data=data, type="json");
	}
	
	// clone
	function clone(event,rc,prc){
		// validation
		if( !event.valueExists("title") OR !event.valueExists("contentID") ){
			getPlugin("MessageBox").warn("Can't clone the unclonable, meaning no contentID or title passed.");
			setNextEvent(event=prc.xehCustomHTML);
			return;
		}
		// decode the incoming title
		rc.title = urldecode( rc.title );
		// get the entry to clone
		var original = htmlService.get( rc.contentID );
		// Verify new Title, else do a new copy of it
		if( rc.title eq original.getTitle() ){
			rc.title = "Copy of #rc.title#";
		}
		// get a clone with new title and slug
		var clone = htmlService.new( { title=rc.title, slug=getPlugin("HTMLHelper").slugify( rc.title ) } );
		// prepare descendants for cloning, might take a while if lots of children to copy.
		clone.prepareForClone(author=prc.oAuthor, 
							  original=original, 
							  originalService=htmlService, 
							  publish=rc.entryStatus);
		// clone this sucker now!
		htmlService.saveCustomHTML( clone );
		// relocate
		getPlugin("MessageBox").info("Entry Cloned, isn't that cool!");
		setNextEvent(event=prc.xehCustomHTML);
	}
	
	// Export CustomHTML
	function export(event,rc,prc){
		event.paramValue("format", "json");
		// get content object
		prc.content  = htmlService.get( event.getValue("contentID",0) );
		
		// relocate if not existent
		if( !prc.content.isLoaded() ){
			getPlugin("MessageBox").warn("ContentID sent is not valid");
			setNextEvent( "#prc.cbAdminEntryPoint#.customHTML" );
		}
		
		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "#prc.content.getSlug()#." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=prc.content.getMemento(), type=rc.format, xmlRootName="customhtml")
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#"); 
				break;
			}
			default:{
				event.renderData(data="Invalid export type: #rc.format#");
			}
		}
		
		
	}
	
	// Export All CustomHTML
	function exportAll(event,rc,prc){
		event.paramValue("format", "json");
		// get all prepared content objects
		var data  = htmlService.getAllForExport();
		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "CustomHTML." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=data, type=rc.format, xmlRootName="customhtml")
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#"); ; 
				break;
			}
			default:{
				event.renderData(data="Invalid export type: #rc.format#");
			}
		}
	}
	
	// import settings
	function importAll(event,rc,prc){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try{
			if( len( rc.importFile ) and fileExists( rc.importFile ) ){
				var importLog = htmlService.importFromFile( importFile=rc.importFile, override=rc.overrideContent );
				getPlugin("MessageBox").info( "Custom HTML imported sucessfully!" );
				flash.put( "importLog", importLog );
			}
			else{
				getPlugin("MessageBox").error( "The import file is invalid: #rc.importFile# cannot continue with import" );
			}
		}
		catch(any e){
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			getPlugin("MessageBox").error( errorMessage );
		}
		setNextEvent( prc.xehCustomHTML );
	}
	
}
