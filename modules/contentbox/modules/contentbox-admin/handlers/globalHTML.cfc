/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manage global HTML in the system
 */
component extends="baseHandler" {

	// Dependencies
	property name="settingsService" inject="settingService@contentbox";
	property name="contentService" inject="contentService@contentbox";

	/**
	 * View HTML
	 */
	function index( event, rc, prc ){
		// Exit Handler
		prc.xehSaveHTML = "#prc.cbAdminEntryPoint#.globalHTML.save";

		// tab
		prc.tabLookAndFeel_globalHTML = true;

		// view
		event.setView( "globalHTML/index" );
	}

	/**
	 * Save HTML
	 */
	function save( event, rc, prc ){
		// announce event
		announce( "cbadmin_preGlobalHTMLSave", { oldSettings : prc.cbSettings, newSettings : rc } );
		// bulk save the options
		settingsService.bulkSave(
			rc.filter( function( item ){
				return item.findNoCase( "cb_html" );
			} ),
			prc.oCurrentSite
		);
		// clear caches
		contentService.clearAllCaches( async = false );
		settingsService.flushSettingsCache();
		// announce event
		announce( "cbadmin_postGlobalHTMLSave" );
		// relocate back to editor
		cbMessagebox.info( "All Global HTML updated! Yeeehaww!" );
		// relocate
		relocate( prc.xehGlobalHTML );
	}

}
