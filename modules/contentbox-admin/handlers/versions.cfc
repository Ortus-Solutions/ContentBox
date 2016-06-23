/**
* Manage content versions
*/
component extends="baseHandler"{

	// Dependencies
	property name="contentVersionService"	inject="id:contentVersionService@cb";
	property name="contentService"			inject="id:contentService@cb";
	property name="authorService"			inject="id:authorService@cb";
	property name="CBHelper"				inject="id:CBHelper@cb";

	/**
	* Versions History Index
	*/
	function index( event, rc, prc ){
		// param contentID
		event.paramValue( "contentID","" );
		// Get Content object
		prc.content = contentService.get( rc.contentID );

		// Do according to type
		switch( prc.content.getContentType() ){
			case "Page" : {
				prc.xehBackTrack 	= "#prc.cbAdminEntryPoint#.pages";
				prc.xehOpenContent 	= CBHelper.linkContent( prc.content );
				break;
			}
			case "Entry" : {
				prc.xehBackTrack = "#prc.cbAdminEntryPoint#.entries";
				prc.xehOpenContent 	= CBHelper.linkContent( prc.content );
				break;
			}
			case "ContentStore" : {
				prc.xehBackTrack = "#prc.cbAdminEntryPoint#.contentStore";
				prc.xehOpenContent 	= "";
				break;
			}
		}

		// Announce event
		announceInterception( "cbadmin_onVersionIndex" );

		// Pager with all versions
		prc.versionsPager = pager( event, rc, prc, rc.contentID, 0, false );
		// view
		event.setView( view="versions/index" );
	}

	/**
	* Pager Viewlet for version records
	* @contentID The contentID to iterate records on
	* @max The maximum records to show
	* @viewFullHistory View full history or partial paginated results
	*/
	function pager( event, rc, prc, required contentID, numeric max=10, boolean viewFullHistory=true ){

		// Incoming
		prc.versionsPager_max 				= arguments.max;
		prc.versionsPager_contentID 		= arguments.contentID;
		prc.versionsPager_viewFullHistory 	= arguments.viewFullHistory;

		// Get Content
		prc.versionsPager_content = contentService.get( arguments.contentID );

		// Get the latest versions
		var results = contentVersionService.findRelatedVersions( contentID=arguments.contentID, max=arguments.max );
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
		return renderView( view="versions/pager", module="contentbox-admin" );
	}

	/**
	* Version quick look
	*/
	function quickLook( event, rc, prc ){
		// get content version
		prc.contentVersion  = contentVersionService.get( event.getValue( "versionID", 0 ) );
		event.setView( view="versions/quickLook", layout="ajax" );
	}

	/**
	* Remove permanently a version
	*/
	function remove( event, rc, prc ){
		var results = { "ERROR" = false, "MESSAGES" = "" };
		event.paramValue( "versionID","" );

		// check for length
		if( len( rc.versionID ) ){
			// announce event
			announceInterception( "cbadmin_preContentVersionRemove", { contentVersionID = rc.versionID } );
			// remove using hibernate bulk
			contentVersionService.deleteByID( rc.versionID );
			// announce event
			announceInterception( "cbadmin_postContentVersionRemove", { contentVersionID = rc.versionID } );
			// results
			results.messages = "Version removed!";
		} else {
			results.error = true;
			results.messages = "No versionID sent to remove!";
		}
		// return in json
		event.renderData( type="json", data=results );
	}

	/**
	* Rollback a version
	*/
	function rollback( event, rc, prc ){
		var results = { "ERROR" = false, "MESSAGES" = "" };
		event.paramValue( "revertID","" );
		// get version
		var oVersion = contentVersionService.get( rc.revertID );
		if( !isNull( oVersion ) ){
			// announce event
			announceInterception( "cbadmin_preContentVersionRollback", { contentVersion = oVersion } );
			// Try to revert this version
			oVersion.getRelatedContent().addNewContentVersion(
				content 	= oVersion.getContent(),
				changelog 	= "Reverting to version #oVersion.getVersion()#",
				author 	 	= prc.oAuthor
			);
			// save
			contentVersionService.save( oVersion );
			// announce event
			announceInterception( "cbadmin_postContentVersionRollback", { contentVersion = oVersion } );
			// results
			results.messages = "Version #oVersion.getVersion()# rollback was successfull!";
		} else {
			results.error = true;
			results.messages = "The versionID sent is not valid!";
		}
		// return in json
		event.renderData( type="json", data=results );
	}

	/**
	* Diff different versions
	*/
	function diff( event, rc, prc ){
		// exit handlers
		prc.xehVersionDiff 	= "#prc.cbAdminEntryPoint#.versions.diff";

		// Get the Page content
		prc.currentContent 	= contentVersionService.get( rc.version );
		prc.oldContent 		= contentVersionService.get( rc.oldVersion );
		prc.currentVersion  = prc.currentContent.getVersion();
		prc.oldVersion		= prc.oldContent.getVersion();

		// Diff them
		prc.leftA  = listToArray( prc.oldContent.getContent(), chr(10) );
		prc.rightA = listToArray( prc.currentContent.getContent(), chr(10) );
		prc.diff   = "";

		// Manual setup just in case
		if( arrayLen( prc.leftA ) GT arrayLen( prc.rightA ) ){
			prc.maxA = arrayLen( prc.leftA );
		} else {
			prc.maxA = arrayLen( prc.rightA );
		}

		announceInterception( "cbadmin_onVersionDiff" );

		// views
		event.setView( view="versions/diff", layout="ajax" );
	}

}