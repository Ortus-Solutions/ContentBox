/**
* Manage blog entries
*/
component extend="BaseHandler"{

	// Dependencies
	property name="categoryService"		inject="id:categoryService@bb";
	property name="entryService"		inject="id:entryService@bb";

	// pre handler
	function preHandler(event,action){
		var rc = event.getCollection();
		// exit Handlers
		rc.xehEntries 		= "#rc.bbEntryPoint#.admin.entries";
		rc.xehEntryEditor 	= "#rc.bbEntryPoint#.admin.entries.editor";
		rc.xehEntryRemove 	= "#rc.bbEntryPoint#.admin.entries.remove";
	}
	
	// index
	function index(event,rc,prc){
		// get all categories
		rc.categories = categoryService.getAll(sortOrder="category desc");
		// get all entries
		rc.entries = entryService.list(sortOrder="publishedDate desc",asQuery=false);
		// view
		event.setView("admin/entries/index");
	}

	// editor
	function editor(event,rc,prc){
		// get all categories
		rc.categories = categoryService.getAll(sortOrder="category desc");
		// get new or persisted
		rc.entry  = entryService.get( event.getValue("entryID",0) );
		// exit handlers
		rc.xehEntrySave = "#rc.bbEntryPoint#.admin.entries.save";
		// view
		event.setView("admin/entries/editor");
	}	

	// save
	function save(event,rc,prc){
		// params
		event.paramValue("allowComments",false);
		event.paramValue("slug","");
		
		// slugify the incoming title or slug
		if( NOT len(rc.slug) ){ rc.slug = rc.title; }
		rc.slug = getPlugin("HTMLHelper").slugify( rc.slug );
		
		// Create new categories?
		var categories = [];
		if( len(trim(rc.newCategories)) ){
			categories = categoryService.createCategories( trim(rc.newCategories) );
		}
		// Inflate sent categories from collection
		categories.addAll( categoryService.inflateCategories( rc ) );
		
		// get new entry and populate it
		var entry = populateModel( entryService.new() ).addPublishedtime(rc.publishedHour,rc.publishedMinute);
		
		writeDump(entry);abort;
		
		// relocate
		setNextEvent(rc.xehEntries);
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
