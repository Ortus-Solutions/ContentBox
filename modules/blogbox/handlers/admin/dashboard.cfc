/**
* Admin Dashboard
*/
component{

	// Dependencies
	property name="entryService" 	inject="id:entryService@bb";
	property name="commentService" 	inject="id:commentService@bb";
	
	// pre handler
	function preHandler(event,action){
		var rc = event.getCollection();
		// exit Handlers
		rc.xehBlogEditor 		= "#rc.bbEntryPoint#.admin.entries.editor";
		rc.xehRemoveEntry		= "#rc.bbEntryPoint#.admin.entries.remove";
		rc.xehRemoveComment		= "#rc.bbEntryPoint#.admin.comments.remove";
	}
	
	// dashboard index
	function index(event,rc,prc){
		// Get only the latest 10 posts to display in the admin dashboard.
		rc.posts 	= entryService.list(sortOrder="createdDate desc",max=10,asQuery=false);
		rc.comments = commentService.list(sortOrder="createdDate desc",max=10,asQuery=false);
		
		// dashboard view
		event.setView("admin/dashboard/index");
	}
	
}
