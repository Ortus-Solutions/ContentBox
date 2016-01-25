﻿/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Admin Dashboard
*/
component extends="baseHandler"{

	// Dependencies
	property name="entryService" 		inject="id:entryService@cb";
	property name="pageService" 		inject="id:pageService@cb";
	property name="contentService" 		inject="id:contentService@cb";
	property name="commentService" 		inject="id:commentService@cb";
	property name="categoryService"		inject="id:categoryService@cb";
	property name="feedReader"			inject="FeedReader@cbfeeds";
	property name="loginTrackerService"	inject="id:loginTrackerService@cb";

	/**
	* Pre handler 
	*/
	function preHandler( event, action, eventArguments, rc, prc ){
	}

	/**
	* Main dashboard event
	* @return html
	*/
	function index( event, rc, prc ){
		// exit Handlers
		prc.xehDeleteInstaller 		= "#prc.cbAdminEntryPoint#.dashboard.deleteInstaller";
		prc.xehDeleteDSNCreator 	= "#prc.cbAdminEntryPoint#.dashboard.deleteDSNCreator";
		// Ajax Loaded handlers
		prc.xehLatestSystemEdits	= "#prc.cbAdminEntryPoint#.dashboard.latestSystemEdits";
		prc.xehLatestUserDrafts		= "#prc.cbAdminEntryPoint#.dashboard.latestUserDrafts";
		prc.xehLatestComments		= "#prc.cbAdminEntryPoint#.dashboard.latestComments";
		prc.xehLatestNews			= "#prc.cbAdminEntryPoint#.dashboard.latestNews";
		prc.xehLatestSnapshot		= "#prc.cbAdminEntryPoint#.dashboard.latestSnapshot";
		prc.xehLatestLogins			= "#prc.cbAdminEntryPoint#.dashboard.latestLogins";
		
		// Installer Check
		prc.installerCheck = settingService.isInstallationPresent();
		// announce event
		announceInterception( "cbadmin_onDashboard" );
		// dashboard view
		event.setView( "dashboard/index" );
	}
	
	/**
	* Produce the latest system snapshots
	* @return html
	*/
	function latestSnapshot( event, rc, prc ){
		// Few counts
		prc.entriesCount			= entryService.count();
		prc.pagesCount 				= pageService.count();
		prc.commentsCount 			= commentService.count();
		prc.commentsApprovedCount 	= commentService.getApprovedCommentCount();
		prc.commentsUnApprovedCount = commentService.getUnApprovedCommentCount();
		prc.categoriesCount 		= categoryService.count();
		
		// Few Reports
		prc.topContent 		= contentService.getTopVisitedContent();
		prc.topCommented 	= contentService.getTopCommentedContent();

		// convert report to chart data
		prc.aTopContent = [];
		for( var thisContent in prc.topContent ){
			arrayAppend( prc.aTopContent, { "label" = thisContent.getTitle(), "value" = thisContent.getNumberOfHits() } );
		}
		prc.aTopContent = serializeJSON( prc.aTopContent );
		prc.aTopCommented = [];
		for( var thisContent in prc.topCommented ){
			arrayAppend( prc.aTopCommented, { "label" = thisContent.getTitle(), "value" = thisContent.getNumberOfComments() } );
		}
		prc.aTopCommented = serializeJSON( prc.aTopCommented );

		// render view out.
		event.setView( view="dashboard/latestSnapshot", layout="ajax" );
	}

	/**
	* Produce the latest currently logged in user drafts
	* @return html
	*/
	function latestUserDrafts( event, rc, prc ){
		// Latest Edits
		prc.latestDraftsViewlet = runEvent(
			event 			= "contentbox-admin:content.latestContentEdits",
			eventArguments 	= { max = 10, author = prc.oAuthor, isPublished = false }
		);
		event.setView( view="dashboard/latestUserDrafts", layout="ajax" );
	}

	/**
	* Produce the latest system content edits
	* @return html
	*/
	function latestSystemEdits( event, rc, prc ){
		// Latest Edits
		prc.latestEditsViewlet = runEvent(
			event 			= "contentbox-admin:content.latestContentEdits",
			eventArguments 	= { max=10 }
		);
		event.setView( view="dashboard/latestSystemEdits", layout="ajax" );
	}
	
	/**
	* Produce the latest system comments
	* @return html
	*/
	function latestComments( event, rc, prc ){
		// Get Comments viewlet
		var eArgs = { max=prc.cbSettings.cb_dashboard_recentComments,pagination=false };
		prc.commentsViewlet = runEvent( 
			event 			= "contentbox-admin:comments.pager", 
			eventArguments 	= eArgs 
		);
		event.setView( view="dashboard/latestComments", layout="ajax" );
	}
	
	/**
	* Produce the latest system news
	* @return html
	*/
	function latestNews( event, rc, prc ){
		// Get latest ContentBox news
		try{
			if( len( prc.cbsettings.cb_dashboard_newsfeed ) ){
				prc.latestNews = feedReader.readFeed( 
					feedURL 	= prc.cbsettings.cb_dashboard_newsfeed, 
					itemsType 	= "query", 
					maxItems 	= prc.cbsettings.cb_dashboard_newsfeed_count
				);
			} else {
				prc.latestNews = { items = queryNew( "" ) };
			}
		} catch( Any e ) {
			prc.latestNews = { items = queryNew( "" ) };
			log.error( "Error retrieving news feed: #e.message# #e.detail#", e );
		}
		
		event.setView( view="dashboard/latestNews", layout="ajax" );
	}

	/**
	* Produce the latest system logins
	* @return html
	*/
	function latestLogins( event, rc, prc ){
		prc.lastLogins = loginTrackerService.getLastLogins( max = prc.cbsettings.cb_security_blocktime );
		event.setView( view="dashboard/latestLogins", layout="ajax" );
	}

	/**
	* ContentBox about page
	* @return html
	*/
	function about( event, rc, prc ){
		event.setView( "dashboard/about" );
	}
	
	/*************************************** UTILITY ACTIONS *********************************/

	/**
	* delete installer module
	* @return JSON
	*/
	function deleteInstaller(){
		var results = { "ERROR" = false, "MESSAGE" = "" };
		
		try{
			settingService.deleteInstaller();
			results[ "MESSAGE" ] = "The installer module has been successfully deleted.";
		} catch( Any e ) {
			results[ "ERROR" ] = true;
			results[ "MESSAGE" ] = "Error removing installer: #e.message#";
		}
		
		event.renderData(data=results, type="json" );
	}
	
	/**
	* delete DSN Creator module
	* @return JSON
	*/
	function deleteDSNCreator(){
		var results = { "ERROR" = false, "MESSAGE" = "" };
		
		try{
			settingService.deleteDSNCreator();
			results[ "MESSAGE" ] = "The DSN Creator module has been successfully deleted.";
		} catch( Any e ) {
			results[ "ERROR" ] = true;
			results[ "MESSAGE" ] = "Error removing DSN Creator: #e.message#";
		}
		
		event.renderData( data=results, type="json" );
	}

	/**
	* Reload System Actions
	* @return relocation if synchronous, json if ajax
	*/
	function reload( event, rc, prc ){
		try{
			switch( rc.targetModule ){
				// reload application
				case "app" :{
					applicationStop();break;
				}
				case "orm" :{
					ormReload();break;
				}
				case "rss-purge":{
					getModel( "RSSService@cb" ).clearAllCaches( async=false ); break;
				}
				case "content-purge":{
					getModel( "ContentService@cb" ).clearAllCaches( async=false ); break;
				}
				case "contentbox-admin": case "contentbox-ui" : case "contentbox-filebrowser" : case "contentbox-security" : {
					// reload the core module first
					controller.getModuleService().reload( "contentbox" );
					// reload requested module
					controller.getModuleService().reload( rc.targetModule );
					break;
				}
				default:{
					setNextEvent( prc.xehDashboard );
				}
			}
			
			// flash info for UI purposes
			flash.put( "moduleReloaded", rc.targetModule );
			
			// Ajax requests
			if( event.isAjax() ){
				event.renderData( type="json", data={ error = false, executed = true } );
			} else {
				// relocate back to dashboard
				setNextEvent( prc.xehDashboard );
			}
		} catch( Any e ) {
			// Log Exception
			log.error( "Error running admin reload module action: #e.message# #e.detail#", e );
			// Ajax requests
			if( event.isAjax() ){
				var data = { error = true, executed = false, messages = e.message & e.detail };
				event.renderData( type="json", data=data );
			} else {
				// MessageBox
				cbMessagebox.error( "Error running admin reload module action: #e.message# #e.detail#" );
				// relocate back to dashboard
				setNextEvent( prc.xehDashboard );
			}
		}
		
	}

}
