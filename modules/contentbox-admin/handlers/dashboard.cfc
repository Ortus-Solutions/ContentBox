/**
* Admin Dashboard
*/
component extends="baseHandler"{

	// Dependencies
	property name="entryService" 	inject="id:entryService@cb";
	property name="commentService" 	inject="id:commentService@cb";
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
		prc.commentsCount 			= commentService.count();
		prc.commentsApprovedCount 	= commentService.countWhere(isApproved=true);
		prc.commentsUnApprovedCount = prc.commentsCount-prc.commentsApprovedCount;		
		prc.categoriesCount 		= categoryService.count();
		
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
		// reload the core module first
		controller.getModuleService().reload( "contentbox" );
		// reload requested module
		controller.getModuleService().reload( rc.targetModule );
		// flash info
		flash.put("moduleReloaded",rc.targetModule);
		// relocate
		setNextEvent(prc.xehDashboard);
	}
	
	function template(event,rc,prc){ event.setView(view="dashboard/template",nolayout=true); }
	
}
