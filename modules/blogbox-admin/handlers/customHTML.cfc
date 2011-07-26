/**
* Manage system settings
*/
component extends="baseHandler"{

	// Dependencies
	property name="settingsService"		inject="id:settingService@bb";
	
	// index
	function index(event,rc,prc){
		// Exit Handler
		rc.xehSaveHTML 	= "#prc.bbEntryPoint#.customHTML.save";
		// tab
		prc.tabSite				= true;
		prc.tabSite_customHTML	= true; 
		// view
		event.setView("customHTML/index");
	}
	
	// save settings
	function save(event,rc,prc){
		
		// bulk save the options
		settingsService.bulkSave(rc);
		
		// relocate back to editor
		getPlugin("MessageBox").info("Custom HTML saved! Isn't that majestic!");
		setNextEvent(rc.xehCustomHTML);
	}
	
}
