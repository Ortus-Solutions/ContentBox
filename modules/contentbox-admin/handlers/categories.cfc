/**
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
		prc.xehExportAll 		= "#prc.cbAdminEntryPoint#.Categories.exportAll";
		prc.xehCategoryImport	= "#prc.cbAdminEntryPoint#.Categories.importAll";
		
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

	// Export All CustomHTML
	function exportAll(event,rc,prc){
		event.paramValue("format", "json");
		// get all prepared content objects
		var data  = categoryService.getAllForExport();
		
		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "Categories." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=data, type=rc.format, xmlRootName="categories")
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#"); ; 
				break;
			}
			default:{
				event.renderData(data="Invalid export type: #rc.format#");
			}
		}
	}
	
	// import settings
	function importAll(event,rc,prc){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try{
			if( len( rc.importFile ) and fileExists( rc.importFile ) ){
				var importLog = categoryService.importFromFile( importFile=rc.importFile, override=rc.overrideContent );
				getPlugin("MessageBox").info( "Categories imported sucessfully!" );
				flash.put( "importLog", importLog );
			}
			else{
				getPlugin("MessageBox").error( "The import file is invalid: #rc.importFile# cannot continue with import" );
			}
		}
		catch(any e){
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			getPlugin("MessageBox").error( errorMessage );
		}
		setNextEvent( prc.xehCategories );
	}
}
