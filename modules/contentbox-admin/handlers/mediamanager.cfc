/**
* ContentBox Media Manager
*/
component extends="baseHandler"{

	//DI
	property name="settingService"			inject="id:settingService@cb";

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// widget runnable event
		prc.xehFileBrowser = "contentbox-filebrowser:home.index";
		// tabs
		prc.tabContent = true;
		prc.tabContent_mediaManager = true;
	}

	// index
	function index(event,rc,prc){
		// get settings according to contentbox
		prc.cbFileBrowserSettings = settingService.buildFileBrowserSettings();
		// build argument list for widget
		prc.fbArgs = {widget=true,settings=prc.cbFileBrowserSettings};
		// view
		event.setView("mediamanager/index");
	}

}
