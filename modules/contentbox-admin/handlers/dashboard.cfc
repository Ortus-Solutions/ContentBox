/**
* Admin Dashboard
*/
component extends="baseHandler"{

	// Dependencies
	property name="entryService" 		inject="id:entryService@cb";
	property name="pageService" 		inject="id:pageService@cb";
	property name="commentService" 		inject="id:commentService@cb";
	property name="categoryService"		inject="id:categoryService@cb";
	
	function preHandler(event,action,eventArguments){
		var prc = event.getCollection(private=true);
		prc.tabDashboard	  = true;
	}

	// dashboard index
	function index(event,rc,prc){
		
		// exit Handlers
		prc.xehEntryEditor		= "#prc.cbAdminEntryPoint#.entries.editor";
		prc.xehEntrySave		= "#prc.cbAdminEntryPoint#.entries.save";
		prc.xehRemoveComment	= "#prc.cbAdminEntryPoint#.comments.remove";
		prc.xehReloadModule		= "#prc.cbAdminEntryPoint#.dashboard.reload";
		
		// Tab Manipulation
		prc.tabDashboard_home = true;
		
		// Get entries viewlet: Stupid cf9 and its local scope blown on argument literals
		var eArgs = {max=prc.cbSettings.cb_dashboard_recentEntries,pagination=false};
		prc.entriesViewlet = runEvent(event="contentbox-admin:entries.pager",eventArguments=eArgs);
		// Get Pages viewlet
		var eArgs = {max=prc.cbSettings.cb_dashboard_recentPages,pagination=false,latest=true};
		prc.pagesViewlet = runEvent(event="contentbox-admin:pages.pager",eventArguments=eArgs);
		// Get Comments viewlet
		var eArgs = {max=prc.cbSettings.cb_dashboard_recentComments,pagination=false};
		prc.commentsViewlet = runEvent(event="contentbox-admin:comments.pager",eventArguments=eArgs);
		
		// Few counts
		prc.entriesCount 			= entryService.count();
		prc.pagesCount 				= pageService.count();
		prc.commentsCount 			= commentService.count();
		prc.commentsApprovedCount 	= commentService.getApprovedCommentCount();
		prc.commentsUnApprovedCount = commentService.getUnApprovedCommentCount();		
		prc.categoriesCount 		= categoryService.count();
		
		// Prepare Reload Options
		prc.reloadOptions = [
			{name="Entire Application",value="app"},
			{name="ORM",value="orm"},
			{name="ContentBox Admin",value="contentbox-admin"},
			{name="ContentBox Site",value="contentbox-site"},
			{name="ContentBox FileBrowser",value="contentbox-filebrowser"}
		];
		
		// announce event
		announceInterception("cbadmin_onDashboard");
		
		// dashboard view
		event.setView("dashboard/index");
	}
	
	// about
	function about(event,rc,prc){
		prc.tabDashboard_about = true;
		event.setView("dashboard/about");
	}

	// reload modules
	function reload(event,rc,prc){
		
		switch(rc.targetModule){
			// reload application
			case "app" :{
				applicationStop();
				break;			
			}
			case "orm" :{
				ormReload();
				break;
			}
			default:{
				// reload the core module first
				controller.getModuleService().reload( "contentbox" );
				// reload requested module
				controller.getModuleService().reload( rc.targetModule );
			}
		}
		// flash info
		flash.put("moduleReloaded",rc.targetModule);
		// relocate
		setNextEvent(prc.xehDashboard);
	}
	
}
