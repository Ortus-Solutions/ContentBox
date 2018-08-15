/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ContentBox Media Manager handler
*/
component extends="baseHandler"{

	/**
	* Pre handler
	*/
	function preHandler( event, action, eventArguments, rc, prc ){
		// widget runnable event
		prc.xehFileBrowser = "contentbox-filebrowser:home.index";
	}

	/**
	* Display media manager
	*/
	function index(event,rc,prc){
		// library type
		event.paramValue( "library", "content" );
		// get settings according to contentbox
		prc.cbFileBrowserSettings = settingService.buildFileBrowserSettings();
		// set root according to library root
		switch( rc.library ){
			case "content" : {
				// this is the default, so ignore
				prc.cbFileBrowserSettings.title = "Content Library";
				break;
			}
			case "customModules" : {
				prc.cbFileBrowserSettings.title = "Custom Modules Library";
				prc.cbFileBrowserSettings.directoryRoot = getModel( "ModuleService@cb" ).getCustomModulesPath(); break;
			}
			case "coreModules" : {
				prc.cbFileBrowserSettings.title = "Core Modules Library";
				prc.cbFileBrowserSettings.directoryRoot = getModel( "ModuleService@cb" ).getCoreModulesPath(); break;
			}
			case "updates" : {
				prc.cbFileBrowserSettings.title = "Updates Library";
				prc.cbFileBrowserSettings.directoryRoot = getModel( "UpdateService@cb" ).getPatchesLocation(); break;
			}
			case "coreWidgets" : {
				prc.cbFileBrowserSettings.title = "Core Widgets Library";
				prc.cbFileBrowserSettings.directoryRoot = getModel( "WidgetService@cb" ).getCoreWidgetsPath(); break;
			}
			case "customWidgets" : {
				prc.cbFileBrowserSettings.title = "Custom Widgets Library";
				prc.cbFileBrowserSettings.directoryRoot = getModel( "WidgetService@cb" ).getCustomWidgetsPath(); break;
			}
		}

		// options
		prc.libraryOptions = [
			{ name="<i class='fa fa-pencil'></i> Content", 		value="Content"	},
			{ name="<i class='fa fa-bolt'></i> Core Modules", 	value="CoreModules"	},
			{ name="<i class='fa fa-bolt'></i> Custom Modules", value="CustomModules"	},
			{ name="<i class='fa fa-download'></i> Updates", 	value="Updates"	},
			{ name="<i class='fa fa-magic'></i> Core Widgets", 		value="CoreWidgets"},
			{ name="<i class='fa fa-magic'></i> Custom Widgets", 		value="CustomWidgets"}
		];

		// build argument list for widget
		prc.fbArgs = { widget=true, settings=prc.cbFileBrowserSettings };

		// Light up
		prc.tabContent_mediaManager = true;

		// view
		event.setView( "mediamanager/index" );
	}

}