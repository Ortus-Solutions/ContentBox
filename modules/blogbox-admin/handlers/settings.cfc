/**
* Manage system settings
*/
component extends="baseHandler"{

	// Dependencies
	property name="settingsService"		inject="id:settingService@bb";
	
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
		rc.xehSaveSettings 	= "#prc.bbEntryPoint#.settings.save";
		// tab
		prc.tabSystem_Settings = true; 
		// view
		event.setView("settings/index");
	}
	
	// custom HTML
	function customHTML(event,rc,prc){
		// exit handler
		rc.xehSaveSettings 	= "#prc.bbEntryPoint#.settings.save";
		// tab
		prc.tabSite 			= true;
		prc.tabSite_customHTML 	= true; 
		// view
		event.setView("settings/index");
	}
	
	// save settings
	function save(event,rc,prc){
		
		// bulk save the options
		settingsService.bulkSave(rc);
		
		// relocate back to editor
		getPlugin("MessageBox").info("All BlogBox settings updated! Yeeehaww!");
		setNextEvent(rc.xehSettings);
	}
	
	// raw settings manager
	function raw(event,rc,prc){
		// params
		event.paramValue("page",1);
		
		// exit Handlers
		rc.xehSettingRemove = "#prc.bbEntryPoint#.settings.remove";
		rc.xehSettingSave 	= "#prc.bbEntryPoint#.settings.saveRaw";
		rc.xehFlushCache    = "#prc.bbEntryPoint#.settings.flushCache";
		rc.xehViewCached    = "#prc.bbEntryPoint#.settings.viewCached";
		
		// prepare paging plugin
		rc.pagingPlugin = getMyPlugin(plugin="Paging",module="blogbox");
		rc.paging 		= rc.pagingPlugin.getBoundaries();
		rc.pagingLink 	= event.buildLink('#rc.xehRawSettings#.page.@page@?');
		
		// Get all settings
		rc.settings = settingsService.list(sortOrder="name",asQuery=false,offset=rc.paging.startRow-1,max=prc.bbSettings.bb_paging_maxrows);
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
		setNextEvent(event=rc.xehRawSettings,queryString="page=#rc.page#");
	}
	
	// remove
	function remove(event,rc,prc){
		// delete by id
		if( !settingsService.deleteByID( rc.settingID ) ){
			getPlugin("MessageBox").setMessage("warning","Invalid Setting detected!");
		}
		else{
			settingsService.flushSettingsCache();
			getPlugin("MessageBox").setMessage("info","Setting Removed!");
		}
		setNextEvent(rc.xehRawSettings);
	}
	
	// flush cache
	function flushCache(event,rc,prc){
		settingsService.flushSettingsCache();
		getPlugin("MessageBox").setMessage("info","Settings Flushed From Cache");
		setNextEvent(rc.xehRawSettings);
	}
	
	// View cached Keys
	function viewCached(event,rc,prc){
		var key = settingsService.getSettingsCacheKey();
		rc.settings = getColdBoxOCM().get( key );
		rc.metadata = getColdBoxOCM().getCachedObjectMetadata( key );
		event.setView(view="settings/viewCached",layout="ajax");
	}
	
}
