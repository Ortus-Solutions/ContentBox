﻿/**
* Manage system settings
*/
component extends="baseHandler"{

	// Dependencies
	property name="settingsService"		inject="id:settingService@cb";
	property name="pageService"			inject="id:pageService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";
	property name="editorService"		inject="id:editorService@cb";
	
	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab control
		prc.tabSystem = true;
	}

	// index
	function index(event,rc,prc){
		// Exit Handler
		prc.xehSaveSettings 	= "#prc.cbAdminEntryPoint#.settings.save";
		// pages
		prc.pages = pageService.search(sortOrder="slug asc",isPublished=true).pages;
		// Get All registered editors so we can display them
		prc.editors = editorService.getRegisteredEditorsMap();
		// Get All registered markups so we can display them
		prc.markups = editorService.getRegisteredMarkups();
		// tab
		prc.tabSystem_Settings = true;
		// cb helper
		prc.cb = CBHelper;
		// caches
		prc.cacheNames = cachebox.getCacheNames();
		// view
		event.setView("settings/index");
	}

	// save settings
	function save(event,rc,prc){
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
	function raw(event,rc,prc){
		// params
		event.paramValue("page",1);
		event.paramValue("viewall",false);

		// exit Handlers
		prc.xehSettingRemove 	= "#prc.cbAdminEntryPoint#.settings.remove";
		prc.xehSettingsave 		= "#prc.cbAdminEntryPoint#.settings.saveRaw";
		prc.xehFlushCache    	= "#prc.cbAdminEntryPoint#.settings.flushCache";
		prc.xehFlushSingletons  = "#prc.cbAdminEntryPoint#.settings.flushSingletons";
		prc.xehViewCached    	= "#prc.cbAdminEntryPoint#.settings.viewCached";
		prc.xehMappingDump		= "#prc.cbAdminEntryPoint#.settings.mappingDump";

		// prepare paging plugin
		prc.pagingPlugin = getMyPlugin(plugin="Paging",module="contentbox");
		prc.paging 		= prc.pagingPlugin.getBoundaries();
		prc.pagingLink 	= event.buildLink('#prc.xehRawSettings#.page.@page@?');

		// Get all settings
		var args = {
			sortOrder = "name asc", asQuery = false,
			offset = prc.paging.startRow-1, max = prc.cbSettings.cb_paging_maxrows
		};
		if( rc.viewAll ){ args.offset = args.max = 0; }
		prc.settings = settingsService.list(argumentCollection=args);
		prc.settingsCount = settingsService.count();

		// Get Singletons
		prc.singletons = wirebox.getScope("singleton").getSingletons();

		// Raw tab
		prc.tabSystem_geekSettings = true;
		// view
		event.setView("settings/raw");
	}

	// mappingDump
	function mappingDump(event,rc,prc){
		// params
		event.paramValue("id","");
		prc.mapping = wirebox.getBinder().getMapping( rc.id );
		event.setView(view="settings/mappingDump",layout="ajax");
	}

	// saveRaw
	function saveRaw(event,rc,prc){
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
	function remove(event,rc,prc){
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
	function flushCache(event,rc,prc){
		settingsService.flushSettingsCache();
		getPlugin("MessageBox").setMessage("info","Settings Flushed From Cache");
		setNextEvent(prc.xehRawSettings);
	}

	// flush singletons
	function flushSingletons(event,rc,prc){
		wirebox.clearSingletons();
		getPlugin("MessageBox").setMessage("info","All singletons flushed and awaiting re-creation.");
		setNextEvent(event=prc.xehRawSettings,queryString="##wirebox");
	}

	// View cached Keys
	function viewCached(event,rc,prc){
		var key = settingsService.getSettingsCacheKey();
		rc.settings = getColdBoxOCM().get( key );
		rc.metadata = getColdBoxOCM().getCachedObjectMetadata( key );
		event.setView(view="settings/viewCached",layout="ajax");
	}

}
