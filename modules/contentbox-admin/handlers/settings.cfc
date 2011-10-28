/**
* Manage system settings
*/
component extends="baseHandler"{

	// Dependencies
	property name="settingsService"		inject="id:settingService@cb";
	property name="pageService"			inject="id:pageService@cb";
	
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
		prc.pages = pageService.search().pages;
		// tab
		prc.tabSystem_Settings = true; 
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
		
		// exit Handlers
		rc.xehSettingRemove = "#prc.cbAdminEntryPoint#.settings.remove";
		prc.xehSettingsave 	= "#prc.cbAdminEntryPoint#.settings.saveRaw";
		rc.xehFlushCache    = "#prc.cbAdminEntryPoint#.settings.flushCache";
		rc.xehViewCached    = "#prc.cbAdminEntryPoint#.settings.viewCached";
		
		// prepare paging plugin
		rc.pagingPlugin = getMyPlugin(plugin="Paging",module="contentbox");
		rc.paging 		= rc.pagingPlugin.getBoundaries();
		rc.pagingLink 	= event.buildLink('#prc.xehRawSettings#.page.@page@?');
		
		// Get all settings
		rc.settings = settingsService.list(sortOrder="name",asQuery=false,offset=rc.paging.startRow-1,max=prc.cbSettings.cb_paging_maxrows);
		rc.settingsCount = settingsService.count();
		// Raw tab
		prc.tabSystem_rawSettings = true;
		// view
		event.setView("settings/raw");
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
	
	// View cached Keys
	function viewCached(event,rc,prc){
		var key = settingsService.getSettingsCacheKey();
		rc.settings = getColdBoxOCM().get( key );
		rc.metadata = getColdBoxOCM().getCachedObjectMetadata( key );
		event.setView(view="settings/viewCached",layout="ajax");
	}
	
}
