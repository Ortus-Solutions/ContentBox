﻿/**
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

	function preHandler(event,action,eventArguments,rc,prc){
		prc.tabDashboard	  = true;
	}

	// dashboard index
	function index(event,rc,prc){

		// exit Handlers
		prc.xehEntryEditor		= "#prc.cbAdminEntryPoint#.entries.editor";
		prc.xehEntrySave		= "#prc.cbAdminEntryPoint#.entries.save";
		prc.xehRemoveComment	= "#prc.cbAdminEntryPoint#.comments.remove";
		prc.xehDeleteInstaller 	= "#prc.cbAdminEntryPoint#.dashboard.deleteInstaller";
		prc.xehDeleteDSNCreator = "#prc.cbAdminEntryPoint#.dashboard.deleteDSNCreator";

		// Tab Manipulation
		prc.tabDashboard_home = true;
		
		// Installer Check
		prc.installerCheck = settingService.isInstallationPresent();

		// Get entries viewlet: Stupid cf9 and its local scope blown on argument literals
		var eArgs = {max=prc.cbSettings.cb_dashboard_recentEntries,pagination=false, latest=true};
		prc.entriesViewlet = runEvent(event="contentbox-admin:entries.pager",eventArguments=eArgs);
		// Get Pages viewlet
		var eArgs = {max=prc.cbSettings.cb_dashboard_recentPages,pagination=false, latest=true, sorting=false};
		prc.pagesViewlet = runEvent(event="contentbox-admin:pages.pager",eventArguments=eArgs);
		// Get Comments viewlet
		var eArgs = {max=prc.cbSettings.cb_dashboard_recentComments,pagination=false};
		prc.commentsViewlet = runEvent(event="contentbox-admin:comments.pager",eventArguments=eArgs);
	
		// Get latest ContentBox news
		try{
			prc.latestNews = getModel( "contentbox-news@cbadmin" );
		}
		catch(Any e){
			prc.latestNews = { metadata = {}, items = queryNew("") };
		}
		
		// Few counts
		prc.entriesCount 			= entryService.count();
		prc.pagesCount 				= pageService.count();
		prc.commentsCount 			= commentService.count();
		prc.commentsApprovedCount 	= commentService.getApprovedCommentCount();
		prc.commentsUnApprovedCount = commentService.getUnApprovedCommentCount();
		prc.categoriesCount 		= categoryService.count();
		
		// Few Reports
		prc.topContent 		= contentService.getTopVisitedContent();
		prc.topCommented 	= contentService.getTopCommentedContent();
		
		// announce event
		announceInterception("cbadmin_onDashboard");

		// dashboard view
		event.setView("dashboard/index");
	}
	
	// Delete Installer
	function deleteInstaller(){
		var results = { "ERROR" = false, "MESSAGE" = "" };
		
		try{
			settingService.deleteInstaller();
			results[ "MESSAGE" ] = "The installer module has been successfully deleted.";
		}
		catch(Any e){
			results[ "ERROR" ] = true;
			results[ "MESSAGE" ] = "Error removing installer: #e.message#";
		}
		
		event.renderData(data=results, type="json");
	}
	
	// Delete INstaller
	function deleteDSNCreator(){
		var results = { "ERROR" = false, "MESSAGE" = "" };
		
		try{
			settingService.deleteDSNCreator();
			results[ "MESSAGE" ] = "The DSN Creator module has been successfully deleted.";
		}
		catch(Any e){
			results[ "ERROR" ] = true;
			results[ "MESSAGE" ] = "Error removing DSN Creator: #e.message#";
		}
		
		event.renderData(data=results, type="json");
	}

	// about
	function about(event,rc,prc){
		prc.tabDashboard_about = true;
		event.setView("dashboard/about");
	}

	// reload modules
	function reload(event,rc,prc){

		try{
			switch(rc.targetModule){
				// reload application
				case "app" :{
					applicationStop();break;
				}
				case "orm" :{
					ormReload();break;
				}
				case "rss-purge":{
					getModel("RSSService@cb").clearAllCaches(async=false); break;
				}
				case "content-purge":{
					getModel("ContentService@cb").clearAllCaches(async=false); break;
				}
				case "contentbox-admin": case "contentbox-ui" : case "contentbox-filebrowser" : {
					// reload the core module first
					controller.getModuleService().reload( "contentbox" );
					// reload requested module
					controller.getModuleService().reload( rc.targetModule );
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
			}
			else{
				// relocate back to dashboard
				setNextEvent( prc.xehDashboard );
			}
		}
		catch(Any e){
			// Log Exception
			log.error( "Error running admin reload module action: #e.message# #e.detail#", e );
			// Ajax requests
			if( event.isAjax() ){
				var data = { error = true, executed = false, messages = e.message & e.detail };
				event.renderData( type="json", data=data );
			}
			else{
				// MessageBox
				getPlugin("MessageBox").error( "Error running admin reload module action: #e.message# #e.detail#" );
				// relocate back to dashboard
				setNextEvent( prc.xehDashboard );
			}
		}
		
		
		
	}

}
