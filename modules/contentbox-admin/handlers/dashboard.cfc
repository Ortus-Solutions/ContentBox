/**
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
	property name="settingService"		inject="id:settingService@cb";
	property name="feedReader"			inject="FeedReader@cbfeeds";
	property name="loginTrackerService"	inject="id:loginTrackerService@cb";

	// Pre Handler
	function preHandler( event, action, eventArguments, rc, prc ){
		prc.tabDashboard = true;
	}

	// dashboard index
	function index( event, rc, prc ){
		// exit Handlers
		prc.xehDeleteInstaller 		= "#prc.cbAdminEntryPoint#.dashboard.deleteInstaller";
		prc.xehDeleteDSNCreator 	= "#prc.cbAdminEntryPoint#.dashboard.deleteDSNCreator";
		// Ajax Loaded handlers
		prc.xehLatestEntries		= "#prc.cbAdminEntryPoint#.dashboard.latestEntries";
		prc.xehLatestPages			= "#prc.cbAdminEntryPoint#.dashboard.latestPages";
		prc.xehLatestContentStore	= "#prc.cbAdminEntryPoint#.dashboard.latestContentStore";
		prc.xehLatestComments		= "#prc.cbAdminEntryPoint#.dashboard.latestComments";
		prc.xehLatestNews			= "#prc.cbAdminEntryPoint#.dashboard.latestNews";
		prc.xehLatestSnapshot		= "#prc.cbAdminEntryPoint#.dashboard.latestSnapshot";
		prc.xehLatestLogins			= "#prc.cbAdminEntryPoint#.dashboard.latestLogins";
		
		// Tab Manipulation
		prc.tabDashboard_home = true;
		// Installer Check
		prc.installerCheck = settingService.isInstallationPresent();
		// announce event
		announceInterception( "cbadmin_onDashboard" );
		// dashboard view
		event.setView( "dashboard/index" );
	}
	
	// latest snapshot
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
	
	// Latest Entries
	function latestEntries( event, rc, prc ){
		// Get entries viewlet: Stupid cf9 and its local scope blown on argument literals
		var eArgs = { max=prc.cbSettings.cb_dashboard_recentEntries, pagination=false, latest=true };
		prc.entriesViewlet = runEvent( event="contentbox-admin:entries.pager", eventArguments=eArgs );
		
		event.setView( view="dashboard/latestEntries", layout="ajax" );
	}
	
	// Latest ContentStore
	function latestContentStore( event, rc, prc ){
		// Get contentStore viewlet: Stupid cf9 and its local scope blown on argument literals
		var eArgs = { max=prc.cbSettings.cb_dashboard_recentContentStore, pagination=false, latest=true };
		prc.contentStoreViewlet = runEvent( event="contentbox-admin:contentstore.pager", eventArguments=eArgs );
		
		event.setView( view="dashboard/latestContentStore", layout="ajax" );
	}
	
	// Latest Pages
	function latestPages( event, rc, prc ){
		// Get Pages viewlet
		var eArgs = { max=prc.cbSettings.cb_dashboard_recentPages,pagination=false, latest=true, sorting=false };
		prc.pagesViewlet = runEvent( event="contentbox-admin:pages.pager",eventArguments=eArgs );
		
		event.setView( view="dashboard/latestPages", layout="ajax" );
	}
	
	// Latest Comments
	function latestComments( event, rc, prc ){
		// Get Comments viewlet
		var eArgs = { max=prc.cbSettings.cb_dashboard_recentComments,pagination=false };
		prc.commentsViewlet = runEvent( event="contentbox-admin:comments.pager", eventArguments=eArgs );
	
		event.setView( view="dashboard/latestComments", layout="ajax" );
	}
	
	// Latest News
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

	// Latest logins
	function latestLogins( event, rc, prc ){
		prc.lastLogins = loginTrackerService.getLastLogins( max = prc.cbsettings.cb_security_blocktime );
		event.setView( view="dashboard/latestLogins", layout="ajax" );
	}
	
	// Delete Installer
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
	
	// Delete INstaller
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

	// about
	function about( event, rc, prc ){
		prc.tabDashboard_about = true;
		event.setView( "dashboard/about" );
	}

	// reload modules
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
				getModel( "messagebox@cbMessagebox" ).error( "Error running admin reload module action: #e.message# #e.detail#" );
				// relocate back to dashboard
				setNextEvent( prc.xehDashboard );
			}
		}
		
	}

}
