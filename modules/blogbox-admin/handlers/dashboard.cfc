/**
* Admin Dashboard
*/
component extends="baseHandler"{

	// Dependencies
	property name="entryService" 	inject="id:entryService@bb";
	property name="commentService" 	inject="id:commentService@bb";

	function preHandler(event,action,eventArguments){
		var prc = event.getCollection(private=true);
		prc.tabDashboard	  = true;
	}

	// dashboard index
	function index(event,rc,prc){
		
		// exit Handlers
		rc.xehRemoveEntry		= "#prc.bbEntryPoint#.entries.remove";
		rc.xehEntryEditor		= "#prc.bbEntryPoint#.entries.editor";
		rc.xehRemoveComment		= "#prc.bbEntryPoint#.comments.remove";
		rc.xehReloadModule		= "#prc.bbEntryPoint#.dashboard.reload";
		
		// Tab Manipulation
		prc.tabDashboard_home = true;
		
		// Get only the latest 10 posts to display in the admin dashboard.
		rc.posts 	= entryService.list(sortOrder="createdDate desc",max=10,asQuery=false);
		rc.comments = commentService.list(sortOrder="createdDate desc",max=10,asQuery=false);
		
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
