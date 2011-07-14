/**
* Admin Dashboard
*/
component extends="baseHandler"{

	// Dependencies
	property name="entryService" 	inject="id:entryService@bb";
	property name="commentService" 	inject="id:commentService@bb";

	// dashboard index
	function index(event,rc,prc){
		
		// exit Handlers
		rc.xehRemoveEntry		= "#rc.bbEntryPoint#.entries.remove";
		rc.xehRemoveComment		= "#rc.bbEntryPoint#.comments.remove";
		
		// Get only the latest 10 posts to display in the admin dashboard.
		rc.posts 	= entryService.list(sortOrder="createdDate desc",max=10,asQuery=false);
		rc.comments = commentService.list(sortOrder="createdDate desc",max=10,asQuery=false);
		
		// dashboard view
		event.setView("dashboard/index");
	}
	
}
