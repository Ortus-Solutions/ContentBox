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
		rc.xehEntryEditor		= "#prc.bbEntryPoint#.entries.editor";
		rc.xehEntrySave			= "#prc.bbEntryPoint#.entries.save";
		rc.xehRemoveComment		= "#prc.bbEntryPoint#.comments.remove";
		rc.xehReloadModule		= "#prc.bbEntryPoint#.dashboard.reload";
		
		// Tab Manipulation
		prc.tabDashboard_home = true;
		
		// Get entries viewlet: Stupid cf9 and its local scope blown on argument literals
		var eArgs = {max=prc.bbSettings.bb_dashboard_recentEntries,pagination=false};
		rc.entriesViewlet = runEvent(event="blogbox-admin:entries.pager",eventArguments=eArgs);
		// Get Comments viewlet
		var eArgs = {max=prc.bbSettings.bb_dashboard_recentComments,pagination=false};
		rc.commentsViewlet = runEvent(event="blogbox-admin:comments.pager",eventArguments=eArgs);
		
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
		setNextEvent(rc.xehDashboard);
	}
	
}
