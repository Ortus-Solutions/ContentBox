/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manage categories
*/
component extends="baseHandler"{

	// Dependencies
	property name="categoryService"		inject="id:categoryService@cb";
	property name="HTMLHelper"			inject="HTMLHelper@coldbox";

	
	// pre handler
	function preHandler( event, action, eventArguments, rc, prc ){
	}
	
	// index
	function index(event,rc,prc){
		// exit Handlers
		prc.xehCategoryRemove 	= "#prc.cbAdminEntryPoint#.categories.remove";
		prc.xehCategoriesSave 	= "#prc.cbAdminEntryPoint#.Categories.save";
		prc.xehExportAll 		= "#prc.cbAdminEntryPoint#.Categories.exportAll";
		prc.xehImportAll		= "#prc.cbAdminEntryPoint#.Categories.importAll";
		
		// Get all categories
		prc.categories = categoryService.list(sortOrder="category",asQuery=false);
		// view
		event.setView( "categories/index" );
	}

	// save
	function save(event,rc,prc){
		// slugify if not passed, and allow passed slugs to be saved as-is
		if( NOT len(rc.slug) ){ 
			rc.slug = HTMLHelper.slugify(rc.category); 
		}
		// populate and get category
		var oCategory = populateModel( categoryService.get(id=rc.categoryID) );
    	// announce event
		announceInterception( "cbadmin_preCategorySave",{category=oCategory,categoryID=rc.categoryID} );
		// check if category already exists
		var isSaveableCategory = rc.categoryID!="" || isNull( categoryService.findWhere( criteria={ slug=rc.category } ) ) ? true : false;
		// if non-existent
		if( isSaveableCategory ) {
			// save category
			categoryService.save( oCategory );
			// announce event
			announceInterception( "cbadmin_postCategorySave",{category=oCategory} );
			// messagebox
			cbMessagebox.setMessage( "info","Category saved!" );
		}
		else {
			// messagebox
			cbMessagebox.setMessage( "warning","Category '#rc.category#' already exists!" );	
		}
		// relocate
		setNextEvent(prc.xehCategories);
	}
	
	// remove
	function remove(event,rc,prc){
		// params
		event.paramValue( "categoryID", "" );
		
		// verify if contentID sent
		if( !len( rc.categoryID ) ){
			cbMessagebox.warn( "No categories sent to delete!" );
			setNextEvent(event=prc.xehCategories);
		}
		
		// Inflate to array
		rc.categoryID = listToArray( rc.categoryID );
		var messages = [];
		
		// Iterate and remove
		for( var thisCatID in rc.categoryID ){
			var category = categoryService.get( thisCatID );
			if( isNull( category ) ){
				arrayAppend( messages, "Invalid categoryID sent: #thisCatID#, so skipped removal" );
			}
			else{
				// GET id to be sent for announcing later
				var categoryID 	= category.getCategoryID();
				var title		= category.getSlug();
				// announce event
				announceInterception( "cbadmin_preCategoryRemove", { category=category, categoryID=categoryID } );
				// Delete category via service
				categoryService.deleteCategory( category ); 
				arrayAppend( messages, "Category '#title#' removed" );
				// announce event
				announceInterception( "cbadmin_postCategoryRemove", { categoryID=categoryID } );
			}
		}
		
		// messagebox
		cbMessagebox.info(messageArray=messages);
		setNextEvent( prc.xehCategories );
	}

	// Export All categories
	function exportAll(event,rc,prc){
		event.paramValue( "format", "json" );
		// get all prepared content objects
		var data  = categoryService.getAllForExport();
		
		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "Categories." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=data, type=rc.format, xmlRootName="categories" )
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#" ); ; 
				break;
			}
			default:{
				event.renderData(data="Invalid export type: #rc.format#" );
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
				cbMessagebox.info( "Categories imported sucessfully!" );
				flash.put( "importLog", importLog );
			}
			else{
				cbMessagebox.error( "The import file is invalid: #rc.importFile# cannot continue with import" );
			}
		}
		catch(any e){
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			cbMessagebox.error( errorMessage );
		}
		setNextEvent( prc.xehCategories );
	}
}
