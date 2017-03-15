/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Tools for ContentBox.
*/
component extends="baseHandler"{
	
	// DI
	property name="moduleService"       inject="id:moduleService@cb";
    property name="themeService"       	inject="id:themeService@cb";
    property name="widgetService"       inject="id:widgetService@cb";
    property name="roleService"         inject="id:roleService@cb";
    property name="templateService"     inject="id:emailtemplateService@cb";
	property name="fileUtils"           inject="id:FileUtils@cb";
	property name="HTMLHelper"			inject="HTMLHelper@coldbox";
	property name="staticExporter"		inject="staticExporter@cb";

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
		rc.xehDataImport = "#prc.cbAdminEntryPoint#.tools.doDataImport";
		rc.xehCBPreImport= "#prc.cbAdminEntryPoint#.tools.doCBPreImport";
		rc.xehCBImport 	 = "#prc.cbAdminEntryPoint#.tools.doCBImport";
		// tab
		prc.tabTools_import = true; 
		prc.roles = roleService.list( sortOrder="role" );
		// view
		event.setView( "tools/importer" );
	}

	/**
	 * Pre Import checks
	 */
	function doCBPreImport( event, rc, prc ) {
		event.paramValue( "CBUpload", "" );
		// make sure upload was valid
		if( len( rc.CBUpload ) && fileExists( rc.CBUpload ) ) {
			var ContentBoxImporter = getModel( "ContentBoxImporter@cb" );
			ContentBoxImporter.setup( importFile=rc.CBUpload );
			// check validity of package
			if( ContentBoxImporter.isValid() ) {
				prc.contents = deserializeJSON( ContentBoxImporter.getDescriptorContents() );
				// railo and acf dates don't get along...let's normalize them first
				var badDateRegex = " -\d{4}$";
				prc.contents.exportDate = reReplace( prc.contents.exportDate, badDateRegex, "" );
			}
			else {
				cbMessagebox.warn( "Sorry, the imported ContentBox package was not valid. Please verify you have the right file and try again." );
			}
		}
		else {
			cbMessagebox.error( "Sorry, there was a problem verifying your ContentBox import package. Please try again." );
		}
		event.setView( view="tools/importerPreview", layout="ajax" );
	}

	/**
	 * Import action
	 */
	function doCBImport( event, rc, prc ) {
		event.paramValue( "CBUpload", "" );
		event.paramValue( "overwrite", false );
		try{
			if( len( rc.CBUpload ) and fileExists( rc.CBUpload ) ){
				var ContentBoxImporter = getModel( "ContentBoxImporter@cb" );
				ContentBoxImporter.setup( importFile=rc.CBUpload );
				// already validated, so just process the import
				var importLog = ContentBoxImporter.execute( overrideContent=rc.overwrite );
				cbMessagebox.info( "ContentBox package imported sucessfully! Please check out your ContentBox now!" );
				flash.put( "importLog", importLog );
			} else {
				cbMessagebox.error( "The ContentBox package is invalid. Please try again." );
			}
		}
		catch( any e ){
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			cbMessagebox.error( errorMessage );
		}
		setNextEvent( prc.xehToolsImport );
	}

	/**
	 * Do a data import
	 */
	function doDataImport( event, rc, prc ){
		event.paramValue( "dsn","" );
		event.paramValue( "dsnUsername","" );
		event.paramValue( "dsnPassword","" );
		event.paramValue( "defaultPassword","" );
		event.paramValue( "tableprefix","" );
		event.paramValue( "roleID","" );
		
		// validate
		if( !len( rc.dsn ) or !len( rc.defaultPassword ) ){
			cbMessagebox.warn( "Please fill out all required fields." );
			setNextEvent( prc.xehToolsImport );
		}
		
		try{
			// get importer
			var importer = getModel( "#rc.importer#Importer@cb" );
			importer.execute( argumentCollection=rc );
			cbMessagebox.info( "Content imported successfully! Please check out your ContentBox now!" );
		} catch( any e ){
			cbMessagebox.error( "Error importing from datasource: #e.message# #e.detail#" );
		}
		
		setNextEvent(prc.xehToolsImport);
	}
	
	/**
	* Show the exporter console
	*/
	function exporter( event, rc, prc ) {
		// Exit Handlers
		prc.xehExport 			= "#prc.cbAdminEntryPoint#.tools.doExport";
		prc.xehPreviewExport 	= "#prc.cbAdminEntryPoint#.tools.previewExport";
		prc.xehSiteGenerator 	= "#prc.cbAdminEntryPoint#.tools.doStaticSite";
		
		// tab
		prc.tabTools_export = true;
		prc.modules 		= moduleService.findModules().modules;
		prc.themes 			= themeService.getThemes();
		prc.widgets 		= widgetService.getWidgets();
		prc.widgetService 	= widgetService;
		
		// view
		event.setView( "tools/exporter" );
	}
	
	/**
	* Preview of the export
	*/
	function previewExport( event, rc, prc ) {
		// get targets
		var targets 			= prepareExportTargets( rc );
		var contentBoxExporter 	= getModel( "ContentBoxExporter@cb" );
		// build up exporter instance from targets in rc
		prc.descriptor = contentBoxExporter.setup( targets ).getDescriptor();
		// Sort the content
		prc.aSortedContent = structSort( prc.descriptor.content, "text", "asc", "name" );
		// render back the descriptor data as json
		event.setView( view="tools/exporterPreview", layout="ajax" );
	}

	/**
	* Process a real export
	*/
	function doExport( event, rc, prc ) {
		// get targets
		var targets 			= prepareExportTargets( rc );
		var contentBoxExporter 	= getModel( "ContentBoxExporter@cb" );
		var exportResult 		= contentBoxExporter.setup( targets ).export();
		// export the content
		var exportFilePath = exportResult.exportfile;
		// save success message
		var filename = variables.HTMLHelper.slugify( settingService.getSetting( "cb_site_name" ) );
		// send it
		fileUtils.sendFile( file=exportFilePath, name=fileName, abortAtEnd=true );
	}

	/**
	* Export a static site
	*/
	function doStaticSite( event, rc, prc ){
		event.paramValue( "blogContent", false );

		// Export Site
		var results = staticExporter.export(
			includeBlog = rc.blogContent,
			event 		= event, 
			rc 			= rc,
			prc 		= prc
		);

		// export the content
		var exportFilePath = results.exportFile;
		// save success message
		var filename = variables.HTMLHelper.slugify( settingService.getSetting( "cb_site_name" ) );
		// send it
		fileUtils.sendFile( file=exportFilePath, name=fileName, abortAtEnd=true );
	}

	/**************************************** PRIVATE ****************************************/

	/**
	* Looks at incoming export variables and prepares correct target elements from
	* the RC.  Prefix is `EXPORT_`
	*/
	private struct function prepareExportTargets( required struct rc ) {
		var targets = {};
		for( var key in arguments.rc ) {
			if( left( key, 7 ) == "EXPORT_" ) {
				var realKey = replaceNoCase( key, "EXPORT_", "", "one" );
				targets[ realkey ] = arguments.rc[ key ];
			}
		}
		return targets;
	}
}
