/**
* Manage blog entries
*/
component extends="baseHandler"{

	// Dependencies
	property name="categoryService"		inject="id:categoryService@bb";
	property name="entryService"		inject="id:entryService@bb";

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// exit Handlers
		rc.xehEntries 		= "#prc.bbEntryPoint#.entries";
		rc.xehEntryEditor 	= "#prc.bbEntryPoint#.entries.editor";
		rc.xehEntryRemove 	= "#prc.bbEntryPoint#.entries.remove";
		// Tab control
		prc.tabEntries = true;
	}
	
	// index
	function index(event,rc,prc){
		// get all categories
		rc.categories = categoryService.getAll(sortOrder="category desc");
		// get all entries
		rc.entries = entryService.list(sortOrder="publishedDate desc",asQuery=false);
		// view
		event.setView("entries/index");
	}

	// editor
	function editor(event,rc,prc){
		// get all categories
		rc.categories = categoryService.getAll(sortOrder="category desc");
		// get new or persisted
		rc.entry  = entryService.get( event.getValue("entryID",0) );
		// exit handlers
		rc.xehEntrySave = "#prc.bbEntryPoint#.entries.save";
		// view
		event.setView("entries/editor");
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
		// attach author
		entry.setAuthor( prc.oAuthor );
		// detach categories and re-attach
		entry.removeAllCategories();
		entry.setCategories( categories );
		
		// save entry
		entryService.save( entry );
		
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
