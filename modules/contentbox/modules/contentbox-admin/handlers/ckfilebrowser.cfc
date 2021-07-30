/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * FileBrowser widget control for CKEditor
 */
component extends="baseHandler" {

	// pre handler
	function preHandler( event, rc, prc, action, eventArguments ){
		// event to run
		prc.cbCKfileBrowserDefaultEvent = event.getPrivateValue(
			"cbCKfileBrowserDefaultEvent",
			"contentbox-filebrowser:home.index"
		);
		// CKEditor callback, use if incoming, else default it
		if ( !structKeyExists( rc, "callback" ) ) {
			rc.callback = "fbCKSelect";
		}
		// get settings according to contentbox
		prc.cbCKSetting            = settingService.buildFileBrowserSettings();
		// load jquery as it is standalone
		prc.cbCKSetting.loadJQuery = true;
	}

	/**
	 * Present all assets via ckeditor integration
	 */
	function index( event, rc, prc ){
		var args = { widget : true, settings : prc.cbCKSetting };
		return runEvent( event = prc.cbCKfileBrowserDefaultEvent, eventArguments = args );
	}

	/**
	 * Present image assets via ckeditor integration
	 */
	function image( event, rc, prc ){
		rc.filtertype = "Image";
		var args      = { widget : true, settings : prc.cbCKSetting };
		return runEvent( event = prc.cbCKfileBrowserDefaultEvent, eventArguments = args );
	}

	/**
	 * Present flash assets via ckeditor integration
	 */
	function flash( event, rc, prc ){
		rc.filtertype = "Flash";
		var args      = { widget : true, settings : prc.cbCKSetting };
		return runEvent( event = prc.cbCKfileBrowserDefaultEvent, eventArguments = args );
	}

	/**
	 * Inline Asset chooser brought via Ajax
	 */
	function assetChooser( event, rc, prc ){
		// prepare filebrowser settings
		prc.cbCKSetting.loadJQuery = false;
		var args                   = { widget : true, settings : prc.cbCKSetting };
		// load filebrowser inline
		prc.fileBrowser            = runEvent( event = prc.cbCKfileBrowserDefaultEvent, eventArguments = args );
		// view
		event.setView( view = "ckfilebrowser/assetChooser", layout = "ajax" );
	}

}
