/**
* Manage blog pages
*/
component extends="baseHandler"{

	// Dependencies
	property name="pageService"			inject="id:pageService@cb";
	property name="authorService"		inject="id:authorService@cb";
	property name="layoutService"		inject="id:layoutService@cb";
	
	// Public properties
	this.preHandler_except = "pager";

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// exit Handlers
		prc.xehPages 		= "#prc.cbAdminEntryPoint#.pages";
		prc.xehPageEditor 	= "#prc.cbAdminEntryPoint#.pages.editor";
		prc.xehPageRemove 	= "#prc.cbAdminEntryPoint#.pages.remove";
		// Tab control
		prc.tabContent = true;
	}
	
	// index
	function index(event,rc,prc){
		// params
		event.paramValue("page",1);
		event.paramValue("searchPages","");
		event.paramValue("fAuthors","all");
		event.paramValue("fStatus","any");
		event.paramValue("isFiltering",false,true);
		event.paramValue("parent","");
		
		// prepare paging plugin
		prc.pagingPlugin = getMyPlugin(plugin="Paging",module="contentbox");
		prc.paging 		 = prc.pagingPlugin.getBoundaries();
		prc.pagingLink 	 = event.buildLink('#prc.xehPages#?page=@page@');
		// Append search to paging link?
		if( len(rc.searchPages) ){ prc.pagingLink&="&searchPages=#rc.searchPages#"; }
		// Append filters to paging link?
		if( rc.fAuthors neq "all"){ prc.pagingLink&="&fAuthors=#rc.fAuthors#"; }
		if( rc.fStatus neq "any"){ prc.pagingLink&="&fStatus=#rc.fStatus#"; }
		// is Filtering?
		if( rc.fAuthors neq "all" OR rc.fStatus neq "any"){ prc.isFiltering = true; }
		
		// get all authors
		prc.authors    = authorService.getAll(sortOrder="lastName");
		
		// search entries with filters and all
		var pageResults = pageService.search(search=rc.searchPages,
											 offset=prc.paging.startRow-1,
											 max=prc.cbSettings.cb_paging_maxrows,
											 isPublished=rc.fStatus,
											 author=rc.fAuthors,
											 parent=rc.parent);
		prc.pages 		= pageResults.pages;
		prc.pagesCount  = pageResults.count;
		
		// Do we have a parent?
		if( len(rc.parent) ){
			prc.page = pageService.get( rc.parent );
		}
		
		// exit handlers
		prc.xehPageSearch 	= "#prc.cbAdminEntryPoint#.pages";
		prc.xehPageQuickLook= "#prc.cbAdminEntryPoint#.pages.quickLook";
		prc.xehPageOrder 	= "#prc.cbAdminEntryPoint#.pages.changeOrder";
		
		// Tab
		prc.tabContent_viewAll = true;
		// view
		event.setView("pages/index");
	}
	
	// Quick Look
	function quickLook(event,rc,prc){
		// get entry
		prc.page  = pageService.get( event.getValue("pageID",0) );
		event.setView(view="pages/quickLook",layout="ajax");
	}
	
	// editor
	function editor(event,rc,prc){
		// get new or persisted
		prc.page  = pageService.get( event.getValue("pageID",0) );
		// load comments viewlet if persisted
		if( prc.page.isLoaded() ){
			// Get Comments viewlet
			prc.commentsViewlet = runEvent(event="contentbox-admin:comments.pager",eventArguments={pageID=rc.pageID});
			// Get Child Pages Viewlet
			prc.childPagesViewlet = pager(event=arguments.event,rc=arguments.rc,prc=arguments.prc,parent=prc.page.getPageID());
		}
		// Get all pages for parent drop downs
		prc.pages = pageService.list(sortOrder="title asc");		
		// Get active layout record and available page only layouts
		prc.themeRecord = layoutService.getActiveLayout();
		prc.availableLayouts = REreplacenocase( prc.themeRecord.layouts,"blog,?","");
		// Get parent from active page
		prc.parentPageID = prc.page.getParentID();
		// Override the parent page if incoming
		if( structKeyExistS(rc,"parentID") ){
			prc.parentPageID = rc.parentID;
		}
		
		// exit handlers
		prc.xehPageSave 		= "#prc.cbAdminEntryPoint#.pages.save";
		prc.xehSlugify			= "#prc.cbAdminEntryPoint#.pages.slugify";
		prc.xehWidgetSelector  	= "#prc.cbAdminEntryPoint#.widgets.editorselector";

		// Tab
		prc.tabContent_viewAll = true;
		// view
		event.setView("pages/editor");
	}	

	// save
	function save(event,rc,prc){
		// params
		event.paramValue("allowComments",prc.cbSettings.cb_comments_enabled);
		event.paramValue("isPublished",true);
		event.paramValue("slug","");
		event.paramValue("publishedDate",now());
		event.paramValue("publishedHour", timeFormat(rc.publishedDate,"HH"));
		event.paramValue("publishedMinute", timeFormat(rc.publishedDate,"mm"));
		event.paramValue("customFieldKeys","");
		event.paramValue("customFieldValues","");
		
		// slugify the incoming title or slug
		if( NOT len(rc.slug) ){ rc.slug = rc.title; }
		rc.slug = getPlugin("HTMLHelper").slugify( rc.slug );
		
		// get new/persisted entry and populate it
		var page 	= populateModel( pageService.get(rc.pageID) ).addPublishedtime(rc.publishedHour,rc.publishedMinute);
		var isNew 	= (NOT page.isLoaded());
		
		// Validate it
		var errors = page.validate();
		if( arrayLen(errors) ){
			getPlugin("MessageBox").warn(messageArray=errors);
			editor(argumentCollection=arguments);
			return;
		}
		
		// announce event
		announceInterception("cbadmin_prePageSave",{page=page,isNew=isNew});
		
		// attach author
		page.setAuthor( prc.oAuthor );
		// attach parent page
		if( len(rc.parentPage) ){ page.setParent( pageService.get( rc.parentPage ) ); }
		// Inflate Custom Fields into the page
		page.inflateCustomFields( rc.customFieldKeys, rc.customFieldValues );
		
		// save entry
		pageService.savePage( page );
		
		// announce event
		announceInterception("cbadmin_postPageSave",{page=page,isNew=isNew});
		
		// relocate
		getPlugin("MessageBox").info("Page Saved!");
		setNextEvent(prc.xehPages);
	}
	
	// remove
	function remove(event,rc,prc){
		var page = pageService.get(rc.pageID);
		if( isNull( page ) ){
			getPlugin("MessageBox").setMessage("warning","Invalid Page detected!");
		}
		else{
			// GET id
			var pageID = page.getPageID();
			// announce event
			announceInterception("cbadmin_prePageRemove",{page=page});
			// remove it
			pageService.delete( page );
			// announce event
			announceInterception("cbadmin_postPageRemove",{pageID=pageID});
			// messagebox
			getPlugin("MessageBox").setMessage("info","Page Removed!");
		}
		setNextEvent( prc.xehPages );
	}
	
	// order change
	function changeOrder(event,rc,prc){
		var results = false;
		var page = pageService.get(rc.pageID);
		if( !isNull( page ) ){
			page.setOrder( rc.order );
			pageService.savePage( page );
			results = true;
		}
		
		event.renderData(type="json",data=results);
	}
	
	// pager viewlet
	function pager(event,rc,prc,authorID="all",parent="",max=0,pagination=true,latest=false){
		
		// check if authorID exists in rc to do an override, maybe it's the paging call
		if( event.valueExists("pager_authorID") ){
			arguments.authorID = rc.pager_authorID;
		}
		// check if parent exists in rc to do an override, maybe it's the paging call
		if( event.valueExists("pager_parentID") ){
			arguments.parent = rc.pager_parentID;
		}
		// check if pagination exists in rc to do an override, maybe it's the paging call
		if( event.valueExists("pagePager_pagination") ){
			arguments.pagination = rc.pagePager_pagination;
		}
		
		// Max rows incoming or take default for pagination.
		if( arguments.max eq 0 ){ arguments.max = prc.cbSettings.cb_paging_maxrows; }
		
		// paging default
		event.paramValue("page",1);
		
		// exit handlers
		prc.xehPagePager 		= "#prc.cbAdminEntryPoint#.pages.pager";
		prc.xehPageEditor		= "#prc.cbAdminEntryPoint#.pages.editor";
		prc.xehPageQuickLook	= "#prc.cbAdminEntryPoint#.pages.quickLook";
		prc.xehPageOrder		= "#prc.cbAdminEntryPoint#.pages.changeOrder";
		
		// prepare paging plugin
		prc.pagePager_pagingPlugin 	= getMyPlugin(plugin="Paging",module="contentbox");
		prc.pagePager_paging 	  	= prc.pagePager_pagingPlugin.getBoundaries();
		prc.pagePager_pagingLink 	= "javascript:pagerLink(@page@)";
		prc.pagePager_pagination	= arguments.pagination;
		
		// Sorting
		var sortOrder = "title asc";
		if( arguments.latest ){ sortOrder = "publishedDate desc"; }
		
		// search entries with filters and all
		var pageResults = pageService.search(author=arguments.authorID,
											 parent=arguments.parent,
											 offset=prc.pagePager_paging.startRow-1,
											 max=arguments.max,
											 sortOrder=sortOrder);
											 
		prc.pager_pages 	  = pageResults.pages;
		prc.pager_pagesCount  = pageResults.count;
		
		// author in RC
		prc.pagePager_authorID	= arguments.authorID;
		
		// parent in RC
		prc.pagePager_parentID = arguments.parent;
		
		// view pager
		return renderView(view="pages/pager",module="contentbox-admin");
	}
	
	// slugify remotely
	function slugify(event,rc,prc){
		event.renderData(data=getPlugin("HTMLHelper").slugify( rc.slug ),type="plain");
	}

}
