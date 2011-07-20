/**
* This simulates the onRequest start for the UI interface
*/
component extends="coldbox.system.Interceptor"{

	property name="settingService"  inject="id:settingService@bb";

	/**
	* Configure BB Request
	*/ 
	function configure(){}

	/**
	* Fired on blogbox requests
	*/
	function preProcess(event, interceptData) eventPattern="^blogbox-admin"{
		var prc = event.getCollection(private=true);
		var rc	= event.getCollection();
		
		// store module root	
		prc.bbRoot = event.getModuleRoot();
		// store module entry point
		prc.bbEntryPoint = getProperty("entryPoint");
		// Place global bb options on scope
		prc.bbSettings = settingService.getAllSettings(asStruct=true);
		
		/************************************** NAVIGATION EXIT HANDLERS *********************************************/
	
	}	
				
}