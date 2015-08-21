/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manage auto updates
*/
component extends="baseHandler"{

	// DI 
	property name="messagebox" 		inject="messagebox@cbmessagebox";
	property name="moduleSettings"	inject="coldbox:moduleSettings:contentbox";

	// Pre Handler
	function preHandler( event, rc, prc, action, eventArguments ){
		prc.tabDashboard = true;
	}

	// dashboard index
	function index( event, rc, prc ){

		// exit Handlers
		prc.xehUpdateCheck		= "#prc.cbAdminEntryPoint#.autoupdates.check";
		prc.xehInstallUpdate    = "#prc.cbAdminEntryPoint#.autoupdates.apply";
		prc.xehUploadUpdate     = "#prc.cbAdminEntryPoint#.autoupdates.upload";

		// slugs
		prc.updateSlugStable 	= moduleSettings.updateSlug_stable;
		prc.updateSlugBeta 		= moduleSettings.updateSlug_beta;

		// keep logs for review
		flash.keep( "updateLog" );
		// issue application stop
		if( flash.exists( "updateRestart" ) and flash.get( "updateRestart" ) ){
			flash.saveFlash();
			applicationstop();
			setnextEvent(prc.xehAutoUpdater);
			return;
		}
		// clear Logs
		if( event.valueExists( "clearLogs" ) ){
			flash.discard( "updateLog" );
		}
		// Install Log
		prc.installLog = flash.get( "updateLog","" );

		// Tab Manipulation
		prc.tabDashboard_updates = true;

		// auto updates
		event.setView( "autoupdates/index" );
	}

	// check for updates
	function check( event, rc, prc ){
		// verify the slug
		event.paramValue( "channel", moduleSettings.updateSlug_stable );

		// exit Handlers
		prc.xehUpdateApply = "#prc.cbAdminEntryPoint#.autoupdates.apply";

		// Get Extension Version
		prc.contentboxVersion = getModuleConfig( 'contentbox' ).version;
		prc.updateFound = false;

		// Check for forgebox item
		var forgeBox 		= getModel( "ForgeBox@cb" );
		var updateService 	= getModel( "UpdateService@cb" );

		try{
			prc.updateEntry = forgeBox.getEntry( slug=rc.channel );
			// Check if versions are new.
			prc.updateFound = updateService.isNewVersion( cVersion=prc.contentboxVersion, nVersion=prc.updateEntry.version );
			// Verify if we have updates?
			if( prc.updateFound ){
				messagebox.info( "Woopeee! There is a new ContentBox update for you!" );
			} else {
				messagebox.warn( "You have the latest version of ContentBox installed, no update for you!" );
			}
		}
		catch(Any e){
			messagebox.error( "Error retrieving update information, please try again later.<br> Diagnostics: #e.detail# #e.message# #e.stackTrace#" );
			log.error( "Error retrieving ForgeBox information", e);
		}

		// auto updates
		event.setView( view="autoupdates/check", layout="ajax" );
	}

	// apply for updates
	function apply( event, rc, prc ){
		event.paramValue( "downloadURL","" );
		// verify download URL
		if( !len( rc.downloadURL ) ){
			messagebox.error( "No download URL detected" );
			setnextEvent( prc.xehAutoUpdater );
			return;
		}

		try{
			// Apply Update
			var updateResults = getModel( "UpdateService@cb" ).applyUpdateFromURL( rc.downloadURL );
			if( updateResults.error ){
				messagebox.error( "Update Failed! Please check the logs for more information" );
			} else {
				messagebox.info( "Update Applied!" );
			}
			flash.put( "updateLog", updateResults.log);
			flash.put( "updateRestart", ( !updateResults.error ) );
		}
		catch( Any e ){
			messagebox.error( "Error installing auto-update.<br> Diagnostics: #e.detail# #e.message#" );
			log.error( "Error installing auto-update", e);
		}

		setnextEvent( prc.xehAutoUpdater );
	}

	// upload
	function upload( event, rc, prc ){
		var fp = event.getTrimValue( "filePatch","" );

		// Verify
		if( !len( fp ) ){
			messagebox.warn( "Please choose an update file to upload!" );
		}
		else{
			// Upload File
			try{
				// Apply Update
				var updateResults = getModel( "UpdateService@cb" ).applyUpdateFromUpload( "filePatch" );
				if( updateResults.error ){
					messagebox.error( "Update Failed! Please check the logs for more information" );
				} else {
					messagebox.info( "Update Applied!" );
				}
				flash.put( "updateLog", updateResults.log);
				flash.put( "updateRestart", ( !updateResults.error ) );
			}
			catch( Any e ){
				messagebox.error( "Error uploading update file: #e.detail# #e.message#" );
			}
		}

		setnextEvent( prc.xehAutoUpdater );
	}

}