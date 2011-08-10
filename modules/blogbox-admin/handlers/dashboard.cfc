/**
* Admin Dashboard
*/
component extends="baseHandler"{

	// Dependencies
	property name="entryService" 	inject="id:entryService@bb";
	property name="commentService" 	inject="id:commentService@bb";
	property name="categoryService"		inject="id:categoryService@bb";
	
	function preHandler(event,action,eventArguments){
		var prc = event.getCollection(private=true);
		prc.tabDashboard	  = true;
	}

	// dashboard index
	function index(event,rc,prc){
		
		// exit Handlers
		prc.xehEntryEditor		= "#prc.bbEntryPoint#.entries.editor";
		prc.xehEntrySave			= "#prc.bbEntryPoint#.entries.save";
		prc.xehRemoveComment		= "#prc.bbEntryPoint#.comments.remove";
		prc.xehReloadModule		= "#prc.bbEntryPoint#.dashboard.reload";
		
		// Tab Manipulation
		prc.tabDashboard_home = true;
		
		// Get entries viewlet: Stupid cf9 and its local scope blown on argument literals
		var eArgs = {max=prc.bbSettings.bb_dashboard_recentEntries,pagination=false};
		prc.entriesViewlet = runEvent(event="blogbox-admin:entries.pager",eventArguments=eArgs);
		// Get Comments viewlet
		var eArgs = {max=prc.bbSettings.bb_dashboard_recentComments,pagination=false};
		prc.commentsViewlet = runEvent(event="blogbox-admin:comments.pager",eventArguments=eArgs);
		
		// Few counts
		prc.entriesCount 			= entryService.count();
		prc.commentsCount 			= commentService.count();
		prc.commentsApprovedCount 	= commentService.countWhere(isApproved=true);
		prc.commentsUnApprovedCount = prc.commentsCount-prc.commentsApprovedCount;		
		prc.categoriesCount 		= categoryService.count();
		
		// announce event
		announceInterception("bbadmin_onDashboard");
		
		// dashboard view
		event.setView("dashboard/index");
	}

	// reload modules
	function reload(event,rc,prc){
		// reload the core module first
		controller.getModuleService().reload( "blogbox" );
		// reload requested module
		controller.getModuleService().reload( rc.targetModule );
		// flash info
		flash.put("moduleReloaded",rc.targetModule);
		// relocate
		setNextEvent(prc.xehDashboard);
	}
	
}
