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
	
	// index - raw settings
	function index(event,rc,prc){
		// Get all settings
		rc.settings = settingsService.list(sortOrder="name desc",asQuery=false);
		// view
		event.setView("settings/index");
	}
	
	// raw settings manager
	function raw(event,rc,prc){
		// exit Handlers
		rc.xehSettingRemove = "#prc.bbEntryPoint#.settings.remove";
		rc.xehSettingSave 	= "#prc.bbEntryPoint#.settings.save";
		rc.xehFlushCache    = "#prc.bbEntryPoint#.settings.flushCache";
		rc.xehViewCached    = "#prc.bbEntryPoint#.settings.viewCached";
		// Get all settings
		rc.settings = settingsService.list(sortOrder="name desc",asQuery=false);
		// Raw tab
		prc.tabSystem_rawSettings = true;
		// view
		event.setView("settings/raw");
	}	

	// save
	function save(event,rc,prc){
		// populate and get setting
		var setting = populateModel( settingsService.get(id=rc.settingID) );
    	// save new setting
		settingsService.save( setting );
		settingsService.flushSettingsCache();
		// messagebox
		getPlugin("MessageBox").setMessage("info","Setting saved!");
		// relocate
		setNextEvent(rc.xehRawSettings);
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
