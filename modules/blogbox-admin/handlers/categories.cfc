/**
* Manage categories
*/
component extends="baseHandler"{

	// Dependencies
	property name="categoryService"		inject="id:categoryService@bb";
	
	// index
	function index(event,rc,prc){
		// exit Handlers
		rc.xehCategoryRemove 	= "#rc.bbEntryPoint#.categories.remove";
		rc.xehCategoriesSave 	= "#rc.bbEntryPoint#.Categories.save";
		
		// Get all categories
		rc.categories = categoryService.list(sortOrder="category desc",asQuery=false);
		// view
		event.setView("categories/index");
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
		// delete by id
		if( !categoryService.deleteByID( rc.categoryID ) ){
			getPlugin("MessageBox").setMessage("warning","Invalid Category detected!");
		}
		else{
			getPlugin("MessageBox").setMessage("info","Category Removed!");
		}
		setNextEvent( rc.xehCategories );
	}
}
