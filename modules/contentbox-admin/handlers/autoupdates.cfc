/**
* Admin Dashboard
*/
component extends="baseHandler"{

	// Dependencies
	
	function preHandler(event,action,eventArguments){
		var prc = event.getCollection(private=true);
		prc.tabDashboard	  = true;
	}

	// dashboard index
	function index(event,rc,prc){
		
		// exit Handlers
		prc.xehUpdateCheck		= "#prc.cbAdminEntryPoint#.autoupdates.check";
		
		// slugs
		prc.updateSlugStable = getModuleSettings("contentbox").settings.updateSlug_stable;
		prc.updateSlugBeta = getModuleSettings("contentbox").settings.updateSlug_beta;
		
		// keep logs for review
		flash.keep("udpateLog");
		// clear Logs
		if( event.valueExists("clearLogs") ){
			flash.discard("updateLog");
		}
		// Install Log
		prc.installLog = flash.get("updateLog","");
		
		// Tab Manipulation
		prc.tabDashboard_updates = true;
				
		// auto updates
		event.setView("autoupdates/index");
	}
	
	// check for updates
	function check(event,rc,prc){
		// verify the slug
		event.paramValue("channel",getModuleSettings("contentbox").settings.updateSlug_stable);
		
		// exit Handlers
		prc.xehUpdateApply		= "#prc.cbAdminEntryPoint#.autoupdates.apply";
		
		// Get Extension Version
		prc.contentboxVersion = getModuleSettings('contentbox').version;
		
		// Check for forgebox item
		var forgeBox = getModel("ForgeBox@cb");
		var updateService = getModel("UpdateService@cb");
		
		try{
			prc.updateEntry   = forgeBox.getEntry(slug=rc.channel);
			// Check if versions are new.
			prc.updateFound = updateService.isNewVersion(cVersion=prc.contentboxVersion,nVersion=prc.updateEntry.version);
			// Verify if we have updates?
			if( prc.updateFound ){
				getPlugin("MessageBox").info("Woopeee! There is a new ContentBox update for you!");
			}
			else{
				getPlugin("MessageBox").warn("You have the latest version of ContentBox installed, no update for you!");
			}
		}
		catch(Any e){
			getPlugin("MessageBox").error("Error retrieving update information, please try again later.<br> Diagnostics: #e.detail# #e.message#");
			log.error("Error retrieving ForgeBox information", e);
		}
		
		
		// auto updates
		event.setView(view="autoupdates/check",layout="ajax");
	}
	
	// apply for updates
	function apply(event,rc,prc){
		event.paramValue("downloadURL","");
		// verify download URL
		if( !len( rc.downloadURL ) ){
			getPlugin("MessageBox").error("No download URL detected");
			setnextEvent(prc.xehAutoUpdater);
			return;
		}
		
		try{
			// Apply Update
			var updateResults = getModel("UpdateService@cb").applyUpdate( rc.downloadURL, rc.version );
			if( updateResults.error ){
				getPlugin("MessageBox").warn("Update Failed! Please check the logs for more information");
			}
			else{
				getPlugin("MessageBox").info("Update Applied! Welcome to version #rc.version#");
			}
			flash.put("updateLog", updateResults.log);
			
		}
		catch(Any e){
			getPlugin("MessageBox").error("Error installing auto-update.<br> Diagnostics: #e.detail# #e.message#");
			log.error("Error installing auto-update", e);
		}
		
		setnextEvent(prc.xehAutoUpdater);
	}
	
}
