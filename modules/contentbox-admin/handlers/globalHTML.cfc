/**
* Manage global HTML in the system
*/
component extends="baseHandler"{

	// Dependencies
	property name="settingsService"		inject="id:settingService@cb";
	
	// index
	function index(event,rc,prc){
		event.paramValue("search","");
		event.paramValue("page",1);
		
		// Exit Handler
		prc.xehSaveHTML = "#prc.cbAdminEntryPoint#.globalHTML.save";
		
		// tab
		prc.tabContent				= true;
		prc.tabContent_globalHTML	= true; 
		
		// view
		event.setView("globalHTML/index");
	}
	
	// save html
	function save(event,rc,prc){
		
		// announce event
		announceInterception("cbadmin_preGlobalHTMLSave",{oldSettings=prc.cbSettings,newSettings=rc});
		
		// bulk save the options
		settingsService.bulkSave(rc);
		
		// announce event
		announceInterception("cbadmin_postGlobalHTMLSave");
		
		// relocate back to editor
		getPlugin("MessageBox").info("All Global HTML updated! Yeeehaww!");
		
		setNextEvent(prc.xehGlobalHTML);
	}
	
}
