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
* Manage blog entries
*/
component extends="baseHandler"{

	// Dependencies
	property name="categoryService"		inject="id:categoryService@cb";
	property name="entryService"		inject="id:entryService@cb";
	property name="authorService"		inject="id:authorService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";
	
	// Public properties
	this.preHandler_except = "pager";

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// exit Handlers
		prc.xehEntries 		= "#prc.cbAdminEntryPoint#.entries";
		prc.xehEntryEditor 	= "#prc.cbAdminEntryPoint#.entries.editor";
		prc.xehEntryRemove 	= "#prc.cbAdminEntryPoint#.entries.remove";
		// Tab control
		prc.tabContent = true;
		
		// Verify if disabled?
		if( prc.cbSettings.cb_site_disable_blog ){
			getPlugin("MessageBox").warn("The blog has been currently disabled. You can activate it again in your ContentBox settings panel");
			setNextEvent(prc.xehDashboard);
		}
	}
	
	// index
	function index(event,rc,prc){
		// params
		event.paramValue("page",1);
		event.paramValue("searchEntries","");
		event.paramValue("fAuthors","all");
		event.paramValue("fCategories","all");
		event.paramValue("fStatus","any");
		event.paramValue("isFiltering",false);
		
		// prepare paging plugin
		prc.pagingPlugin 	= getMyPlugin(plugin="Paging",module="contentbox");
		prc.paging 			= prc.pagingPlugin.getBoundaries();
		prc.pagingLink 		= event.buildLink('#prc.xehEntries#.page.@page@?');
		// Append search to paging link?
		if( len(rc.searchEntries) ){ prc.pagingLink&="&searchEntries=#rc.searchEntries#"; }
		// Append filters to paging link?
		if( rc.fAuthors neq "all"){ prc.pagingLink&="&fAuthors=#rc.fAuthors#"; }
		if( rc.fCategories neq "all"){ prc.pagingLink&="&fCategories=#rc.fCategories#"; }
		if( rc.fStatus neq "any"){ prc.pagingLink&="&fStatus=#rc.fStatus#"; }
		// is Filtering?
		if( rc.fAuthors neq "all" OR rc.fCategories neq "all" or rc.fStatus neq "any"){ rc.isFiltering = true; }
		
		// get all categories
		prc.categories = categoryService.getAll(sortOrder="category");
		// get all authors
		prc.authors    = authorService.getAll(sortOrder="lastName");
		
		// search entries with filters and all
		var entryResults = entryService.search(search=rc.searchEntries,
											   offset=prc.paging.startRow-1,
											   max=prc.cbSettings.cb_paging_maxrows,
											   isPublished=rc.fStatus,
											   category=rc.fCategories,
											   author=rc.fAuthors);
		prc.entries 	 = entryResults.entries;
		prc.entriesCount = entryResults.count;
		
		// exit handlers
		prc.xehEntrySearch 	 = "#prc.cbAdminEntryPoint#.entries";
		prc.xehEntryQuickLook= "#prc.cbAdminEntryPoint#.entries.quickLook";
		prc.xehEntryHistory  = "#prc.cbAdminEntryPoint#.versions.index";
		
		// Tab
		prc.tabContent_blog = true;
		// view
		event.setView("entries/index");
	}
	
	// Quick Look
	function quickLook(event,rc,prc){
		// get entry
		prc.entry  = entryService.get( event.getValue("contentID",0) );
		event.setView(view="entries/quickLook",layout="ajax");
	}
	
	// editor
	function editor(event,rc,prc){
		// cb helper
		prc.cbHelper = CBHelper;
		// get all categories
		prc.categories = categoryService.getAll(sortOrder="category");
		// get new or persisted
		prc.entry  = entryService.get( event.getValue("contentID",0) );
		// load comments viewlet if persisted
		if( prc.entry.isLoaded() ){
			var args = {contentID=rc.contentID};
			// Get Comments viewlet
			prc.commentsViewlet = runEvent(event="contentbox-admin:comments.pager",eventArguments=args);
			// Get Versions Viewlet
			prc.versionsViewlet = runEvent(event="contentbox-admin:versions.pager",eventArguments=args);
		}
		// CK Editor Helper
		prc.ckHelper = getMyPlugin(plugin="CKHelper",module="contentbox-admin");
		// exit handlers
		prc.xehEntrySave 		= "#prc.cbAdminEntryPoint#.entries.save";
		prc.xehSlugify			= "#prc.cbAdminEntryPoint#.entries.slugify";
		// Tab
		prc.tabContent_blog = true;
		// view
		event.setView("entries/editor");
	}	

	// save
	function save(event,rc,prc){
		// params
		event.paramValue("allowComments",prc.cbSettings.cb_comments_enabled);
		event.paramValue("newCategories","");
		event.paramValue("isPublished",true);
		event.paramValue("slug","");
		event.paramValue("changelog","");
		event.paramValue("publishedDate",now());
		event.paramValue("publishedHour", timeFormat(rc.publishedDate,"HH"));
		event.paramValue("publishedMinute", timeFormat(rc.publishedDate,"mm"));
		event.paramValue("content","");
		
		// Quick save changelog
		if( event.isAjax() ){
			rc.changelog = "Quick save";	
		}
		
		// Quick content check
		if( structKeyExists(rc,"quickcontent") ){
			rc.content = rc.quickcontent;
		}
		
		// slugify the incoming title or slug
		if( NOT len(rc.slug) ){ rc.slug = rc.title; }
		rc.slug = getPlugin("HTMLHelper").slugify( rc.slug );
		
		// Verify permission for publishing, else save as draft
		if( !prc.oAuthor.checkPermission("ENTRIES_ADMIN") ){
			rc.isPublished = "false";
		}
		
		// get new/persisted entry and populate it
		var entry = populateModel( entryService.get(rc.contentID) ).addPublishedtime(rc.publishedHour,rc.publishedMinute);
		var isNew = (NOT entry.isLoaded());
		
		// Validate it
		var errors = entry.validate();
		if( !len(trim(rc.content)) ){
			arrayAppend(errors, "Please enter the content to save!");
		}
		if( arrayLen(errors) ){
			getPlugin("MessageBox").warn(messageArray=errors);
			editor(argumentCollection=arguments);
			return;
		}
		
		// Register a new content in the page, versionized!
		entry.addNewContentVersion(content=rc.content,changelog=rc.changelog,author=prc.oAuthor); 
		
		// Create new categories?
		var categories = [];
		if( len(trim(rc.newCategories)) ){
			categories = categoryService.createCategories( trim(rc.newCategories) );
		}
		// Inflate sent categories from collection
		categories.addAll( categoryService.inflateCategories( rc ) );
		// detach categories and re-attach
		entry.removeAllCategories().setCategories( categories );
		// Inflate Custom Fields into the page
		entry.inflateCustomFields( rc.customFieldsCount, rc );
		// announce event
		announceInterception("cbadmin_preEntrySave",{entry=entry,isNew=isNew});
		// save entry
		entryService.saveEntry( entry );
		// announce event
		announceInterception("cbadmin_postEntrySave",{entry=entry,isNew=isNew});
		
		// Ajax?
		if( event.isAjax() ){
			var rData = {
				"CONTENTID" = entry.getContentID()
			};
			event.renderData(type="json",data=rData);
		}
		else{
			// relocate
			getPlugin("MessageBox").info("Entry Saved!");
			setNextEvent(prc.xehEntries);
		}
	}
	
	// remove
	function remove(event,rc,prc){
		var entry = entryService.get(rc.contentID);
		if( isNull(entry) ){
			getPlugin("MessageBox").setMessage("warning","Invalid Entry detected!");
		}
		else{
			// GET id
			var contentID = entry.getContentID();
			// announce event
			announceInterception("cbadmin_preEntryRemove",{entry=entry});
			// remove it
			entryService.deleteContent( entry );
			// announce event
			announceInterception("cbadmin_postEntryRemove",{contentID=contentID});
			// messagebox
			getPlugin("MessageBox").setMessage("info","Entry Removed!");
		}
		setNextEvent( prc.xehEntries );
	}
	
	// pager viewlet
	function pager(event,rc,prc,authorID="all",max=0,pagination=true){
		
		// check if authorID exists in rc to do an override, maybe it's the paging call
		if( event.valueExists("pager_authorID") ){
			arguments.authorID = rc.pager_authorID;
		}
		// Max rows incoming or take default for pagination.
		if( arguments.max eq 0 ){ arguments.max = prc.cbSettings.cb_paging_maxrows; }
		
		// paging default
		event.paramValue("page",1);
		
		// exit handlers
		prc.xehPager 		= "#prc.cbAdminEntryPoint#.entries.pager";
		prc.xehEntryEditor	= "#prc.cbAdminEntryPoint#.entries.editor";
		prc.xehEntryQuickLook= "#prc.cbAdminEntryPoint#.entries.quickLook";
		prc.xehEntryHistory = "#prc.cbAdminEntryPoint#.versions.index";
		
		// prepare paging plugin
		prc.pager_pagingPlugin 	= getMyPlugin(plugin="Paging",module="contentbox");
		prc.pager_paging 	  	= prc.pager_pagingPlugin.getBoundaries();
		prc.pager_pagingLink 	= "javascript:pagerLink(@page@)";
		prc.pager_pagination	= arguments.pagination;
		
		// search entries with filters and all
		var entryResults = entryService.search(author=arguments.authorID,
											   offset=prc.pager_paging.startRow-1,
											   max=arguments.max);
		prc.pager_entries 	    = entryResults.entries;
		prc.pager_entriesCount  = entryResults.count;
		
		// author in RC
		prc.pager_authorID		= arguments.authorID;
		
		// view pager
		return renderView(view="entries/pager",module="contentbox-admin");
	}
	
	// slugify remotely
	function slugify(event,rc,prc){
		event.renderData(data=getPlugin("HTMLHelper").slugify( rc.slug ),type="plain");
	}
	
	// quick post viewlet
	function quickPost(event,rc,prc){
		// get all categories for quick post
		prc.qpCategories = categoryService.getAll(sortOrder="category");
		// exit handlers
		prc.xehQPEntrySave = "#prc.cbAdminEntryPoint#.entries.save";
		// render it out
		return renderView(view="entries/quickPost",module="contentbox-admin");		
	}
	
	// editor selector
	function editorSelector(event,rc,prc){
		// paging default
		event.paramValue("page",1);
		
		// exit handlers
		prc.xehEditorSelector	= "#prc.cbAdminEntryPoint#.entries.editorSelector";

		// prepare paging plugin
		prc.pagingPlugin 	= getMyPlugin(plugin="Paging",module="contentbox");
		prc.paging 	  		= prc.pagingPlugin.getBoundaries();
		prc.pagingLink 		= "javascript:pagerLink(@page@)";

		// search entries with filters and all
		var entryResults = entryService.search(offset=prc.paging.startRow-1,
											  max=prc.cbSettings.cb_paging_maxrows,
											  sortOrder="createdDate asc");

		prc.entries 		= entryResults.entries;
		prc.entriesCount  	= entryResults.count;
		prc.CBHelper 		= CBHelper;
		
		event.setView(view="entries/editorSelector",layout="ajax");
	}
}
