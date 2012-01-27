/**
* FileBrowser widget control for CKEditor
*/
component extends="baseHandler"{

	//DI
	property name="CBHelper"			inject="id:CBHelper@cb";

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// event to run
		prc.cbCKfileBrowserDefaultEvent = "contentbox-filebrowser:home.index";
		// CKEditor callback
		rc.callback="fbCKSelect";
		//settings
		prc.cbCKSetting = {
			directoryRoot=CBHelper.setting("cb_ck_directoryRoot",expandPath("/modules/contentbox/content")),
			createFolders=CBHelper.setting("cb_ck_createFolders",true),
			deleteStuff=CBHelper.setting("cb_ck_deleteStuff",true),
			allowDownload=CBHelper.setting("cb_ck_allowDownload",true),
			allowUploads=CBHelper.setting("cb_ck_allowUploads",true),
			acceptMimeTypes=CBHelper.setting("cb_ck_acceptMimeTypes",""),
			nameFilter=CBHelper.setting("cb_ck_nameFilter",".*"),
			extensionFilter=CBHelper.setting("cb_ck_extensionFilter",""),
			imgNameFilter=CBHelper.setting("cb_ck_imgNameFilter","^((?!\.).)*$|.+\.(jpg|jpeg|bmp|gif|png)/? *"),
			flashNameFilter=CBHelper.setting("cb_ck_flashNameFilter","^((?!\.).)*$|.+\.(swf|fla)/? *"),
			loadJQuery=CBHelper.setting("cb_ck_loadJQuery",false),
			loadSelectCallbacks=CBHelper.setting("cb_ck_loadSelectCallbacks",true),
			quickViewWidth=CBHelper.setting("cb_ck_quickViewWidth",400),
			uploadify=CBHelper.setting("cb_ck_uploadify",{
				fileDesc = "All Files",
				fileExt	 = "*.*;",
				multi 	 = true,
				sizeLimit = 0,
				customJSONOptions = ""
			})
		};
	}

	// index
	function index(event,rc,prc){
		var args = {widget=true,settings=prc.cbCKSetting};
		return runEvent(event=prc.cbCKfileBrowserDefaultEvent,eventArguments=args);
	}

	// image
	function image(event,rc,prc){
		rc.filtertype="Image";
		var args = {widget=true,settings=prc.cbCKSetting};
		return runEvent(event=prc.cbCKfileBrowserDefaultEvent,eventArguments=args);
	}

	// flash
	function flash(event,rc,prc){
		rc.filtertype="Flash";
		var args = {widget=true,settings=prc.cbCKSetting};
		return runEvent(event=prc.cbCKfileBrowserDefaultEvent,eventArguments=args);
	}

}
