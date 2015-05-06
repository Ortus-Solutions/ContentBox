﻿/**
* Manage system settings
*/
component extends="baseHandler"{

	// Dependencies
	property name="settingsService"		inject="id:settingService@cb";
	property name="pageService"			inject="id:pageService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";
	property name="editorService"		inject="id:editorService@cb";
	property name="mediaService"		inject="id:mediaService@cb";
	property name="adminThemeService"	inject="id:adminThemeService@cb";
	property name="LoginTrackerService"	inject="id:LoginTrackerService@cb";
	
	// pre handler
	function preHandler( event, rc, prc, action, eventArguments ){
		// Tab control
		prc.tabSystem = true;
	}

	// index
	function index( event, rc, prc ){
		// Exit Handler
		prc.xehSaveSettings = "#prc.cbAdminEntryPoint#.settings.save";
		prc.xehEmailTest	= "#prc.cbAdminEntryPoint#.settings.emailTest";
		// pages
		prc.pages = pageService.search(sortOrder="slug asc",isPublished=true).pages;
		// Get All registered editors so we can display them
		prc.editors = editorService.getRegisteredEditorsMap();
		// Get all registered admin themes
		prc.adminThemes = adminThemeService.getRegisteredThemesMap();
		// Get All registered markups so we can display them
		prc.markups = editorService.getRegisteredMarkups();
		// Get all registered media providers so we can display them
		prc.mediaProviders = mediaService.getRegisteredProvidersMap();
		// tab
		prc.tabSystem_Settings = true;
		// cb helper
		prc.cb = CBHelper;
		// caches
		prc.cacheNames = cachebox.getCacheNames();
		// view
		event.setView("settings/index");
	}
	
	// email test
	function emailTest( event, rc, prc ){
		var mailService = getPlugin( "MailService" );
		var mail = mailservice.newMail(to=rc.cb_site_outgoingEmail,
									   from=rc.cb_site_outgoingEmail,
									   subject="ContentBox Test",
									   server=rc.cb_site_mail_server,
									   username=rc.cb_site_mail_username,
									   password=rc.cb_site_mail_password,
									   port=rc.cb_site_mail_smtp,
									   useTLS=rc.cb_site_mail_tls,
									   useSSL=rc.cb_site_mail_ssl,
									   body='Test Email From ContentBox');
		// send it out
		var results = mailService.send( mail );
		
		event.renderData(data=results, type="json");		
	}

	// save settings
	function save( event, rc, prc ){
		// announce event
		announceInterception("cbadmin_preSettingsSave",{oldSettings=prc.cbSettings,newSettings=rc});
		// bulk save the options
		settingsService.bulkSave(rc);
		// Do blog entry point change
		var ses = getInterceptor("SES");
		var routes = ses.getRoutes();
		for( var key in routes ){
			if( key.namespaceRouting eq "blog" ){
				key.pattern = key.regexpattern = replace(  rc[ "cb_site_blog_entrypoint" ] , "/", "-", "all" ) & "/";
			}
		}
		ses.setRoutes( routes );
		// announce event
		announceInterception("cbadmin_postSettingsSave");
		// relocate back to editor
		getPlugin("MessageBox").info("All ContentBox settings updated! Yeeehaww!");
		setNextEvent(prc.xehSettings);
	}

	// raw settings manager
	function raw( event, rc, prc ){
		// exit Handlers
		prc.xehSettingRemove 	= "#prc.cbAdminEntryPoint#.settings.remove";
		prc.xehSettingsave 		= "#prc.cbAdminEntryPoint#.settings.saveRaw";
		prc.xehFlushCache    	= "#prc.cbAdminEntryPoint#.settings.flushCache";
		prc.xehFlushSingletons  = "#prc.cbAdminEntryPoint#.settings.flushSingletons";
		prc.xehViewCached    	= "#prc.cbAdminEntryPoint#.settings.viewCached";
		prc.xehMappingDump		= "#prc.cbAdminEntryPoint#.settings.mappingDump";
		prc.xehRawSettingsTable	= "#prc.cbAdminEntryPoint#.settings.rawtable";
		prc.xehExportAll		= "#prc.cbAdminEntryPoint#.settings.exportAll";
		prc.xehSettingsImport	= "#prc.cbAdminEntryPoint#.settings.importAll";

		// Get Interception Points
		prc.interceptionPoints = controller.getInterceptorService().getInterceptionPoints();
		arraySort( prc.interceptionPoints, "textnocase" );
		// Get Singletons
		prc.singletons = wirebox.getScope("singleton").getSingletons();
		// Raw tab
		prc.tabSystem_geekSettings = true;
		// view
		event.setView("settings/raw");
	}
	
	// Export All settings
	function exportAll( event, rc, prc ){
		event.paramValue("format", "json");
		
		// get all prepared content objects
		var data  		= settingsService.getAllForExport();
		var filename 	= "Settings." & ( rc.format eq "xml" ? "xml" : "json" );
				
		event.renderData( data=data, formats="xml,json", xmlRootName="settings" )
			.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#");
	}

	// import settings
	function importAll( event, rc, prc ){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideSettings", false );
		try{
			if( len( rc.importFile ) and fileExists( rc.importFile ) ){
				var importLog = settingsService.importFromFile( importFile=rc.importFile, override=rc.overrideSettings );
				getPlugin("MessageBox").info( "Settings imported sucessfully!" );
				flash.put( "importLog", importLog );
			}
			else{
				getPlugin("MessageBox").error( "The import file is invalid: #rc.importFile# cannot continue with import" );
			}
		}
		catch(any e){
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stacktrace#";
			log.error( errorMessage, e );
			getPlugin("MessageBox").error( errorMessage );
		}
		setNextEvent( prc.xehRawSettings );
	}

	// retrieve raw settings table
	function rawtable( event, rc, prc ){
		// params
		event.paramValue( "page", 1 );
		event.paramValue( "search", "" );
		event.paramValue( "viewAll", false );
		
		// prepare paging plugin
		prc.pagingPlugin = getMyPlugin(plugin="Paging",module="contentbox");
		prc.paging 		= prc.pagingPlugin.getBoundaries();
		prc.pagingLink 	= event.buildLink('#prc.xehRawSettings#.page.@page@?');
		prc.pagingLink 	= "javascript:settingsPaginate(@page@)";
		
		// View all?
		var offset  = prc.paging.startRow-1;
		var max		= prc.cbSettings.cb_paging_maxrows;
		if( rc.viewAll ){ offset = max = 0; }
		
		// Get settings
		var results = settingsService.search(search=rc.search, offset=offset, max=max);
		prc.settings = results.settings;
		prc.settingsCount = results.count;
		
		event.setView(view="settings/rawSettingsTable", layout="ajax");
	}

	// mappingDump
	function mappingDump( event, rc, prc ){
		// params
		event.paramValue("id","");
		prc.mapping = wirebox.getBinder().getMapping( rc.id );
		event.setView(view="settings/mappingDump",layout="ajax");
	}

	// saveRaw
	function saveRaw( event, rc, prc ){
		// params
		event.paramValue("page",1);

		// populate and get setting
		var setting = populateModel( settingsService.get(id=rc.settingID) );
    	// save new setting
		settingsService.save( setting );
		settingsService.flushSettingsCache();
		// messagebox
		getPlugin("MessageBox").setMessage("info","Setting saved!");
		// relocate
		setNextEvent(event=prc.xehRawSettings,queryString="page=#rc.page#");
	}

	// remove
	function remove( event, rc, prc ){
		// announce event
		announceInterception("cbadmin_preSettingRemove",{settingID=rc.settingID});
		// delete by id
		if( !settingsService.deleteByID( rc.settingID ) ){
			getPlugin("MessageBox").setMessage("warning","Invalid Setting detected!");
		}
		else{
			// announce event
			announceInterception("cbadmin_postSettingRemove",{settingID=rc.settingID});
			// flush cache
			settingsService.flushSettingsCache();
			getPlugin("MessageBox").setMessage("info","Setting Removed!");
		}
		setNextEvent(prc.xehRawSettings);
	}

	// flush cache
	function flushCache( event, rc, prc ){
		var data = { error = false, messages = "" };
		try{
			settingsService.flushSettingsCache();
			data.messages = "Settings cache flushed!";
		}
		catch(Any e){
			data["ERROR"] = true;
			data["MESSAGES"] = "Error executing flush, please check logs: #e.message#";
			log.error( e.message & e.detail, e );
		}
		event.renderData(data=data, type="json");
	}

	// flush singletons
	function flushSingletons( event, rc, prc ){
		wirebox.clearSingletons();
		getPlugin("MessageBox").setMessage("info","All singletons flushed and awaiting re-creation.");
		setNextEvent(event=prc.xehRawSettings,queryString="##wirebox");
	}

	// View cached Keys
	function viewCached( event, rc, prc ){
		var key = settingsService.getSettingsCacheKey();
		rc.settings = getColdBoxOCM().get( key );
		rc.metadata = getColdBoxOCM().getCachedObjectMetadata( key );
		event.setView(view="settings/viewCached",layout="ajax");
	}

	// Show full Auth Logs
	function authLogs( event, rc, prc ){
		prc.featureEnabled 	= prc.cbsettings.cb_security_login_blocker;
		prc.xehTruncate 	= "#prc.cbAdminEntryPoint#.settings.truncateAuthLogs";

		if( prc.featureEnabled ){
			prc.logs = loginTrackerService.getAll( sortOrder="attempts", asQuery=false );
		} else {
			prc.featureEnabled = false;
		}

		event.setView( "settings/authLogs" );
	}

	/**
	* truncateAuthLogs
	*/
	any function truncateAuthLogs( event, rc, prc ){
		loginTrackerService.truncate();
		setNextEvent( "#prc.cbAdminEntryPoint#.settings.authLogs" );
	}

}
