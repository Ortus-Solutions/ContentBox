/**
* Manage blog entries
*/
component{

	// Dependencies
	property name="categoryService"		inject="entityService:bbCategory";
	property name="entryService"		inject="id:entryService@bb";

	// pre handler
	function preHandler(event,action){
		var rc = event.getCollection();
		// exit Handlers
		rc.xehCategories 		= "#rc.bbEntryPoint#.admin.categories";
		rc.xehCategoryEditor 	= "#rc.bbEntryPoint#.admin.categories.editor";
		rc.xehCategoryRemove 	= "#rc.bbEntryPoint#.admin.categories.remove";
	}
	
	// index
	function index(event,rc,prc){
		// get all categories
		rc.categories = categoryService.getAll(sortOrder="category desc");
		// get all entries
		rc.categories = entryService.list(sortOrder="publishedDate desc");
		// view
		event.setView("admin/entries/index");
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
