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
		
		// Get entries viewlet
		rc.entriesViewlet = runEvent(event="blogbox-admin:entries.pager",eventArguments={max=5,pagination=false});
		// get all categories for quick post
		rc.categories = categoryService.getAll(sortOrder="category");
		
		rc.comments = commentService.list(sortOrder="createdDate desc",max=5,asQuery=false);
		
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
