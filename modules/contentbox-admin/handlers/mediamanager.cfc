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
		// library type
		event.paramValue( "library","content" );
		// get settings according to contentbox
		prc.cbFileBrowserSettings = settingService.buildFileBrowserSettings();
		// set root according to library root
		switch( rc.library ){
			case "content" : {
				// this is the default, so ignore
				prc.cbFileBrowserSettings.title = "Content Library";
				break;
			}
			case "modules" : {
				prc.cbFileBrowserSettings.title = "Modules Library";
				prc.cbFileBrowserSettings.directoryRoot = getModel( "ModuleService@cb" ).getModulesPath(); break;
			}
			case "updates" : {
				prc.cbFileBrowserSettings.title = "Updates Library";
				prc.cbFileBrowserSettings.directoryRoot = getModel( "UpdateService@cb" ).getPatchesLocation(); break;
			}
			case "widgets" : {
				prc.cbFileBrowserSettings.title = "Widgets Library";
				prc.cbFileBrowserSettings.directoryRoot = getModel( "WidgetService@cb" ).getWidgetsPath(); break;
			}
		}
		// options
		prc.libraryOptions = [
			{name="<i class='icon-pencil'></i> Content", value="Content"},
			{name="<i class='icon-bolt'></i> Modules", value="Modules"},
			{name="<i class='icon-download-alt'></i> Updates", value="Updates"},
			{name="<i class='icon-magic'></i> Widgets", value="Widgets"}
		];

		// build argument list for widget
		prc.fbArgs = {widget=true, settings=prc.cbFileBrowserSettings};

		// view
		event.setView( "mediamanager/index" );
	}

}
