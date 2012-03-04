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
		prc.xehLayoutRemove 	= "#prc.cbAdminEntryPoint#.layouts.remove";
		// get entries
		prc.entries = forgebox.getEntries(orderBy=forgebox.ORDER[rc.orderBy],typeSlug=rc.typeslug);
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
	
}
