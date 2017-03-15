/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* This is the main controller of events for the filebrowser
*/
component hint="Main filebrowser module handler"{

	// DI
	property name="fileUtils"		inject="FileUtils@cb";
	property name="cookieStorage"	inject="cookieStorage@cbStorages";

	/**
	* Pre handler
	*/
	function preHandler( event, currentAction, rc, prc ){
		// Detect Module Name Override or default it
		if( settingExists( "filebrowser_module_name" ) ){
			prc.fbModuleName = getSetting( "filebrowser_module_name" );
		} else {
			prc.fbModuleName = "filebrowser";
		}

		// Setup the Module Root And Entry Point
		prc.fbModRoot 		= getModuleConfig( prc.fbModuleName ).mapping;
		prc.fbModEntryPoint = getModuleConfig( prc.fbModuleName ).entrypoint;
		// Duplicate the settings so we can do overrides a-la-carte
		prc.fbSettings = duplicate( getModuleSettings( prc.fbModuleName ) );
		// Merge Flash Settings if they exist
		if( structKeyExists( flash.get( "fileBrowser", {} ), "settings" ) ){
			mergeSettings(prc.fbSettings, flash.get( "fileBrowser" ).settings);
		}
	}

	/**
	* @widget Determines if this will run as a viewlet or normal MVC
	* @settings A structure of settings for the filebrowser to be overriden with in the viewlet most likely.
	*/
	function index(
		event,
		rc,
		prc ,
		boolean widget=false,
		struct settings={}
	){
		// params
		event.paramValue( "path","" );
		event.paramValue( "callback","" );
		event.paramValue( "cancelCallback","" );
		event.paramValue( "filterType","" );

		// exit handlers
		prc.xehFBBrowser 	= "#prc.fbModEntryPoint#/";
		prc.xehFBNewFolder 	= "#prc.fbModEntryPoint#/createfolder";
		prc.xehFBRemove 	= "#prc.fbModEntryPoint#/remove";
		prc.xehFBDownload	= "#prc.fbModEntryPoint#/download";
		prc.xehFBUpload		= "#prc.fbModEntryPoint#/upload";
		prc.xehFBRename		= "#prc.fbModEntryPoint#/rename";

		// Detect Widget Mode.
		if(arguments.widget) {
			// merge the settings structs if defined
			if( !structIsEmpty( arguments.settings ) ){
				mergeSettings( prc.fbSettings, arguments.settings );
				// clean out the stored settings for this version as we will use passed in settings.
				flash.remove( "filebrowser" );
			}
		}

		// Detect sorting changes
		detectPreferences( event, rc, prc );

		// load Assets for filebrowser
		loadAssets( event, rc, prc );

		// Inflate flash params
		inflateFlashParams( event, rc, prc );

		// Store directory roots and web root
		prc.fbDirRoot 		= prc.fbSettings.directoryRoot;
		prc.fbWebRootPath 	= expandPath( "./" );

		// clean incoming path and decode it.
		rc.path = cleanIncomingPath( URLDecode( trim( rc.path ) ) );
		// Check if the incoming path does not exist so we default to the configuration directory root.
		if( !len(rc.path) ){
			prc.fbCurrentRoot = cleanIncomingPath( prc.fbSettings.directoryRoot );
		}
		else{
			prc.fbCurrentRoot = rc.path;
		}
		// Web root cleanups
		prc.fbwebRootPath = cleanIncomingPath(prc.fbwebRootPath);
		// Do a safe current root for JS
		prc.fbSafeCurrentRoot = URLEncodedFormat( prc.fbCurrentRoot );

		// traversal testing
		if( NOT isTraversalSecure(prc, prc.fbCurrentRoot) ){
			getModel( "messagebox@cbMessagebox" ).warn( $r( "messages.traversal@fb" ) );
			setNextEvent(prc.xehFBBrowser);
		}

		// Get storage preferences
		prc.fbPreferences = getPreferences();
		prc.fbNameFilter  = prc.fbSettings.nameFilter;
		if ( rc.filterType == "Image" ) { prc.fbNameFilter = prc.fbSettings.imgNameFilter; }
		if ( rc.filterType == "Flash" ) { prc.fbNameFilter = prc.fbSettings.flashNameFilter; }

		// get directory listing.
		prc.fbqListing = directoryList( prc.fbCurrentRoot, false, "query", prc.fbSettings.extensionFilter, "#prc.fbPreferences.sorting#" );

		var iData = {
			directory = prc.fbCurrentRoot,
			listing = prc.fbqListing
		};
		announceInterception( "fb_postDirectoryRead",iData);

		// set view or render widget?
		if( arguments.widget ){
			return renderView(view="home/index",module=prc.fbModuleName);
		}
		else{
			event.setView(view="home/index",noLayout=event.isAjax());
		}
	}

	/**
	* Determines if this is a safe path call or a traversal security exception
	*/
	private boolean function isTraversalSecure( required prc, required targetPath ){
		// Do some cleanup just in case in the incoming root.
		if( prc.fbSettings.traversalSecurity AND NOT findNoCase(prc.fbSettings.directoryRoot, arguments.targetPath) ){
			return false;
		}
		return true;
	}

	/**
	* Creates folders asynchrounsly return json information:
	*/
	function createfolder( event, rc, prc ){
		var data = {
			errors = false,
			messages = ""
		};

		// param value
		event.paramValue( "path", "" );
		event.paramValue( "dName", "" );

		// Verify credentials else return invalid
		if( !prc.fbSettings.createFolders ){
			data.errors = true;
			data.messages = $r( "messages.create_folder_disabled@fb" );
			event.renderData( data=data, type="json" );
			return;
		}

		// clean incoming path and names
		rc.path = cleanIncomingPath( URLDecode( trim( rc.path ) ) );
		rc.dName = URLDecode( trim( rc.dName ) );
		if( !len( rc.path ) OR !len( rc.dName ) ){
			data.errors = true;
			data.messages = $r( "messages.invalid_path_name@fb" );
			event.renderData( data=data, type="json" );
			return;
		}

		// Traversal Security
		if( NOT isTraversalSecure( prc, rc.path ) ){
			data.errors = true;
			data.messages = $r( "messages.traversal_security@fb" );
			event.renderData( data=data, type="json" );
			return;
		}

		// creation
		try{
			// Announce it
			var iData = {
				path = rc.path,
				directoryName = rc.dName
			};
			announceInterception( "fb_preFolderCreation", iData );

			fileUtils.directoryCreate( rc.path & "/" & rc.dName );
			data.errors = false;
			data.messages = $r( resource="messages.folder_created@fb", values="#rc.path#/#rc.dName#" );

			// Announce it
			announceInterception( "fb_postFolderCreation", iData );
		} catch( Any e ){
			data.errors = true;
			data.messages = $r( resource="messages.error_creating_folder@fb", values="#e.message# #e.detail#" );
			log.error( data.messages, e );
		}
		// render stuff out
		event.renderData( data=data, type="json" );
	}

	/**
	* Removes folders + files asynchrounsly return json information:
	*/
	function remove( event, rc, prc ){
		var data = {
			errors = false,
			messages = ""
		};
		// param value
		event.paramValue( "path", "" );

		// Verify credentials else return invalid
		if( !prc.fbSettings.deleteStuff ){
			data.errors = true;
			data.messages = $r( "messages.delete_disabled@fb" );
			event.renderData( data=data, type="json" );
			return;
		}

		// clean incoming path and names
		rc.path = cleanIncomingPath( URLDecode( trim( rc.path ) ) );
		if( !len( rc.path ) ){
			data.errors = true;
			data.messages = $r( "messages.invalid_path@fb" );
			event.renderData( data=data, type="json" );
			return;
		}

		// Traversal Security
		if( NOT isTraversalSecure( prc, rc.path ) ){
			data.errors = true;
			data.messages = $r( "messages.traversal_security@fb" );
			event.renderData( data=data, type="json" );
			return;
		}

		// removal
		try{
			// Announce it
			var iData = {
				path = rc.path
			};
			announceInterception( "fb_preFileRemoval", iData );

			if( fileExists( rc.path ) ){
				fileUtils.removeFile( rc.path );
			}
			else if( directoryExists( rc.path ) ){
				fileUtils.directoryRemove( path=rc.path, recurse=true );
			}
			data.errors = false;
			data.messages = $r( resource="messages.removed@fb", values="#rc.path#" );

			// Announce it
			announceInterception( "fb_postFileRemoval", iData );
		} catch( Any e ) {
			data.errors = true;
			data.messages = $r( resource="messages.error_removing@fb", values="#e.message# #e.detail#" );
			log.error( data.messages, e );
		}
		// render stuff out
		event.renderData( data=data, type="json" );
	}

	/**
	* download file
	*/
	function download( event, rc, prc ){
		var data = {
			errors = false,
			messages = ""
		};
		// param value
		event.paramValue( "path","" );

		// Verify credentials else return invalid
		if( !prc.fbSettings.allowDownload ){
			data.errors = true;
			data.messages = $r( "messages.download_disabled@fb" );
			event.renderData( data=data, type="json" );
			return;
		}

		// clean incoming path and names
		rc.path = cleanIncomingPath( URLDecode( trim( rc.path ) ) );
		if( !len( rc.path ) ){
			data.errors = true;
			data.messages = $r( "messages.invalid_path@fb" );
			event.renderData( data=data, type="json" );
			return;
		}

		// Traversal Security
		if( NOT isTraversalSecure(prc, rc.path) ){
			data.errors = true;
			data.messages = $r( "messages.traversal_security@fb" );
			event.renderData( data=data, type="json" );
			return;
		}

		// download
		try{
			// Announce it
			var iData = {
				path = rc.path
			};
			announceInterception( "fb_preFileDownload", iData );

			fileUtils.sendFile( file=rc.path );
			data.errors = false;
			data.messages = $r( resource="messages.downloaded@fb", values='#rc.path#' );

			// Announce it
			announceInterception( "fb_postFileDownload", iData );
		}
		catch(Any e){
			data.errors = true;
			data.messages = $r( resource="messages.error_downloading@fb", values="#e.message# #e.detail#" );
			log.error( data.messages, e );
		}
		// render stuff out
		event.renderData( data=data, type="json" );
	}

	/**
	* rename
	*/
	function rename( event, rc, prc ){
		var data = {
			errors = false,
			messages = ""
		};
		// param value
		event.paramValue( "path", "" );
		event.paramValue( "name", "" );

		// clean incoming path and names
		rc.path = cleanIncomingPath( URLDecode( trim( rc.path ) ) );
		rc.name = URLDecode( trim( rc.name ) );
		if( !len( rc.path ) OR !len( rc.name ) ){
			data.errors = true;
			data.messages = $r( "messages.invalid_path_name@fb" );
			event.renderData( data=data, type="json" );
			return;
		}

		// Traversal Security
		if( NOT isTraversalSecure(prc, rc.path) ){
			data.errors = true;
			data.messages = $r( "messages.traversal_security@fb" );
			event.renderData( data=data, type="json" );
			return;
		}

		// rename
		try{
			// Announce it
			var iData = {
				original = rc.path,
				newName = rc.name
			};
			announceInterception( "fb_preFileRename", iData );

			if( fileExists( rc.path ) ){
				fileUtils.renameFile( rc.path, rc.name );
			}
			else if( directoryExists( rc.path ) ){
				fileUtils.directoryRename( rc.path, rc.name );
			}
			data.errors = false;
			data.messages = $r( resource="messages.renamed@fb", values='#rc.path#' );

			// Announce it
			announceInterception( "fb_postFileRename", iData );

		}
		catch(Any e){
			data.errors = true;
			data.messages = $r( resource="messages.error_renaming@fb", values="#e.message# #e.detail#" );
			log.error( data.messages, e );
		}
		// render stuff out
		event.renderData( data=data, type="json" );
	}

	/**
	* Upload File
	*/
	function upload( event, rc, prc ){
		// param values
		event.paramValue( "path", "" )
			.paramValue( "manual", false );

		// clean incoming path for destination directory
		rc.path = cleanIncomingPath( URLDecode( trim( rc.path ) ) );
		// traversal test
		if( NOT isTraversalSecure( prc, rc.path ) ){
			data.errors = true;
			data.messages = $r( "messages.traversal_security@fb" );
			log.error( data.messages, rc );
			event.renderData( data=data, type="json" );
			return;
		}

		// Verify credentials else return invalid
		if( !prc.fbSettings.allowUploads ){
			data.errors = false;
			data.messages = $r( "messages.upload_disabled@fb" );
			event.renderData( data=data, type="json" );
			return;
		}

		// upload
		try{
			// Announce it
			var iData = {
				fileField = "FILEDATA",
				path = rc.path
			};
			announceInterception( "fb_preFileUpload", iData );

			iData.results = fileUtils.uploadFile( 
				fileField		= "FILEDATA",
				destination		= rc.path,
				nameConflict	= "Overwrite",
				accept			= prc.fbSettings.acceptMimeTypes 
			);
			// debug log file
			if( log.canDebug() ){
				log.debug( "File Uploaded!", iData.results);
			}
			data.errors = false;
			data.messages = $r( "messages.uploaded@fb" );
			log.info( data.messages, iData.results );

			// Announce it
			announceInterception( "fb_postFileUpload", iData );
		}
		catch(Any e){
			data.errors = true;
			data.messages = $r( resource="messages.error_uploading@fb", values="#e.message# #e.detail#" );
			log.error( data.messages, e );
			// Announce exception
			var iData = {
				fileField = "FILEDATA",
				path = rc.path,
				exception = e
			};
			announceInterception( "fb_onFileUploadError", iData );
		}
		// Manual uploader?
		if( rc.manual ) {
			event.renderData( data="<textarea id='data_result'='upload'>#serializeJSON( data )#</textarea>", type="text" );
		} else {
			// render stuff out
			event.renderData( data=data, type="json" );
		}
	}

	/************************************** PRIVATE *********************************************/

	/**
	* Cleanup of incoming path
	*/
	private function cleanIncomingPath( required inPath ){
		// Do some cleanup just in case on incoming path
		inPath = REReplace( inPath, "(/|\\){1,}$", "", "all" );
		inPath = REReplace( inPath, "\\", "/", "all" );
		return inPath;
	}

	/**
	* Load Assets for FileBrowser
	* @force Force the loading of assets on demand
	* @settings A structure of settings for the filebrowser to be overriden with in the viewlet most likely.
	*/
	private function loadAssets( event, rc, prc, boolean force=false, struct settings={} ){
		
		// merge the settings structs if passed
		if( !structIsEmpty( arguments.settings ) ){
			mergeSettings( prc.fbSettings, arguments.settings );
		}

		// Load CSS and JS only if not in Ajax Mode or forced
		if( NOT event.isAjax() OR arguments.force ){
			// load parent assets if needed
			if( prc.fbSettings.loadJquery ){
				// Add Main Styles
				var adminRoot = event.getModuleRoot( 'contentbox-admin' );
				addAsset( "#adminRoot#/includes/css/contentbox.min.css" );
				addAsset( "#adminRoot#/includes/js/jquery.min.js" );
			}

			// LOAD Assets

			//injector:css//
			addAsset( "#prc.fbModRoot#/includes/css/86901492.fb.min.css ");
			//endinjector//
			//injector:js//
			addAsset( "#prc.fbModRoot#/includes/js/fd8ff33d.fb.min.js ");
			//endinjector//
		}
	}

	/**
	* Get preferences
	*/
	private function getPreferences(){
		// Get preferences
		var prefs = cookieStorage.getVar( "fileBrowserPrefs", "" );

		// not found or not JSON setup defaults
		if( !len( prefs ) OR NOT isJSON( prefs ) ){
			prefs = {
				sorting = "name", listType = "listing"
			};
			cookieStorage.setVar( "fileBrowserPrefs", serializeJSON( prefs ) );
		}
		else{
			prefs = deserializeJSON( prefs );
			if( !structKeyExists( prefs, "sorting" ) ){
				prefs.sorting = "name";
				cookieStorage.setVar( "fileBrowserPrefs", serializeJSON( prefs ) );
			}
			if( !structKeyExists( prefs, "listType" ) ){
				prefs.listType = "listing";
				cookieStorage.setVar( "fileBrowserPrefs", serializeJSON( prefs ) );
			}
		}
		return prefs;
	}

	/**
	* Detect Preferences: Sorting and List Types
	*/
	private function detectPreferences( event, rc, prc ){
		if( structKeyExists( rc, "sorting" ) AND reFindNoCase( "^(name|size|lastModified)$", rc.sorting ) ){
			var prefs = getPreferences();
			if( prefs.sorting NEQ rc.sorting ){
				prefs.sorting = rc.sorting;
				cookieStorage.setVar( "fileBrowserPrefs", serializeJSON( prefs ) );
			}
		}
		if( structKeyExists( rc, "listType" ) AND reFindNoCase( "^(listing|grid)$", rc.listType ) ){
			var prefs = getPreferences();
			if( NOT structKeyExists(prefs, "listType" ) OR prefs.listType NEQ rc.listType ){
				prefs.listType = rc.listType;
				cookieStorage.setVar( "fileBrowserPrefs", serializeJSON( prefs ) );
			}
		}
	}

	/**
	* Merge module settings and custom settings
	*/
	private struct function mergeSettings( struct oldSettings, struct settings={} ){
		// Mrege Settings
		structAppend( arguments.oldSettings, arguments.settings, true );
		// clean directory root
		if( structKeyExists( arguments.settings, "directoryRoot" ) ) {
			arguments.oldSettings.directoryRoot = REReplace( arguments.settings.directoryRoot,"\\","/","all" );
			if ( right( arguments.oldSettings.directoryRoot, 1 ) EQ "/" ) {
				arguments.oldSettings.directoryRoot = left( arguments.oldSettings.directoryRoot, len( arguments.oldSettings.directoryRoot ) - 1 );
			}
		}
		return oldSettings;
	}

	/**
	* Inflate flash params if they exist into the appropriate function variables.
	*/
	private function inflateFlashParams( event, rc, prc ){
		// Check if callbacks stored in flash.
		if( structKeyExists( flash.get( "fileBrowser", {} ), "callback" ) and len( flash.get( "fileBrowser" ).callback ) ){
			rc.callback = flash.get( "fileBrowser" ).callback;
		}
		// cancel callback
		if( structKeyExists( flash.get( "fileBrowser", {} ), "cancelCallback" ) and len( flash.get( "fileBrowser" ).cancelCallback ) ){
			rc.cancelCallback = flash.get( "fileBrowser" ).cancelCallback;
		}
		// filterType
		if( structKeyExists( flash.get( "fileBrowser", {} ), "filterType" ) and len( flash.get( "fileBrowser" ).filterType ) ){
			rc.filterType = flash.get( "fileBrowser" ).filterType;
		}
		// settings
		if( structKeyExists( flash.get( "fileBrowser", {} ), "settings" ) ){
			prc.fbsettings = flash.get( "fileBrowser" ).settings;
		}

		if( !flash.exists( "filebrowser" ) ){
			var filebrowser = { 
				callback		= rc.callback, 
				cancelCallback	= rc.cancelCallback, 
				filterType		= rc.filterType, 
				settings		= prc.fbsettings 
			};
			flash.put( name="filebrowser", value=filebrowser, autoPurge=false );
		}
	}
}