/**
* Manage content versions
*/
component extends="baseHandler"{

	// Dependencies
	property name="contentVersionService"	inject="id:contentVersionService@cb";
	property name="authorService"			inject="id:authorService@cb";
	property name="CBHelper"				inject="id:CBHelper@cb";

	// version pager
	function pager(event,rc,prc,required contentID,numeric max=10){
		
		// Incoming
		prc.versionsPager_max = arguments.max;
		prc.versionsPager_contentID = arguments.contentID;
		
		// Get the latest versions
		var results = contentVersionService.findRelatedVersions(contentID=arguments.contentID,max=arguments.max);
		prc.versionsPager_count 	= results.count;
		prc.versionsPager_versions 	= results.versions;
		
		// exit handlers
		prc.xehVersionQuickLook = "#prc.cbAdminEntryPoint#.versions.quickLook";
		
		// render out widget
		return renderView(view="versions/pager",module="contentbox-admin");
	}

	// Quick Look
	function quickLook(event,rc,prc){
		// get content version
		prc.contentVersion  = contentVersionService.get( event.getValue("versionID",0) );
		event.setView(view="versions/quickLook",layout="ajax");
	}



}
