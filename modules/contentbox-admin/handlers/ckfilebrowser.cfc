/**
* FileBrowser widget control for CKEditor
*/
component extends="baseHandler"{

	//DI
	property name="settingService"			inject="id:settingService@cb";

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// event to run
		prc.cbCKfileBrowserDefaultEvent = "contentbox-filebrowser:home.index";
		// CKEditor callback
		rc.callback="fbCKSelect";
		// get settings according to contentbox
		prc.cbCKSetting = settingService.buildFileBrowserSettings();
		prc.cbCKSetting.loadJQuery = true;
		//base mediaPath
		var mediaPath = ( len( getSetting( "AppMapping" ) ) ? getSetting( "AppMapping" ) : "" ) & "/";
		if(findNoCase("index.cfm",event.getSESBaseURL())) {
			mediaPath = "index.cfm" & mediaPath;;
		}
		// add the entry point
		mediaPath &= getSetting("modules")["contentbox-ui"].entryPoint & "__media";
		prc.cbCKSetting.mediaPath = mediaPath;
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
