/**
* Manage system settings
*/
component extends="baseHandler"{

	// Dependencies
	property name="settingsService"		inject="entityService:bbSetting";
	
	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab control
		prc.tabSystem = true;
	}
	
	// index
	function index(event,rc,prc){
		// exit Handlers
		rc.xehSettingRemove = "#prc.bbEntryPoint#.settings.remove";
		rc.xehSettingSave 	= "#prc.bbEntryPoint#.settings.save";
		// Get all settings
		rc.settings = settingsService.list(sortOrder="name desc",asQuery=false);
		// view
		event.setView("settings/index");
	}

	// save
	function save(event,rc,prc){
		// populate and get setting
		var setting = populateModel( settingsService.get(id=rc.settingID) );
    	// save category
		settingsService.save( setting );
		// messagebox
		getPlugin("MessageBox").setMessage("info","Setting saved!");
		// relocate
		setNextEvent(rc.xehSettings);
	}
	
	// remove
	function remove(event,rc,prc){
		// delete by id
		if( !settingsService.deleteByID( rc.settingID ) ){
			getPlugin("MessageBox").setMessage("warning","Invalid Setting detected!");
		}
		else{
			getPlugin("MessageBox").setMessage("info","Setting Removed!");
		}
		setNextEvent(rc.xehSettings);
	}
}
