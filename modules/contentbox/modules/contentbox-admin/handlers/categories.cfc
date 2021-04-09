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
	 *
	 * @event
	 * @action
	 * @eventArguments
	 * @rc
	 * @prc
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		// Tab control
		prc.tabContent = true;
	}

	/**
	 * Manage categories
	 *
	 * @event
	 * @rc
	 * @prc
	 */
	function index( event, rc, prc ){
		// exit Handlers
		prc.xehCategoryRemove = "#prc.cbAdminEntryPoint#.categories.remove";
		prc.xehCategoriesSave = "#prc.cbAdminEntryPoint#.Categories.save";
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
	 *
	 * @event
	 * @rc
	 * @prc
	 */
	function save( event, rc, prc ){
		// slugify if not passed, and allow passed slugs to be saved as-is
		if ( NOT len( rc.slug ) ) {
			rc.slug = variables.HTMLHelper.slugify( rc.category );
		}

		// populate and get category
		var oCategory = populateModel( variables.categoryService.get( rc.categoryID ) ).setSite(
			prc.oCurrentSite
		);
		var vResults = validateModel( oCategory );

		// Validation Results
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
			cbMessagebox.warning( messageArray = vResults.getAllErrors() );
		}
		// relocate
		relocate( prc.xehCategories );
	}

	/**
	 * Remove categories
	 *
	 * @event
	 * @rc
	 * @prc
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
				var categoryID = category.getId();
				var title      = category.getSlug();
				// announce event
				announce(
					"cbadmin_preCategoryRemove",
					{ category : category, categoryID : categoryID }
				);
				// Delete category via service
				variables.categoryService.deleteCategory( category );
				arrayAppend( messages, "Category '#title#' removed" );
				// announce event
				announce( "cbadmin_postCategoryRemove", { categoryID : categoryID } );
			}
		}

		// messagebox
		cbMessagebox.info( messageArray = messages );
		relocate( prc.xehCategories );
	}

	/**
	 * Export all categories
	 *
	 * @event
	 * @rc
	 * @prc
	 */
	function exportAll( event, rc, prc ){
		event.paramValue( "format", "json" );
		// get all prepared content objects
		var data = variables.categoryService.getAllForExport();

		switch ( rc.format ) {
			case "xml":
			case "json": {
				var filename = "Categories." & ( rc.format eq "xml" ? "xml" : "json" );
				event
					.renderData(
						data        = data,
						type        = rc.format,
						xmlRootName = "categories"
					)
					.setHTTPHeader(
						name  = "Content-Disposition",
						value = " attachment; filename=#fileName#"
					);
				break;
			}
			default: {
				event.renderData( data = "Invalid export type: #rc.format#" );
			}
		}
	}

	/**
	 * Import all categories
	 *
	 * @event
	 * @rc
	 * @prc
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
