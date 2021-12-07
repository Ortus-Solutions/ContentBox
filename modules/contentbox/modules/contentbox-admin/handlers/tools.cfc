/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Tools for ContentBox.
 */
component extends="baseHandler" {

	// DI
	property name="moduleService" inject="moduleService@contentbox";
	property name="themeService" inject="themeService@contentbox";
	property name="widgetService" inject="widgetService@contentbox";
	property name="roleService" inject="roleService@contentbox";
	property name="templateService" inject="emailtemplateService@contentbox";
	property name="HTMLHelper" inject="HTMLHelper@coldbox";
	property name="staticExporter" inject="staticExporter@contentbox";

	// pre handler
	function preHandler( event, action, eventArguments, rc, prc ){
		// Tab control
		prc.tabTools = true;
	}

	/**
	 * Import Into ContentBox
	 */
	function importer( event, rc, prc ){
		// Exit Handler
		rc.xehDataImport    = "#prc.cbAdminEntryPoint#.tools.doDataImport";
		rc.xehCBPreImport   = "#prc.cbAdminEntryPoint#.tools.doCBPreImport";
		rc.xehCBImport      = "#prc.cbAdminEntryPoint#.tools.doCBImport";
		// tab
		prc.tabTools_import = true;
		prc.roles           = roleService.list( sortOrder = "role" );
		// view
		event.setView( "tools/importer" );
	}

	/**
	 * Pre Import checks
	 */
	function doCBPreImport( event, rc, prc ){
		event.paramValue( "CBUpload", "" );
		// make sure upload was valid
		if ( len( rc.CBUpload ) && fileExists( rc.CBUpload ) ) {
			var importer = getInstance( "ContentBoxImporter@contentbox" );
			importer.setup( importFile = rc.CBUpload );
			// check validity of package
			if ( importer.isValid() ) {
				prc.contents            = deserializeJSON( importer.getDescriptorContents() );
				// railo and acf dates don't get along...let's normalize them first
				var badDateRegex        = " -\d{4}$";
				prc.contents.exportDate = reReplace( prc.contents.exportDate, badDateRegex, "" );
			} else {
				cbMessagebox.warn(
					"Sorry, the imported ContentBox package was not valid. Please verify you have the right file and try again."
				);
			}
		} else {
			cbMessagebox.error(
				"Sorry, there was a problem verifying your ContentBox import package. Please try again."
			);
		}
		event.setView( view = "tools/importerPreview", layout = "ajax" );
	}

	/**
	 * Import action
	 */
	function doCBImport( event, rc, prc ){
		event.paramValue( "CBUpload", "" );
		event.paramValue( "overwrite", false );

		try {
			if ( len( rc.CBUpload ) and fileExists( rc.CBUpload ) ) {
				var importer = getInstance( "ContentBoxImporter@contentbox" );
				importer.setup( importFile = rc.CBUpload );
				// already validated, so just process the import
				var importLog = importer.execute( overrideContent = rc.overwrite );
				cbMessagebox.info( "ContentBox package imported sucessfully! Please check out your ContentBox now!" );
				flash.put( "importLog", importLog );
			} else {
				cbMessagebox.error( "The ContentBox package is invalid. Please try again." );
			}
		} catch ( any e ) {
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			cbMessagebox.error( errorMessage );
		}
		relocate( prc.xehToolsImport );
	}

	/**
	 * Do a data import
	 */
	function doDataImport( event, rc, prc ){
		event.paramValue( "dsn", "" );
		event.paramValue( "dsnUsername", "" );
		event.paramValue( "dsnPassword", "" );
		event.paramValue( "defaultPassword", "" );
		event.paramValue( "tableprefix", "" );
		event.paramValue( "roleID", "" );

		setting requesttimeout="18000";

		// validate
		if ( !len( rc.dsn ) or !len( rc.defaultPassword ) ) {
			cbMessagebox.warn( "Please fill out all required fields." );
			relocate( prc.xehToolsImport );
		}

		try {
			// get importer
			var importer = getInstance( "#rc.importer#Importer@contentbox" );
			importer.execute( argumentCollection = rc );
			cbMessagebox.info( "Content imported successfully! Please check out your ContentBox now!" );
		} catch ( any e ) {
			cbMessagebox.error( "Error importing from datasource: #e.message# #e.detail#" );
		}

		relocate( prc.xehToolsImport );
	}

	/**
	 * Show the exporter console
	 */
	function exporter( event, rc, prc ){
		// Exit Handlers
		prc.xehExport        = "#prc.cbAdminEntryPoint#.tools.doExport";
		prc.xehPreviewExport = "#prc.cbAdminEntryPoint#.tools.previewExport";
		prc.xehSiteGenerator = "#prc.cbAdminEntryPoint#.tools.doStaticSite";

		// tab
		prc.tabTools_export = true;
		prc.modules         = variables.moduleService.findModules( moduleType = "custom" ).modules;
		prc.themes          = variables.themeService.getCustomThemes();
		prc.widgets         = variables.widgetService.getWidgets();
		prc.widgetService   = variables.widgetService;

		// view
		event.setView( "tools/exporter" );
	}

	/**
	 * Preview of the export
	 */
	function previewExport( event, rc, prc ){
		// get targets
		var targets            = prepareExportTargets( rc );
		var contentBoxExporter = getInstance( "ContentBoxExporter@contentbox" );
		// build up exporter instance from targets in rc
		prc.descriptor         = contentBoxExporter.setup( targets ).getDescriptor();
		// Sort the content
		prc.aSortedContent     = structSort( prc.descriptor.content, "text", "asc", "name" );
		// render back the descriptor data as json
		event.setView( view = "tools/exporterPreview", layout = "ajax" );
	}

	/**
	 * Process a real export
	 */
	function doExport( event, rc, prc ){
		// get targets
		var targets            = prepareExportTargets( rc );
		var contentBoxExporter = getInstance( "ContentBoxExporter@contentbox" );
		var exportResult       = contentBoxExporter.setup( targets ).export();
		// export the content
		var exportFilePath     = exportResult.exportfile;
		// save success message
		var filename           = variables.HTMLHelper.slugify( prc.oCurrentSite.getName() );
		// send it
		event.sendFile(
			file      : exportFilePath,
			name      : fileName,
			mimetype  : "application/zip",
			abortAtEnd: true
		);
	}

	/**
	 * Export a static site
	 */
	function doStaticSite( event, rc, prc ){
		event.paramValue( "blogContent", false );

		// Export Site
		var results = staticExporter.export(
			includeBlog = rc.blogContent,
			event       = event,
			rc          = rc,
			prc         = prc,
			site        = prc.oCurrentSite
		);

		// export the content
		var exportFilePath = results.exportFile;
		// save success message
		var filename       = variables.HTMLHelper.slugify( prc.oCurrentSite.getName() );
		// send it
		event.sendFile(
			file      : exportFilePath,
			name      : fileName,
			mimetype  : "application/zip",
			abortAtEnd: true
		);
	}

	/**************************************** PRIVATE ****************************************/

	/**
	 * Looks at incoming export variables and prepares correct target elements from
	 * the RC.  Prefix is `EXPORT_`
	 */
	private struct function prepareExportTargets( required struct rc ){
		return arguments.rc
			.filter( function( key, value ){
				return left( arguments.key, 7 ) == "EXPORT_";
			} )
			.reduce( function( results, key, value ){
				results[ replaceNoCase( arguments.key, "EXPORT_", "", "one" ) ] = arguments.value;
				return results;
			}, {} );
	}

}
