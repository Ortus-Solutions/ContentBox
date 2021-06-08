/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage categories
 */
component extends="baseHandler" {

	// Dependencies
	property name="categoryService" inject="categoryService@cb";
	property name="HTMLHelper" inject="HTMLHelper@coldbox";

	/**
	 * Pre handler
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		prc.tabContent = true;
	}

	/**
	 * Manage categories
	 */
	function index( event, rc, prc ){
		// exit Handlers
		prc.xehCategoryRemove = "#prc.cbAdminEntryPoint#.categories.remove";
		prc.xehCategoriesSave = "#prc.cbAdminEntryPoint#.Categories.save";
		prc.xehExport         = "#prc.cbAdminEntryPoint#.Categories.export";
		prc.xehExportAll      = "#prc.cbAdminEntryPoint#.Categories.exportAll";
		prc.xehImportAll      = "#prc.cbAdminEntryPoint#.Categories.importAll";
		// Get all categories
		prc.categories        = variables.categoryService.list(
			criteria : { "site" : prc.oCurrentSite },
			sortOrder: "category",
			asQuery  : false
		);
		// Tab
		prc.tabContent_categories = true;
		// view
		event.setView( "categories/index" );
	}

	/**
	 * Save categories
	 */
	function save( event, rc, prc ){
		// slugify if not passed, and allow passed slugs to be saved as-is
		if ( NOT len( rc.slug ) ) {
			rc.slug = variables.HTMLHelper.slugify( rc.category );
		}

		// Pop/Get/Set
		var oCategory = populateModel( variables.categoryService.get( rc.categoryID ) ).setSite(
			prc.oCurrentSite
		);

		// Validation Results
		var vResults = validate( oCategory );
		if ( !vResults.hasErrors() ) {
			// announce event
			announce(
				"cbadmin_preCategorySave",
				{ category : oCategory, categoryID : rc.categoryID }
			);
			// save category
			variables.categoryService.save( oCategory );
			// announce event
			announce( "cbadmin_postCategorySave", { category : oCategory } );
			// messagebox
			cbMessagebox.setMessage( "info", "Category saved!" );
		} else {
			// messagebox
			cbMessagebox.warning( vResults.getAllErrors() );
		}
		// relocate
		relocate( prc.xehCategories );
	}

	/**
	 * Remove categories
	 */
	function remove( event, rc, prc ){
		// params
		event.paramValue( "categoryID", "" );

		// verify if contentID sent
		if ( !len( rc.categoryID ) ) {
			cbMessagebox.warn( "No categories sent to delete!" );
			relocate( event = prc.xehCategories );
		}

		// Inflate to array
		rc.categoryID = listToArray( rc.categoryID );
		var messages  = [];

		// Iterate and remove
		for ( var thisCatID in rc.categoryID ) {
			var category = variables.categoryService.get( thisCatID );
			if ( isNull( category ) ) {
				arrayAppend( messages, "Invalid categoryID sent: #thisCatID#, so skipped removal" );
			} else {
				// GET id to be sent for announcing later
				var categoryID = category.getCategoryID();
				var title      = category.getSlug();
				// announce event
				announce(
					"cbadmin_preCategoryRemove",
					{ category : category, categoryID : categoryID }
				);
				// Delete category via service
				variables.categoryService.delete( category );
				arrayAppend( messages, "Category '#title#' removed" );
				// announce event
				announce( "cbadmin_postCategoryRemove", { categoryID : categoryID } );
			}
		}

		// messagebox
		cbMessagebox.info( messages );
		relocate( prc.xehCategories );
	}

	/**
	 * Export a category
	 */
	function export( event, rc, prc ){
		return variables.categoryService.get( event.getValue( "categoryID", 0 ) ).getMemento();
	}

	/**
	 * Export all categories
	 */
	function exportAll( event, rc, prc ){
		return variables.categoryService.getAllForExport();
	}

	/**
	 * Import all categories
	 */
	function importAll( event, rc, prc ){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try {
			if ( len( rc.importFile ) and fileExists( rc.importFile ) ) {
				var importLog = variables.categoryService.importFromFile(
					importFile = rc.importFile,
					override   = rc.overrideContent
				);
				cbMessagebox.info( "Categories imported sucessfully!" );
				flash.put( "importLog", importLog );
			} else {
				cbMessagebox.error(
					"The import file is invalid: #rc.importFile# cannot continue with import"
				);
			}
		} catch ( any e ) {
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			cbMessagebox.error( errorMessage );
		}
		relocate( prc.xehCategories );
	}

}
