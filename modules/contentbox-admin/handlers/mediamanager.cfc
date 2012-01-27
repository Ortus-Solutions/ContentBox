/**
* ContentBox Media Manager
*/
component extends="baseHandler"{

	//DI
	property name="CBHelper"			inject="id:CBHelper@cb";

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// event to run
		prc.xehFileBrowser = "contentbox-filebrowser:home.index";
		// tabs
		prc.tabContent = true;
		prc.tabContent_mediaManager = true;
		//settings
		prc.cbFileBrowserSettings = {
			directoryRoot=CBHelper.setting("cb_ck_directoryRoot",expandPath("/modules/contentbox/content")),
			traversalSecurity=CBHelper.setting("cb_ck_traversalSecurity",true),
			showFiles=CBHelper.setting("cb_ck_showFiles",true),
			createFolders=CBHelper.setting("cb_ck_createFolders",true),
			deleteStuff=CBHelper.setting("cb_ck_deleteStuff",true),
			allowDownload=CBHelper.setting("cb_ck_allowDownload",true),
			allowUploads=CBHelper.setting("cb_ck_allowUploads",true),
			acceptMimeTypes=CBHelper.setting("cb_ck_acceptMimeTypes",""),
			nameFilter=CBHelper.setting("cb_ck_nameFilter",".*"),
			extensionFilter=CBHelper.setting("cb_ck_extensionFilter",""),
			imgNameFilter=CBHelper.setting("cb_ck_imgNameFilter","^((?!\.).)*$|.+\.(jpg|jpeg|bmp|gif|png)/? *"),
			flashNameFilter=CBHelper.setting("cb_ck_flashNameFilter","^((?!\.).)*$|.+\.(swf|fla)/? *"),
			volumeChooser=CBHelper.setting("cb_ck_volumeChooser",false),
			loadJQuery=CBHelper.setting("cb_ck_loadJQuery",true),
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
		prc.fbArgs = {widget=true,settings=prc.cbFileBrowserSettings};
		event.setView("mediamanager/index");
	}

}
