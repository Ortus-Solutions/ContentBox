/**
* Tools for ContentBox.
*/
component extends="baseHandler"{
	
	// DI
	property name="settingService" 		inject="id:settingService@cb";
	property name="moduleService"       inject="id:moduleService@cb";
    property name="layoutService"       inject="id:layoutService@cb";
    property name="widgetService"       inject="id:widgetService@cb";
    property name="roleService"         inject="id:roleService@cb";
    property name="templateService"     inject="id:emailtemplateService@cb";
	property name="fileUtils"           inject="coldbox:plugin:FileUtils";

	// pre handler
	function preHandler( event, action, eventArguments ){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab control
		prc.tabTools = true;
	}
	
	// importer
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

	// preimport check
	function doCBPreImport( event, rc, prc ) {
		event.paramValue( "CBUpload", "" );
		// make sure upload was valid
		if( len( rc.CBUpload ) && fileExists( rc.CBUpload ) ) {
			var ContentBoxImporter = getModel( "ContentBoxImporter@cb" );
			ContentBoxImporter.setup( importFile=rc.CBUpload );
			// check validity of package
			if( ContentBoxImporter.isValid() ) {
				prc.contents = deserializeJSON( ContentBoxImporter.getDescriptorContents() );
			}
			else {
				getPlugin( "MessageBox" ).error( "Sorry, the imported ContentBox package was not valid. Please verify you have the right file and try again." );
			}
		}
		else {
			getPlugin( "MessageBox" ).error( "Sorry, there was a problem verifying your ContentBox import package. Please try again." );
		}
		event.setView( view="tools/importerPreview", layout="ajax" );
	}

	// do contentbox package import
	function doCBImport( event, rc, prc ) {
		event.paramValue( "CBUpload", "" );
		event.paramValue( "overwrite", false );
		try{
			if( len( rc.CBUpload ) and fileExists( rc.CBUpload ) ){
				var ContentBoxImporter = getModel( "ContentBoxImporter@cb" );
				ContentBoxImporter.setup( importFile=rc.CBUpload );
				// already validated, so just process the import
				var importLog = ContentBoxImporter.execute( overrideContent=rc.overwrite );
				getPlugin( "MessageBox" ).info( "ContentBox package imported sucessfully! Please check out your ContentBox now!" );
				flash.put( "importLog", importLog );
			}
			else{
				getPlugin( "MessageBox" ).error( "The ContentBox package is invalid. Please try again." );
			}
		}
		catch( any e ){
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			getPlugin( "MessageBox" ).error( errorMessage );
		}
		setNextEvent( prc.xehToolsImport );
	}

	// do database import
	function doDataImport( event, rc, prc ){
		event.paramValue("dsn","");
		event.paramValue("dsnUsername","");
		event.paramValue("dsnPassword","");
		event.paramValue("defaultPassword","");
		event.paramValue("tableprefix","");
		event.paramValue("roleID","");
		
		// validate
		if( !len(rc.dsn) or !len(rc.defaultPassword) ){
			getPlugin("MessageBox").warn("Please fill out all required fields.");
			setNextEvent(prc.xehToolsImport);
		}
		
		try{
			// get importer
			var importer = getModel("#rc.importer#Importer@cb");
			importer.execute(argumentCollection=rc);
			getPlugin("MessageBox").info("Content imported successfully! Please check out your ContentBox now!");
		}
		catch(any e){
			getPlugin("MessageBox").error("Error importing from datasource: #e.message# #e.detail#");
		}
		
		setNextEvent(prc.xehToolsImport);
	}
	
	// exporter
	function exporter( event, rc, prc ) {
		// Exit Handlers
		prc.xehExport 			= "#prc.cbAdminEntryPoint#.tools.doExport";
		prc.xehPreviewExport 	= "#prc.cbAdminEntryPoint#.tools.previewExport";
		
		// tab
		prc.tabTools_export = true;
		prc.emailTemplates 	= templateService.getTemplates();
		prc.modules 		= moduleService.findModules().modules;
		prc.layouts 		= layoutService.getLayouts();
		prc.widgets 		= widgetService.getWidgets();
		
		// view
		event.setView("tools/exporter");
	}
	
	function previewExport( event, rc, prc ) {
		// get targets
		var targets = prepareExportTargets( rc );
		var contentBoxExporter = getModel( "ContentBoxExporter@cb" );
		// build up exporter instance from targets in rc
		prc.descriptor = contentBoxExporter.setup( targets ).getDescriptor();
		// render back the descriptor data as json
		event.setView( view="tools/exporterPreview", layout="ajax" );
	}

	// do export
	function doExport( event, rc, prc ) {
		// get targets
		var targets = prepareExportTargets( rc );
		var contentBoxExporter = getModel( "ContentBoxExporter@cb" );
		var exportResult = contentBoxExporter.setup( targets ).export();
		// export the content
		var exportFilePath = exportResult.exportfile;
		// save success message
		var filename = getPlugin( "HTMLHelper" ).slugify( settingService.getSetting( "cb_site_name" ) );
		// send it
		fileUtils.sendFile( file=exportFilePath, name=fileName, abortAtEnd=true );
	}

	/**************************************** PRIVATE ****************************************/

	private struct function prepareExportTargets( required struct rc ) {
		var targets = {};
		for( var key in rc ) {
			if( left( key, 7 ) == "EXPORT_" ) {
				var realKey = replaceNoCase( key, "EXPORT_", "", "one" );
				targets[ realkey ] = rc[ key ];
			}
		}
		return targets;
	}
}
