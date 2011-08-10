/**
* Manage blog entries
*/
component extends="baseHandler"{

	// Dependencies
	property name="categoryService"		inject="id:categoryService@bb";
	property name="entryService"		inject="id:entryService@bb";
	property name="authorService"		inject="id:authorService@bb";

	// Public properties
	this.preHandler_except = "pager";

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// exit Handlers
		prc.xehEntries 		= "#prc.bbEntryPoint#.entries";
		rc.xehEntryEditor 	= "#prc.bbEntryPoint#.entries.editor";
		rc.xehEntryRemove 	= "#prc.bbEntryPoint#.entries.remove";
		// Tab control
		prc.tabEntries = true;
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
		rc.pagingPlugin = getMyPlugin(plugin="Paging",module="blogbox");
		rc.paging 		= rc.pagingPlugin.getBoundaries();
		rc.pagingLink 	= event.buildLink('#prc.xehEntries#.page.@page@?');
		// Append search to paging link?
		if( len(rc.searchEntries) ){ rc.pagingLink&="&searchEntries=#rc.searchEntries#"; }
		// Append filters to paging link?
		if( rc.fAuthors neq "all"){ rc.pagingLink&="&fAuthors=#rc.fAuthors#"; }
		if( rc.fCategories neq "all"){ rc.pagingLink&="&fCategories=#rc.fCategories#"; }
		if( rc.fStatus neq "any"){ rc.pagingLink&="&fStatus=#rc.fStatus#"; }
		// is Filtering?
		if( rc.fAuthors neq "all" OR rc.fCategories neq "all" or rc.fStatus neq "any"){ rc.isFiltering = true; }
		
		// get all categories
		rc.categories = categoryService.getAll(sortOrder="category");
		// get all authors
		rc.authors    = authorService.getAll(sortOrder="lastName");
		
		// search entries with filters and all
		var entryResults = entryService.search(search=rc.searchEntries,
											   offset=rc.paging.startRow-1,
											   max=prc.bbSettings.bb_paging_maxrows,
											   isPublished=rc.fStatus,
											   category=rc.fCategories,
											   author=rc.fAuthors);
		rc.entries 		 = entryResults.entries;
		rc.entriesCount  = entryResults.count;
		
		// exit handlers
		rc.xehEntrySearch 	= "#prc.bbEntryPoint#.entries";
		rc.xehEntryQuickLook= "#prc.bbEntryPoint#.entries.quickLook";
		// Tab
		prc.tabEntries_viewAll = true;
		// view
		event.setView("entries/index");
	}
	
	// Quick Look
	function quickLook(event,rc,prc){
		// get entry
		rc.entry  = entryService.get( event.getValue("entryID",0) );
		event.setView(view="entries/quickLook",layout="ajax");
	}
	
	// editor
	function editor(event,rc,prc){
		// get all categories
		rc.categories = categoryService.getAll(sortOrder="category");
		// get new or persisted
		rc.entry  = entryService.get( event.getValue("entryID",0) );
		// load comments viewlet if persisted
		if( rc.entry.isLoaded() ){
			// Get Comments viewlet
			rc.commentsViewlet = runEvent(event="blogbox-admin:comments.pager",eventArguments={entryID=rc.entryID});
		}
		// exit handlers
		rc.xehEntrySave = "#prc.bbEntryPoint#.entries.save";
		rc.xehSlugify	= "#prc.bbEntryPoint#.entries.slugify";
		// Tab
		prc.tabEntries_editor = true;
		// view
		event.setView("entries/editor");
	}	

	// save
	function save(event,rc,prc){
		// params
		event.paramValue("allowComments",prc.bbSettings.bb_comments_enabled);
		event.paramValue("newCategories","");
		event.paramValue("isPublished",true);
		event.paramValue("slug","");
		event.paramValue("publishedDate",now());
		event.paramValue("publishedHour", timeFormat(rc.publishedDate,"HH"));
		event.paramValue("publishedMinute", timeFormat(rc.publishedDate,"mm"));
		
		// slugify the incoming title or slug
		if( NOT len(rc.slug) ){ rc.slug = rc.title; }
		rc.slug = getPlugin("HTMLHelper").slugify( rc.slug );
		
		// get new/persisted entry and populate it
		var entry = populateModel( entryService.get(rc.entryID) ).addPublishedtime(rc.publishedHour,rc.publishedMinute);
		// Validate it
		var errors = entry.validate();
		if( arrayLen(errors) ){
			getPlugin("MessageBox").warn(messageArray=errors);
			editor(argumentCollection=arguments);
			return;
		}
		
		// announce event
		announceInterception("bbadmin_preEntrySave",{entry=entry});
		
		// Create new categories?
		var categories = [];
		if( len(trim(rc.newCategories)) ){
			categories = categoryService.createCategories( trim(rc.newCategories) );
		}
		// Inflate sent categories from collection
		categories.addAll( categoryService.inflateCategories( rc ) );
		
		// attach author
		entry.setAuthor( prc.oAuthor );
		// detach categories and re-attach
		entry.removeAllCategories().setCategories( categories );
		// save entry
		entryService.saveEntry( entry );
		
		// announce event
		announceInterception("bbadmin_postEntrySave",{entry=entry});
		
		// relocate
		getPlugin("MessageBox").info("Entry Saved!");
		setNextEvent(prc.xehEntries);
	}
	
	// remove
	function remove(event,rc,prc){
		entry = entryService.get(rc.entryID);
		if( isNull(entry) ){
			getPlugin("MessageBox").setMessage("warning","Invalid Entry detected!");
		}
		else{
			// GET id
			var entryID = entry.getEntryID();
			// announce event
			announceInterception("bbadmin_preEntryRemove",{entry=entry});
			// remove it
			entryService.delete( entry );
			// announce event
			announceInterception("bbadmin_postEntryRemove",{entryID=entryID});
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
		if( arguments.max eq 0 ){ arguments.max = prc.bbSettings.bb_paging_maxrows; }
		
		// paging default
		event.paramValue("page",1);
		
		// exit handlers
		rc.xehPager 		= "#prc.bbEntryPoint#.entries.pager";
		rc.xehEntryEditor	= "#prc.bbEntryPoint#.entries.editor";
		rc.xehEntryQuickLook= "#prc.bbEntryPoint#.entries.quickLook";
		
		// prepare paging plugin
		rc.pager_pagingPlugin 	= getMyPlugin(plugin="Paging",module="blogbox");
		rc.pager_paging 	  	= rc.pager_pagingPlugin.getBoundaries();
		rc.pager_pagingLink 	= "javascript:pagerLink(@page@)";
		rc.pager_pagination		= arguments.pagination;
		
		// search entries with filters and all
		var entryResults = entryService.search(author=arguments.authorID,
											   offset=rc.pager_paging.startRow-1,
											   max=arguments.max);
		rc.pager_entries 	   = entryResults.entries;
		rc.pager_entriesCount  = entryResults.count;
		
		// author in RC
		rc.pager_authorID		= arguments.authorID;
		
		// view pager
		return renderView(view="entries/pager",module="blogbox-admin");
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
		prc.xehQPEntrySave = "#prc.bbEntryPoint#.entries.save";
		// render it out
		return renderView(view="entries/quickPost",module="blogbox-admin");		
	}
}
