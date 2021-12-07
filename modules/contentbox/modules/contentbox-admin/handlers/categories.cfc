/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage categories
 */
component extends="baseHandler" {

	// Dependencies
	property name="categoryService" inject="categoryService@contentbox";
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
		prc.xehCategories = "#prc.cbAdminEntryPoint#.Categories";
		prc.xehExport     = "#prc.cbAdminEntryPoint#.Categories.export";
		prc.xehExportAll  = "#prc.cbAdminEntryPoint#.Categories.exportAll";
		prc.xehImportAll  = "#prc.cbAdminEntryPoint#.Categories.importAll";

		// Tab
		prc.tabContent_categories = true;

		// view
		event.setView( "categories/index" );
	}

	/**
	 * Search categories
	 *
	 * @return json
	 */
	function search( event, rc, prc ){
		// Params
		event
			.paramValue( "search", "" )
			.paramValue( "isPublic", "" )
			.paramValue( "page", 1 );

		// Get all categories by search
		var results = variables.categoryService.search(
			search  : rc.search,
			isPublic: len( rc.isPublic ) ? rc.isPublic : javacast( "null", "" ),
			siteId  : prc.oCurrentSite.getSiteId()
		);

		event
			.getResponse()
			.setData(
				results.categories.map( function( thisCategory ){
					return thisCategory.getMemento( excludes = "siteSnapshot:site" );
				} )
			)
			.setPagination(
				getPageOffset( rc.page ),
				getMaxRows(),
				rc.page,
				results.count
			);
	}


	/**
	 * Save categories
	 */
	function save( event, rc, prc ){
		// Params
		param rc.categoryID = "";
		param rc.slug       = "";
		param rc.category   = "";
		param rc.isPublic   = false;

		// slugify if not passed, and allow passed slugs to be saved as-is
		if ( NOT len( rc.slug ) ) {
			rc.slug = variables.HTMLHelper.slugify( rc.category );
		}

		// Pop/Get/Set
		var oCategory = populateModel( model: variables.categoryService.get( rc.categoryID ), exclude: "categoryID" ).setSite(
			prc.oCurrentSite
		);

		// Validation Results
		var vResults = validate( oCategory );
		if ( !vResults.hasErrors() ) {
			// announce event
			announce( "cbadmin_preCategorySave", { category : oCategory, categoryID : rc.categoryID } );
			// save category
			variables.categoryService.save( oCategory );
			// announce event
			announce( "cbadmin_postCategorySave", { category : oCategory } );
			// response
			event
				.getResponse()
				.setData( oCategory.getMemento() )
				.addMessage( "Category saved!" );
		} else {
			event.getResponse().setErrorMessage( vResults.getAllErrors(), 400, "Invalid data" );
		}
	}

	/**
	 * Remove categories
	 */
	function remove( event, rc, prc ){
		// Params
		param rc.categoryID = "";

		// verify if contentID sent
		if ( !len( rc.categoryID ) ) {
			return event
				.getResponse()
				.setErrorMessage(
					"No categories sent to delete",
					400,
					"Invalid Data"
				);
		}

		// Inflate to array
		rc.categoryID = isSimpleValue( rc.categoryID ) ? listToArray( rc.categoryID ) : rc.categoryID;
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
				announce( "cbadmin_preCategoryRemove", { category : category, categoryID : categoryID } );
				// Delete category via service
				variables.categoryService.delete( category );
				arrayAppend( messages, "Category '#title#' removed" );
				// announce event
				announce( "cbadmin_postCategoryRemove", { categoryID : categoryID } );
			}
		}

		// response
		event.getResponse().addMessage( messages );
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
		param rc.categoryID = "";
		// Export all or some
		if ( len( rc.categoryID ) ) {
			return rc.categoryID
				.listToArray()
				.map( function( id ){
					return variables.categoryService.get( arguments.id ).getMemento( profile: "export" );
				} );
		} else {
			return variables.categoryService.getAllForExport( prc.oCurrentSite );
		}
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
				cbMessagebox.error( "The import file is invalid: #rc.importFile# cannot continue with import" );
			}
		} catch ( any e ) {
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			cbMessagebox.error( errorMessage );
		}
		relocate( prc.xehCategories );
	}

}
