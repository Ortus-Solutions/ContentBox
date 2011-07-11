/**
* Manage comments
*/
component{

	// Dependencies
	property name="commentService"		inject="id:commentService@bb";

	// pre handler
	function preHandler(event,action){
		var rc = event.getCollection();
		// exit Handlers
		rc.xehComments 			= "#rc.bbEntryPoint#.admin.comments";
		rc.xehCommentEditor 	= "#rc.bbEntryPoint#.admin.comments.editor";
		rc.xehCommentRemove 	= "#rc.bbEntryPoint#.admin.comments.remove";
		rc.xehCommentApprove 	= "#rc.bbEntryPoint#.admin.comments.approve";
		rc.xehCommentUnapprove	= "#rc.bbEntryPoint#.admin.comments.unapprove";
	}
	
	// index
	function index(event,rc,prc){
		// comments
		rc.comments = commentService.list(sortOrder="createdDate desc",asQuery=false);
		// display
		event.setView("admin/comments/index");
	}

	// editor
	function editor(event,rc,prc){
		// get new or persisted
		rc.category  = categoryService.get( event.getValue("CategoryID",0) );
		// exit handlers
		rc.xehCategoriesSave = "#rc.bbEntryPoint#.admin.Categories.save";
		// view
		event.setView("admin/categories/editor");
	}	

	// save
	function save(event,rc,prc){
		// slugify if not passed
		if( NOT len(rc.slug) ){ rc.slug = rc.category; }
		rc.slug = getPlugin("HTMLHelper").slugify(rc.category);
		// populate and get category
		var oCategory = populateModel( categoryService.get(id=rc.categoryID) );
    	// save category
		categoryService.save( oCategory );
		// messagebox
		getPlugin("MessageBox").setMessage("info","Category saved!");
		// relocate
		setNextEvent(rc.xehCategories);
	}
	
	// remove
	function remove(event,rc,prc){
		var oCategory	= categoryService.get( rc.categoryID );
    	
		if( isNull(oCategory) ){
			getPlugin("MessageBox").setMessage("warning","Invalid Category detected!");
			setNextEvent( rc.xehCategories );
		}
		
		categoryService.delete( oCategory );
		
		getPlugin("MessageBox").setMessage("info","Category Removed!");
		
		setNextEvent(rc.xehCategories);
	}
}
