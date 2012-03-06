/**
* Manage ForgeBox
*/
component extends="baseHandler"{

	// Dependencies
	property name="forgebox"		inject="id:ForgeBox@cb";

	// index
	function index(event,rc,prc){
		// order by
		event.paramValue("orderBy","POPULAR");

		// exit Handlers
		prc.xeh 	= "#prc.cbAdminEntryPoint#.layouts.remove";
		prc.xehForgeBoxInstall  = "#prc.cbAdminEntryPoint#.forgebox.install";

		// get entries
		try{
			prc.entries = forgebox.getEntries(orderBy=forgebox.ORDER[rc.orderBy],typeSlug=rc.typeslug);
			prc.errors = false;
		}
		catch(Any e){
			prc.errors = true;
			log.error("Error installing from ForgeBox: #e.message# #e.detail#",e);
			getPlugin("MessageBox").error("Error connecting to ForgeBox: #e.message# #e.detail#");
		}

		// Add Assets
		addAsset("#prc.cbroot#/includes/js/ratings/jquery.ratings.pack.js");
		addAsset("#prc.cbroot#/includes/js/ratings/jquery.ratings.css");

		// Entries title
		switch(rc.orderBy){
			case "new" : { prc.entriesTitle = "Cool New Stuff!"; break; }
			case "recent" : { prc.entriesTitle = "Recently Updated!"; break; }
			default: { prc.entriesTitle = "Most Popular!"; }
		}
		// view
		event.setView(view="forgebox/index",layout="ajax");
	}

	function install(event,rc,prc){
		rc.downloadURL 	= urldecode( rc.downloadURL );
		rc.installDir  	= urldecode( rc.installDir );
		rc.returnURL 	= urldecode( rc.returnURL );

		// get entries
		var results = forgebox.install(rc.downloadURL,rc.installDir);
		if( results.error ){
			log.error("Error installing from ForgeBox: #results.logInfo#",results.logInfo);
			getPlugin("MessageBox").error("Error installing from ForgeBox: #results.logInfo#");
		}
		else{
			getPlugin("MessageBox").info("Entry installed from ForgeBox!");
		}
		// flash results
		flash.put("forgeboxInstallLog", results.logInfo);
		// return to caller
		setNextEvent(URL=rc.returnURL);
	}
}