component output="false" hint="Main filebrowser module handler"{

	// DI
	property name="antiSamy"		inject="coldbox:plugin:AntiSamy";
	property name="fileUtils"		inject="coldbox:plugin:FileUtils";
	property name="cookieStorage"	inject="coldbox:plugin:CookieStorage";

	function preHandler(event,currentAction){
		var prc = event.getCollection(private=true);
		// place root in prc and also module settings
		prc.fbModRoot	 = event.getModuleRoot();
		// if the settings exist in flash, use those
		if( structKeyExists( flash.get( "fileBrowser", {} ), "settings") ){
			prc.fbsettings = flash.get("fileBrowser").settings;
		} else {
			// otherwise we duplicate the settings so we can do overrides a-la-carte
			prc.fbSettings = duplicate( getModuleSettings("filebrowser").settings );
		}
	}

	function index(event,rc,prc,boolean widget=false,struct settings={}){
		// params
		event.paramValue("path","");
		event.paramValue("callback","");
		event.paramValue("cancelCallback","");
		event.paramValue("filterType","");

		if(arguments.widget) {
			//merge the settings structs
			mergeSetting(event,rc,prc,settings);
			//clean out the stored settings for this version
			flash.remove("filebrowser");
		}

		// Detect sorting changes
		detectSorting(event,rc,prc);

		// exit handlers
		prc.xehFBBrowser 	= "filebrowser/";
		prc.xehFBNewFolder 	= "filebrowser/createfolder";
		prc.xehFBRemove 	= "filebrowser/remove";
		prc.xehFBDownload	= "filebrowser/download";
		prc.xehFBUpload		= "filebrowser/upload";
		prc.xehFBRename		= "filebrowser/rename";

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
				addAsset("#prc.fbModRoot#/includes/javascript/selectCallbacks.js");
			}
		}

		// Inflate flash params
		inflateFlashParams(event,rc,prc);

		// clean incoming path
		rc.path = URLDecode( trim( antiSamy.clean( rc.path ) ) );
		// Store directory root
		prc.fbDirRoot 	= prc.fbSettings.directoryRoot;
		prc.fbwebRootPath = getSetting("applicationpath");

		// Get the current Root
		if( !len(rc.path) ){
			prc.fbCurrentRoot = prc.fbSettings.directoryRoot;
		}
		else{
			prc.fbCurrentRoot = rc.path;
		}
		prc.fbCurrentRoot = REReplace(prc.fbCurrentRoot,"(/|\\){1,}$","","all");
		prc.fbCurrentRoot = REReplace(prc.fbCurrentRoot,"\\","/","all");

		prc.fbwebRootPath = REReplace(prc.fbwebRootPath,"(/|\\){1,}$","","all");
		prc.fbwebRootPath = REReplace(prc.fbwebRootPath,"\\","/","all");

		// Do a safe current root
		prc.fbSafeCurrentRoot = URLEncodedFormat( prc.fbCurrentRoot );

		// traversal test
		if( prc.fbSettings.traversalSecurity AND NOT findNoCase(prc.fbSettings.directoryRoot, prc.fbCurrentRoot) ){
			getPlugin("MessageBox").warn("Traversal security exception");
			setNextEvent(prc.xehFBBrowser);
		}

		// Get storage preferences
		prc.fbPreferences = getPreferences();
		prc.fbNameFilter = prc.fbSettings.nameFilter;
		if (rc.filterType == "Image") {prc.fbNameFilter = prc.fbSettings.imgNameFilter;}
		if (rc.filterType == "Flash") {prc.fbNameFilter = prc.fbSettings.flashNameFilter;}
		// get directory listing.
		prc.fbqListing = directoryList( prc.fbCurrentRoot, false, "query", prc.fbSettings.extensionFilter, "#prc.fbPreferences.sorting#");

		// set view or widget?
		if( arguments.widget ){
			return renderView(view="home/index",module="filebrowser");
		}
		else{
			event.setView(view="home/index",noLayout=event.isAjax());
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
	* Merge module settings and arguments settings
	*/
	private function mergeSetting(event,rc,prc,struct settings={}){
		var appliedSetting = {};
		structAppend(appliedSetting, prc.fbSettings, true);
		structAppend(appliedSetting, arguments.settings, true);
		// clean directory root
		if(structKeyExists(arguments.settings,"directoryRoot")) {
			appliedSetting.directoryRoot = REReplace(appliedSetting.directoryRoot,"\\","/","all");
			if (right(appliedSetting.directoryRoot,1) EQ "/") {
				appliedSetting.directoryRoot = left(appliedSetting.directoryRoot,len(appliedSetting.directoryRoot)-1);
			}
		}
		prc.fbSettings = appliedSetting;
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
		rc.path = URLDecode( trim( antiSamy.clean( rc.path ) ) );
		rc.dName = URLDecode( trim( antiSamy.clean( rc.dName ) ) );
		if( !len(rc.path) OR !len(rc.dName) ){
			data.errors = true;
			data.messages = "The path and name sent are invalid!";
			event.renderData(data=data,type="json");
			return;
		}

		// creation
		try{
			fileUtils.directoryCreate( rc.path & "/" & rc.dName );
			data.errors = false;
			data.messages = "Folder '#rc.path#/#rc.dName#' created successfully!";
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
		rc.path = URLDecode( trim( antiSamy.clean( rc.path ) ) );
		if( !len(rc.path) ){
			data.errors = true;
			data.messages = "The path sent is invalid!";
			event.renderData(data=data,type="json");
			return;
		}

		// removal
		try{
			if( fileExists( rc.path ) ){
				fileUtils.removeFile( rc.path );
			}
			else if( directoryExists( rc.path ) ){
				fileUtils.directoryRemove(path=rc.path,recurse=true);
			}
			data.errors = false;
			data.messages = "'#rc.path#' removed successfully!";
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
		rc.path = URLDecode( trim( antiSamy.clean( rc.path ) ) );
		if( !len(rc.path) ){
			data.errors = true;
			data.messages = "The path sent is invalid!";
			event.renderData(data=data,type="json");
			return;
		}

		// download
		try{
			fileUtils.sendFile(file=rc.path);
			data.errors = false;
			data.messages = "'#rc.path#' sent successfully!";
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
		rc.path = URLDecode( trim( antiSamy.clean( rc.path ) ) );
		rc.name = URLDecode( trim( antiSamy.clean( rc.name ) ) );
		if( !len(rc.path) OR !len(rc.name) ){
			data.errors = true;
			data.messages = "The path and/or name sent are invalid!";
			event.renderData(data=data,type="json");
			return;
		}

		// rename
		try{
			if( fileExists( rc.path ) ){
				fileUtils.renameFile( rc.path, rc.name );
			}
			else if( directoryExists( rc.path ) ){
				fileUtils.directoryRename( rc.path, rc.name );
			}
			data.errors = false;
			data.messages = "'#rc.path#' renamed successfully!";
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
		event.paramValue("folder","");

		// clean incoming path
		rc.folder = URLDecode( trim( antiSamy.clean( rc.folder ) ) );

		// traversal test
		if( prc.fbSettings.traversalSecurity AND NOT findNoCase(prc.fbSettings.directoryRoot, rc.folder) ){
			data.errors = true;
			data.messages = "Traversal security activated, path not allowed!";
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

		// download
		try{
			var results = fileUtils.uploadFile(fileField="FILEDATA",
											   destination=rc.folder,
											   nameConflict="Overwrite",
											   accept=prc.fbSettings.acceptMimeTypes);
			// debug log file
			if( log.canDebug() ){
				log.debug("File Uploaded!", results);
			}
			data.errors = false;
			data.messages = "File uploaded successfully!";
		}
		catch(Any e){
			data.errors = true;
			data.messages = "Error uploading file: #e.message# #e.detail#";
			log.error(data.messages, e);
		}

		// render stuff out
		event.renderData(data=data,type="json");
	}

	/**
	* Inflate flash params if they exist into the appropriate function variables.
	*/
	private function inflateFlashParams(event,rc,prc){
		// Check for incoming callback via flash, else default from incoming rc.
		if( structKeyExists( flash.get( "fileBrowser", {} ), "callback") ){
			rc.callback = flash.get("fileBrowser").callback;
		}
		// clean callback
		rc.callBack = antiSamy.clean( rc.callback );
		// cancel callback
		if( structKeyExists( flash.get( "fileBrowser", {} ), "cancelCallback") ){
			rc.cancelCallback = flash.get("fileBrowser").cancelCallback;
		}
		// clean callback
		rc.cancelCallback = antiSamy.clean( rc.cancelCallback );
		// filterType
		if( structKeyExists( flash.get( "fileBrowser", {} ), "filterType") ){
			rc.filterType = flash.get("fileBrowser").filterType;
		}
		// clean filterType
		rc.filterType = antiSamy.clean( rc.filterType );
		// settings
		if( structKeyExists( flash.get( "fileBrowser", {} ), "settings") ){
			prc.fbsettings = flash.get("fileBrowser").settings;
		}

		if(!flash.exists("filebrowser")){
			var filebrowser = {callback=rc.callback,cancelCallback=rc.cancelCallback,filterType=rc.filterType,settings=prc.fbsettings};
			flash.put("filebrowser",filebrowser);
		}

		// keep flash backs
		flash.keep("filebrowser");
	}
}