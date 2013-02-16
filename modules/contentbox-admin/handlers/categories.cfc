﻿/**
* Manage categories
*/
component extends="baseHandler"{

	// Dependencies
	property name="categoryService"		inject="id:categoryService@cb";
	
	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab control
		prc.tabContent = true;
	}
	
	// index
	function index(event,rc,prc){
		// exit Handlers
		prc.xehCategoryRemove 	= "#prc.cbAdminEntryPoint#.categories.remove";
		prc.xehCategoriesSave 	= "#prc.cbAdminEntryPoint#.Categories.save";
		// Get all categories
		prc.categories = categoryService.list(sortOrder="category",asQuery=false);
		// Tab
		prc.tabContent_categories = true;
		// view
		event.setView("categories/index");
	}

	// save
	function save(event,rc,prc){
		// slugify if not passed, and allow passed slugs to be saved as-is
		if( NOT len(rc.slug) ){ 
			rc.slug = getPlugin("HTMLHelper").slugify(rc.category); 
		}
		// populate and get category
		var oCategory = populateModel( categoryService.get(id=rc.categoryID) );
    	// announce event
		announceInterception("cbadmin_preCategorySave",{category=oCategory,categoryID=rc.categoryID});
		// check if category already exists
		var isSaveableCategory = rc.categoryID!="" || isNull( categoryService.findWhere( criteria={ slug=rc.category } ) ) ? true : false;
		// if non-existent
		if( isSaveableCategory ) {
			// save category
			categoryService.save( oCategory );
			// announce event
			announceInterception("cbadmin_postCategorySave",{category=oCategory});
			// messagebox
			getPlugin("MessageBox").setMessage("info","Category saved!");
		}
		else {
			// messagebox
			getPlugin("MessageBox").setMessage("warning","Category '#rc.category#' already exists!");	
		}
		// relocate
		setNextEvent(prc.xehCategories);
	}
	
	// remove
	function remove(event,rc,prc){
		// announce event
		announceInterception("cbadmin_preCategoryRemove",{categoryID=rc.categoryID});
		// delete by id
		if( !categoryService.deleteCategory( rc.categoryID ) ){
			getPlugin("MessageBox").setMessage("warning","Invalid Category detected!");
		}
		else{
			// announce event
			announceInterception("cbadmin_postCategoryRemove",{categoryID=rc.categoryID});
			// Message
			getPlugin("MessageBox").setMessage("info","Category Removed!");
		}
		setNextEvent( prc.xehCategories );
	}
}
