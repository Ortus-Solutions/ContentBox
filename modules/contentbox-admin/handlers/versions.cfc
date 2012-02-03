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
		
		// nice UI number
		if( prc.versionsPager_max gt prc.versionsPager_count){
			prc.versionsPager_max = prc.versionsPager_count;
		}
		
		// exit handlers
		prc.xehVersionQuickLook = "#prc.cbAdminEntryPoint#.versions.quickLook";
		prc.xehVersionHistory 	= "#prc.cbAdminEntryPoint#.versions.index";
		prc.xehVersionRemove 	= "#prc.cbAdminEntryPoint#.versions.remove";
		prc.xehVersionRollback 	= "#prc.cbAdminEntryPoint#.versions.rollback";
		prc.xehVersionDiff 		= "#prc.cbAdminEntryPoint#.versions.diff";
		
		// render out widget
		return renderView(view="versions/pager",module="contentbox-admin");
	}

	// Quick Look
	function quickLook(event,rc,prc){
		// get content version
		prc.contentVersion  = contentVersionService.get( event.getValue("versionID",0) );
		event.setView(view="versions/quickLook",layout="ajax");
	}

	// Remove Version
	function remove(event,rc,prc){
		var results = false;
		event.paramValue("versionID","");
		// check for length
		if( len(rc.versionID) ){
			// announce event
			announceInterception("cbadmin_preContentVersionRemove",{contentVersionID=rc.versionID});
			// remove using hibernate bulk
			contentVersionService.deleteByID( rc.versionID );
			// announce event
			announceInterception("cbadmin_postContentVersionRemove",{contentVersionID=rc.versionID});
			// results
			results = true;
		}
		// return in json
		event.renderData(type="json",data=results);
	}
	
	// rollback Version
	function rollback(event,rc,prc){
		var results = false;
		event.paramValue("revertID","");
		// get version
		var oVersion = contentVersionService.get( rc.revertID );
		if( !isNull( oVersion ) ){
			// Try to revert this version
			oVersion.getRelatedContent().addNewContentVersion(content=oVersion.getContent(),
															  changelog="Reverting to version #oVersion.getVersion()#",
															  author=prc.oAuthor);	
			// save 
			contentVersionService.save( oVersion );
			results = true;
		}		
		// return in json
		event.renderData(type="json",data=results);
	}
	
	function diff(event,rc,prc){
		// exit handlers
		prc.xehVersionDiff 	= "#prc.cbAdminEntryPoint#.versions.diff";
		
		// Get the Page content
		prc.currentContent 	= contentVersionService.get( rc.version );
		prc.oldContent 		= contentVersionService.get( rc.oldVersion );
		prc.currentVersion  = prc.currentContent.getVersion();
		prc.oldVersion		= prc.oldContent.getVersion();
		
		// Diff them
		prc.leftA  = listToArray(prc.oldContent.getContent(),chr(10));
		prc.rightA = listToArray(prc.currentContent.getContent(),chr(10));
		prc.diff   = "";
		
		// Manual setup just in case
		if( arrayLen( prc.leftA ) GT arrayLen(prc.rightA) ){
			prc.maxA = arrayLen( prc.leftA );
		}
		else{
			prc.maxA = arrayLen( prc.rightA );
		}
		
		// views
		event.setView(view="versions/diff",layout="ajax");
	}

}
