component output="false" hint="Main filebrowser module handler"{

	// DI
	property name="antiSamy"		inject="coldbox:plugin:AntiSamy";
	property name="fileUtils"		inject="coldbox:plugin:FileUtils";

	function preHandler(event,currentAction){
		var prc = event.getCollection(private=true);
		// place root in prc and also module settings
		prc.modRoot	 = event.getModuleRoot();
		// we duplicate the settings so we can do overrides a-la-carte
		prc.settings = duplicate( getModuleSettings("filebrowser").settings );
	}

	function index(event,rc,prc,boolean widget=false){
		// params
		event.paramValue("path","");
		event.paramValue("callback","");
		event.paramValue("cancelCallback","");

		// exit handlers
		prc.xehBrowser 		= "filebrowser/";
		prc.xehNewFolder 	= "filebrowser/createfolder";
		prc.xehRemove 		= "filebrowser/remove";
		prc.xehDownload		= "filebrowser/download";
		prc.xehUpload		= "filebrowser/upload";
		prc.xehRename		= "filebrowser/rename";

		// Load CSS and JS only if not in Ajax Mode
		if( NOT event.isAjax() ){
			addAsset("#prc.modRoot#/includes/css/style.css");
			// load jquery if needed
			if( prc.settings.loadJquery ){
				addAsset("#prc.modRoot#/includes/javascript/jquery-1.4.4.min.js");
			}
			addAsset("#prc.modRoot#/includes/javascript/jquery.uidivfilter.js");
			// uploadify if uploads enabled
			if( prc.settings.allowUploads ){
				addAsset("#prc.modRoot#/includes/uploadify/uploadify.css");
				addAsset("#prc.modRoot#/includes/uploadify/swfobject.js");
				addAsset("#prc.modRoot#/includes/uploadify/jquery.uploadify.v2.1.4.min.js");
			}
			if( prc.settings.loadSelectCallbacks ){
				addAsset("#prc.modRoot#/includes/javascript/selectCallbacks.js");
			}
		}

		// Inflate flash params
		inflateFlashParams(event,rc,prc);

		// clean incoming path
		rc.path = URLDecode( trim( antiSamy.clean( rc.path ) ) );
		// Store directory root
		prc.dirRoot 	= prc.settings.directoryRoot;
		prc.webRootPath = getSetting("applicationpath");

		// Get the current Root
		if( !len(rc.path) ){
			prc.currentRoot = prc.settings.directoryRoot;
		}
		else{
			prc.currentRoot = rc.path;
		}
		prc.currentRoot = REReplace(prc.currentRoot,"(/|\\){1,}$","","all");
		prc.currentRoot = REReplace(prc.currentRoot,"\\","/","all");

		prc.webRootPath = REReplace(prc.webRootPath,"(/|\\){1,}$","","all");
		prc.webRootPath = REReplace(prc.webRootPath,"\\","/","all");

		// Do a safe current root
		prc.safeCurrentRoot = URLEncodedFormat( prc.currentRoot );

		// traversal test
		if( prc.settings.traversalSecurity AND NOT findNoCase(prc.settings.directoryRoot, prc.currentRoot) ){
			getPlugin("MessageBox").warn("Traversal security exception");
			setNextEvent(prc.xehBrowser);
		}


		// get directory listing.
		prc.qListing = directoryList( prc.currentRoot, false, "query", prc.settings.extensionFilter, "asc");

		// set view or widget?
		if( arguments.widget ){
			return renderView(view="home/index",module="filebrowser");
		}
		else{
			event.setView(view="home/index",noLayout=event.isAjax());
		}
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
		if( !prc.settings.createFolders ){
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
		if( !prc.settings.deleteStuff ){
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
		if( !prc.settings.allowDownload ){
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
		if( prc.settings.traversalSecurity AND NOT findNoCase(prc.settings.directoryRoot, rc.folder) ){
			data.errors = true;
			data.messages = "Traversal security activated, path not allowed!";
			event.renderData(data=data,type="json");
			return;
		}

		// Verify credentials else return invalid
		if( !prc.settings.allowUploads ){
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
											   accept=prc.settings.acceptMimeTypes);
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

		if(!flash.exists("filebrowser")){
			var filebrowser = {callback=rc.callback,cancelCallback=rc.cancelCallback};
			flash.put("filebrowser",filebrowser);
		}

		// keep flash backs
		flash.keep("filebrowser");
	}

}