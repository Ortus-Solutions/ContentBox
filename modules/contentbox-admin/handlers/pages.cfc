/**
* Manage blog pages
*/
component extends="baseHandler"{

	// Dependencies
	property name="pageService"			inject="id:pageService@cb";
	property name="authorService"		inject="id:authorService@cb";
	property name="layoutService"		inject="id:layoutService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";

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
		prc.xehPageHistory 	= "#prc.cbAdminEntryPoint#.versions.index";

		// Tab
		prc.tabContent_viewAll = true;
		// view
		event.setView("pages/index");
	}

	// Quick Look
	function quickLook(event,rc,prc){
		// get entry
		prc.page  = pageService.get( event.getValue("contentID",0) );
		event.setView(view="pages/quickLook",layout="ajax");
	}

	// editor
	function editor(event,rc,prc){
		// cb helper
		prc.cbHelper = CBHelper;
		// CK Editor Helper
		prc.ckHelper = getMyPlugin(plugin="CKHelper",module="contentbox-admin");
		// get new or persisted
		prc.page  = pageService.get( event.getValue("contentID",0) );
		// load comments viewlet if persisted
		if( prc.page.isLoaded() ){
			var args = {contentID=rc.contentID};
			// Get Comments viewlet
			prc.commentsViewlet = runEvent(event="contentbox-admin:comments.pager",eventArguments=args);
			// Get Child Pages Viewlet
			prc.childPagesViewlet = pager(event=arguments.event,rc=arguments.rc,prc=arguments.prc,parent=prc.page.getContentID());
			// Get Versions Viewlet
			prc.versionsViewlet = runEvent(event="contentbox-admin:versions.pager",eventArguments=args);
		}
		// Get all pages for parent drop downs
		prc.pages = pageService.list(sortOrder="title asc");
		// Get active layout record and available page only layouts
		prc.themeRecord = layoutService.getActiveLayout();
		prc.availableLayouts = REreplacenocase( prc.themeRecord.layouts,"blog,?","");
		// Get parent from active page
		prc.parentcontentID = prc.page.getParentID();
		// Override the parent page if incoming
		if( structKeyExistS(rc,"parentID") ){
			prc.parentcontentID = rc.parentID;
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
		event.paramValue("changelog","");
		event.paramValue("publishedDate",now());
		event.paramValue("publishedHour", timeFormat(rc.publishedDate,"HH"));
		event.paramValue("publishedMinute", timeFormat(rc.publishedDate,"mm"));
		event.paramValue("customFieldKeys","");
		event.paramValue("customFieldValues","");
		
		// Quick save changelog
		if( event.isAjax() ){
			rc.changelog = "Quick save";	
		}
		
		// slugify the incoming title or slug
		if( NOT len(rc.slug) ){ rc.slug = rc.title; }
		rc.slug = getPlugin("HTMLHelper").slugify( rc.slug );

		// get new/persisted page and populate it with incoming data.
		var page  = populateModel( pageService.get(rc.contentID) ).addPublishedtime(rc.publishedHour,rc.publishedMinute);
		var isNew = (NOT page.isLoaded());
		
		// Validate Page And Incoming Data
		var errors = page.validate();
		if( !len(trim(rc.content)) ){
			arrayAppend(errors, "Please enter the content to save!");
		}
		if( arrayLen(errors) ){
			getPlugin("MessageBox").warn(messageArray=errors);
			editor(argumentCollection=arguments);
			return;
		}
		
		// Register a new content in the page, versionized!
		page.addNewContentVersion(content=rc.content,changelog=rc.changelog,author=prc.oAuthor); 
		// attach parent page
		if( len(rc.parentPage) ){ page.setParent( pageService.get( rc.parentPage ) ); }
		// Inflate Custom Fields into the page
		page.inflateCustomFields( rc.customFieldKeys, rc.customFieldValues );
		
		// announce event
		announceInterception("cbadmin_prePageSave",{page=page,isNew=isNew});
		
		// save entry
		pageService.savePage( page );

		// announce event
		announceInterception("cbadmin_postPageSave",{page=page,isNew=isNew});

		// Ajax?
		if( event.isAjax() ){
			var rData = {
				contentID = page.getContentID()
			};
			event.renderData(type="json",data=rData);
		}
		else{
			// relocate
			getPlugin("MessageBox").info("Page Saved!");
			if( page.hasParent() ){
				setNextEvent(event=prc.xehPages,querystring="parent=#page.getParent().getContentID()#");
			}
			else{
				setNextEvent(event=prc.xehPages);
			}
		}
	}

	// remove
	function remove(event,rc,prc){
		event.paramValue("parent","");
		var page = pageService.get(rc.contentID);
		
		if( isNull( page ) ){
			getPlugin("MessageBox").setMessage("warning","Invalid Page detected!");
		}
		else{
			// GET id
			var contentID = page.getContentID();
			// announce event
			announceInterception("cbadmin_prePageRemove",{page=page});
			// remove it
			pageService.delete( page );
			// announce event
			announceInterception("cbadmin_postPageRemove",{contentID=contentID});
			// messagebox
			getPlugin("MessageBox").setMessage("info","Page Removed!");
		}
		if( len(rc.parent) ){
			setNextEvent(event=prc.xehPages,queryString="parent=#rc.parent#");
		}
		else{
			setNextEvent(event=prc.xehPages);
		}
	}

	// change order for all pages
	function changeOrder(event,rc,prc){
		event.paramValue("tableID","pages");
		event.paramValue("newRulesOrder","");
		rc.newRulesOrder = ReplaceNoCase(rc.newRulesOrder, "&#rc.tableID#[]=", ",", "all");
		rc.newRulesOrder = ReplaceNoCase(rc.newRulesOrder, "#rc.tableID#[]=,", "", "all");
		for(var i=1;i lte listLen(rc.newRulesOrder);i++) {
			contentID = listGetAt(rc.newRulesOrder,i);
			var page = pageService.get(contentID);
			if( !isNull( page ) ){
				page.setOrder( i );
				pageService.savePage( page );
			}
		}
		event.renderData(type="json",data='true');
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
		prc.xehPageHistory		= "#prc.cbAdminEntryPoint#.versions.index";

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
