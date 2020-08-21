/**
* Manage global HTML in the system
*/
component extends="baseHandler"{

	// Dependencies
	property name="settingsService"		inject="id:settingService@cb";
	property name="contentService"		inject="id:contentService@cb";

	// index
	function index( event, rc, prc ){
		event.paramValue( "search","" )
			.paramValue( "page",1);

		// Exit Handler
		prc.xehSaveHTML = "#prc.cbAdminEntryPoint#.globalHTML.save";

		// tab
		prc.tabLookAndFeel_globalHTML = true;

		// view
		event.setView( "globalHTML/index" );
	}

	// save html
	function save( event, rc, prc ){
		// announce event
		announce( "cbadmin_preGlobalHTMLSave", { oldSettings=prc.cbSettings, newSettings=rc } );
		// bulk save the options
		settingsService.bulkSave( rc );
		// clear caches
		contentService.clearAllCaches( async=false );
		settingsService.flushSettingsCache();
		// announce event
		announce( "cbadmin_postGlobalHTMLSave" );
		// relocate back to editor
		cbMessagebox.info( "All Global HTML updated! Yeeehaww!" );
		// relocate
		relocate( prc.xehGlobalHTML );
	}

}
