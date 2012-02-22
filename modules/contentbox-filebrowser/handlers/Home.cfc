/**
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Author      :	Luis Majano
Description :

This is the main controller of events for the filebrowser
----------------------------------------------------------------------->
*/
component output="false" hint="Main filebrowser module handler"{

	// DI
	property name="antiSamy"		inject="coldbox:plugin:AntiSamy";
	property name="fileUtils"		inject="coldbox:plugin:FileUtils";
	property name="cookieStorage"	inject="coldbox:plugin:CookieStorage";

	function preHandler(event,currentAction){
		var prc = event.getCollection(private=true);

		// Detect Module Name Override or default it
		if( settingExists("filebrowser_module_name") ){
			prc.fbModuleName = getSetting("filebrowser_module_name");
		}
		else{
			prc.fbModuleName = "filebrowser";
		}

		// Setup the Module Root And Entry Point
		prc.fbModRoot 		= getModuleSettings( prc.fbModuleName ).mapping;
		prc.fbModEntryPoint = getModuleSettings( prc.fbModuleName ).entrypoint;
		// Duplicate the settings so we can do overrides a-la-carte
		prc.fbSettings = duplicate( getModuleSettings( prc.fbModuleName ).settings );
		// Merge Flash Settings if they exist
		if( structKeyExists( flash.get( "fileBrowser", {} ), "settings") ){
			mergeSettings(prc.fbSettings, flash.get("fileBrowser").settings);
		}
	}

	/**
	* @widget.hint Determines if this will run as a viewlet or normal MVC
	* @settings.hint A structure of settings for the filebrowser to be overriden with in the viewlet most likely.
	*/
	function index(event,rc,prc,boolean widget=false,struct settings={}){
		// params
		event.paramValue("path","");
		event.paramValue("callback","");
		event.paramValue("cancelCallback","");
		event.paramValue("filterType","");

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
				mergeSettings(prc.fbSettings, arguments.settings);
				// clean out the stored settings for this version as we will use passed in settings.
				flash.remove("filebrowser");
			}
		}

		// Detect sorting changes
		detectSorting(event,rc,prc);

		// load Assets for filebrowser
		loadAssets(event,rc,prc);

		// Inflate flash params
		inflateFlashParams(event,rc,prc);

		// Store directory roots and web root
		prc.fbDirRoot 		= prc.fbSettings.directoryRoot;
		prc.fbWebRootPath 	= expandPath("./");

		// clean incoming path and decode it.
		rc.path = cleanIncomingPath( URLDecode( trim( antiSamy.clean( rc.path ) ) ) );
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
			getPlugin("MessageBox").warn("Traversal security exception!");
			setNextEvent(prc.xehFBBrowser);
		}

		// Get storage preferences
		prc.fbPreferences = getPreferences();
		prc.fbNameFilter  = prc.fbSettings.nameFilter;
		if (rc.filterType == "Image") {prc.fbNameFilter = prc.fbSettings.imgNameFilter;}
		if (rc.filterType == "Flash") {prc.fbNameFilter = prc.fbSettings.flashNameFilter;}

		// get directory listing.
		prc.fbqListing = directoryList( prc.fbCurrentRoot, false, "query", prc.fbSettings.extensionFilter, "#prc.fbPreferences.sorting#");

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
	private boolean function isTraversalSecure(required prc, required targetPath){
		// Do some cleanup just in case in the incoming root.
		if( prc.fbSettings.traversalSecurity AND NOT findNoCase(prc.fbSettings.directoryRoot, arguments.targetPath) ){
			return false;
		}
		return true;
	}

	/**
	* Creates folders asynchrounsly return json information:
	*/
	function createfolder(event,rc,prc){
		var data = {
			errors = false,
			messages = ""
		};
		
		// param value
		event.paramValue("path","");
		event.paramValue("dName","");
		
		// Verify credentials else return invalid
		if( !prc.fbSettings.createFolders ){
			data.errors = true;
			data.messages = "CreateFolders permission is disabled.";
			event.renderData(data=data,type="json");
			return;
		}

		// clean incoming path and names
		rc.path = cleanIncomingPath( URLDecode( trim( antiSamy.clean( rc.path ) ) ) );
		rc.dName = URLDecode( trim( antiSamy.clean( rc.dName ) ) );
		if( !len(rc.path) OR !len(rc.dName) ){
			data.errors = true;
			data.messages = "The path and name sent are invalid!";
			event.renderData(data=data,type="json");
			return;
		}

		// Traversal Security
		if( NOT isTraversalSecure(prc, rc.path) ){
			data.errors = true;
			data.messages = "Traversal Exception: The path you sent is outside of the valid application path!";
			event.renderData(data=data,type="json");
			return;
		}

		// creation
		try{
			// Announce it
			var iData = {
				path = rc.path,
				directoryName = rc.dName
			};
			announceInterception("fb_preFolderCreation",iData);
		
			fileUtils.directoryCreate( rc.path & "/" & rc.dName );
			data.errors = false;
			data.messages = "Folder '#rc.path#/#rc.dName#' created successfully!";
			
			// Announce it
			announceInterception("fb_postFolderCreation",iData);
		}
		catch(Any e){
			data.errors = true;
			data.messages = "Error creating folder: #e.message# #e.detail#";
			log.error(data.messages, e);
		}
		// render stuff out
		event.renderData(data=data,type="json");
	}

	/**
	* Removes folders + files asynchrounsly return json information:
	*/
	function remove(event,rc,prc){
		var data = {
			errors = false,
			messages = ""
		};
		// param value
		event.paramValue("path","");

		// Verify credentials else return invalid
		if( !prc.fbSettings.deleteStuff ){
			data.errors = true;
			data.messages = "Delete Stuff permission is disabled.";
			event.renderData(data=data,type="json");
			return;
		}

		// clean incoming path and names
		rc.path = cleanIncomingPath( URLDecode( trim( antiSamy.clean( rc.path ) ) ) );
		if( !len(rc.path) ){
			data.errors = true;
			data.messages = "The path sent is invalid!";
			event.renderData(data=data,type="json");
			return;
		}

		// Traversal Security
		if( NOT isTraversalSecure(prc, rc.path) ){
			data.errors = true;
			data.messages = "Traversal Exception: The path you sent is outside of the valid application path!";
			event.renderData(data=data,type="json");
			return;
		}

		// removal
		try{
			// Announce it
			var iData = {
				path = rc.path
			};
			announceInterception("fb_preFileRemoval",iData);
			
			if( fileExists( rc.path ) ){
				fileUtils.removeFile( rc.path );
			}
			else if( directoryExists( rc.path ) ){
				fileUtils.directoryRemove(path=rc.path,recurse=true);
			}
			data.errors = false;
			data.messages = "'#rc.path#' removed successfully!";
			
			// Announce it
			announceInterception("fb_postFileRemoval",iData);
		}
		catch(Any e){
			data.errors = true;
			data.messages = "Error removing stuff: #e.message# #e.detail#";
			log.error(data.messages, e);
		}
		// render stuff out
		event.renderData(data=data,type="json");
	}

	/**
	* download file
	*/
	function download(event,rc,prc){
		var data = {
			errors = false,
			messages = ""
		};
		// param value
		event.paramValue("path","");

		// Verify credentials else return invalid
		if( !prc.fbSettings.allowDownload ){
			data.errors = true;
			data.messages = "Download permission is disabled.";
			event.renderData(data=data,type="json");
			return;
		}

		// clean incoming path and names
		rc.path = cleanIncomingPath( URLDecode( trim( antiSamy.clean( rc.path ) ) ) );
		if( !len(rc.path) ){
			data.errors = true;
			data.messages = "The path sent is invalid!";
			event.renderData(data=data,type="json");
			return;
		}

		// Traversal Security
		if( NOT isTraversalSecure(prc, rc.path) ){
			data.errors = true;
			data.messages = "Traversal Exception: The path you sent is outside of the valid application path!";
			event.renderData(data=data,type="json");
			return;
		}

		// download
		try{
			// Announce it
			var iData = {
				path = rc.path
			};
			announceInterception("fb_preFileDownload",iData);
			
			fileUtils.sendFile(file=rc.path);
			data.errors = false;
			data.messages = "'#rc.path#' sent successfully!";
			
			// Announce it
			announceInterception("fb_postFileDownload",iData);
		}
		catch(Any e){
			data.errors = true;
			data.messages = "Error downloading file: #e.message# #e.detail#";
			log.error(data.messages, e);
		}
		// render stuff out
		event.renderData(data=data,type="json");
	}

	/**
	* rename
	*/
	function rename(event,rc,prc){
		var data = {
			errors = false,
			messages = ""
		};
		// param value
		event.paramValue("path","");
		event.paramValue("name","");

		// clean incoming path and names
		rc.path = cleanIncomingPath( URLDecode( trim( antiSamy.clean( rc.path ) ) ) );
		rc.name = URLDecode( trim( antiSamy.clean( rc.name ) ) );
		if( !len(rc.path) OR !len(rc.name) ){
			data.errors = true;
			data.messages = "The path and/or name sent are invalid!";
			event.renderData(data=data,type="json");
			return;
		}

		// Traversal Security
		if( NOT isTraversalSecure(prc, rc.path) ){
			data.errors = true;
			data.messages = "Traversal Exception: The path you sent is outside of the valid application path!";
			event.renderData(data=data,type="json");
			return;
		}

		// rename
		try{
			// Announce it
			var iData = {
				original = rc.path,
				newName = rc.name
			};
			announceInterception("fb_preFileRename",iData);
			
			if( fileExists( rc.path ) ){
				fileUtils.renameFile( rc.path, rc.name );
			}
			else if( directoryExists( rc.path ) ){
				fileUtils.directoryRename( rc.path, rc.name );
			}
			data.errors = false;
			data.messages = "'#rc.path#' renamed successfully!";
			
			// Announce it
			announceInterception("fb_postFileRename",iData);
			
		}
		catch(Any e){
			data.errors = true;
			data.messages = "Error renaming: #e.message# #e.detail#";
			log.error(data.messages, e);
		}
		// render stuff out
		event.renderData(data=data,type="json");
	}

	/**
	* Upload File
	*/
	function upload(event,rc,prc){
		// param values
		event.paramValue("path","");
		// clean incoming path for destination directory
		rc.path = cleanIncomingPath( URLDecode( trim( antiSamy.clean( rc.path ) ) ) );
		// traversal test
		if( NOT isTraversalSecure(prc, rc.path) ){
			data.errors = true;
			data.messages = "Traversal security activated, upload folder path not allowed!";
			log.error(data.messages,rc);
			event.renderData(data=data,type="json");
			return;
		}

		// Verify credentials else return invalid
		if( !prc.fbSettings.allowUploads ){
			data.errors = false;
			data.messages = "Uploads not allowed!";
			event.renderData(data=data,type="json");
			return;
		}

		// upload
		try{
			// Announce it
			var iData = {
				fileField = "FILEDATA",
				path = rc.path
			};
			announceInterception("fb_preFileUpload",iData);
			
			iData.results = fileUtils.uploadFile(fileField="FILEDATA",
											   destination=rc.path,
											   nameConflict="Overwrite",
											   accept=prc.fbSettings.acceptMimeTypes);
			// debug log file
			if( log.canDebug() ){
				log.debug("File Uploaded!", iData.results);
			}
			data.errors = false;
			data.messages = "File uploaded successfully!";
			log.info(data.messages, iData.results);
			
			// Announce it
			announceInterception("fb_postFileUpload",iData);
		}
		catch(Any e){
			data.errors = true;
			data.messages = "Error uploading file: #e.message# #e.detail#";
			log.error(data.messages, e);
		}

		// render stuff out
		event.renderData(data=data,type="json");
	}

	/************************************** PRIVATE *********************************************/

	/**
	* Cleanup of incoming path
	*/
	private function cleanIncomingPath(required inPath){
		// Do some cleanup just in case on incoming path
		inPath = REReplace(inPath,"(/|\\){1,}$","","all");
		inPath = REReplace(inPath,"\\","/","all");
		return inPath;
	}

	/**
	* Load Assets for FileBrowser
	*/
	private function loadAssets(event,rc,prc){
		// Load CSS and JS only if not in Ajax Mode
		if( NOT event.isAjax() ){
			// Add Main Styles
			addAsset("#prc.fbModRoot#/includes/css/style.css");
			addAsset("#prc.fbModRoot#/includes/css/jquery.contextMenu.css");

			// load jquery if needed
			if( prc.fbSettings.loadJquery ){
				addAsset("#prc.fbModRoot#/includes/javascript/jquery-1.4.4.min.js");
			}
			// Add additional JS
			addAsset("#prc.fbModRoot#/includes/javascript/jquery.uidivfilter.js");
			addAsset("#prc.fbModRoot#/includes/javascript/jquery.contextMenu.min.js");

			// uploadify if uploads enabled
			if( prc.fbSettings.allowUploads ){
				addAsset("#prc.fbModRoot#/includes/uploadify/uploadify.css");
				addAsset("#prc.fbModRoot#/includes/uploadify/swfobject.js");
				addAsset("#prc.fbModRoot#/includes/uploadify/jquery.uploadify.v2.1.4.min.js");
			}
			if( prc.fbSettings.loadSelectCallbacks ){
				addAsset("#prc.fbModRoot#/includes/javascript/fbSelectCallbacks.js");
			}
		}
	}

	/**
	* Get preferences
	*/
	private function getPreferences(){
		// Get preferences
		var prefs = cookieStorage.getVar("fileBrowserPrefs","");
		// not found or not JSON setup defaults
		if( !len(prefs) OR NOT isJSON(prefs) ){
			prefs = {
				sorting = "name"
			};
			cookieStorage.setVar("fileBrowserPrefs",serializeJSON(prefs));
		}
		else{
			prefs = deserializeJSON( prefs );
		}

		return prefs;
	}

	/**
	* Detect Sorting
	*/
	private function detectSorting(event,rc,prc){
		if( structKeyExists(rc,"sorting") AND reFindNoCase("^(name|size|lastModified)$",rc.sorting) ){
			var prefs = getPreferences();
			if( prefs.sorting NEQ rc.sorting ){
				prefs.sorting = rc.sorting;
				cookieStorage.setVar("fileBrowserPrefs",serializeJSON(prefs));
			}
		}
	}

	/**
	* Merge module settings and custom settings
	*/
	private struct function mergeSettings(struct oldSettings,struct settings={}){
		// Mrege Settings
		structAppend(arguments.oldSettings, arguments.settings, true);
		// clean directory root
		if(structKeyExists(arguments.settings,"directoryRoot")) {
			arguments.oldSettings.directoryRoot = REReplace(arguments.settings.directoryRoot,"\\","/","all");
			if (right(arguments.oldSettings.directoryRoot,1) EQ "/") {
				arguments.oldSettings.directoryRoot = left(arguments.oldSettings.directoryRoot,len(arguments.oldSettings.directoryRoot)-1);
			}
		}
		return oldSettings;
	}

	/**
	* Inflate flash params if they exist into the appropriate function variables.
	*/
	private function inflateFlashParams(event,rc,prc){
		// Check if callbacks stored in flash.
		if( structKeyExists( flash.get( "fileBrowser", {} ), "callback") and len( flash.get("fileBrowser").callback ) ){
			rc.callback = flash.get("fileBrowser").callback;
		}
		// clean callback
		rc.callBack = antiSamy.clean( rc.callback );
		// cancel callback
		if( structKeyExists( flash.get( "fileBrowser", {} ), "cancelCallback") and len( flash.get("fileBrowser").cancelCallback ) ){
			rc.cancelCallback = flash.get("fileBrowser").cancelCallback;
		}
		// clean callback
		rc.cancelCallback = antiSamy.clean( rc.cancelCallback );
		// filterType
		if( structKeyExists( flash.get( "fileBrowser", {} ), "filterType") and len( flash.get("fileBrowser").filterType ) ){
			rc.filterType = flash.get("fileBrowser").filterType;
		}
		// clean filterType
		rc.filterType = antiSamy.clean( rc.filterType );
		// settings
		if( structKeyExists( flash.get( "fileBrowser", {} ), "settings") ){
			prc.fbsettings = flash.get("fileBrowser").settings;
		}

		if(!flash.exists("filebrowser")){
			var filebrowser = {callback=rc.callback, cancelCallback=rc.cancelCallback, filterType=rc.filterType, settings=prc.fbsettings};
			flash.put(name="filebrowser",value=filebrowser,autoPurge=false);
		}		
	}
}