/**
* The ContentBox installer handler
*/
component{

	// DI
	property name="installerService" inject="id:installerService@cbi";
	property name="settingService" 	 inject="id:settingService@cb";
	
	function preHandler(event,currentAction){
		var prc = event.getCollection(private=true);
		// setup asset root from administrator as that is the holder of 
		// all things assets :)
		prc.assetRoot = getModuleSettings("contentbox-admin").mapping;
	}

	function index(event,rc,prc){
		event.setView("home/index");
	}
	
	function install(event,rc,prc){
		// Verify installed?
		if( settingService.isCBReady() ){
			getPlugin("MessageBox").warn("Cannot run installer again as ContentBox is already installed.");
			setNextEvent(  getModuleSettings("contentbox-admin").entryPoint );
		}
		// start installation
		installerService.execute( populateModel("SetupBean@cbi") );
		
		// Take them to the finalized screen
		setNextEvent("cbinstaller/finished");
	}
	
	function finished(event,rc,prc){
		prc.xehAdmin = getModuleSettings("contentbox-admin").entryPoint;
		prc.xehSite  = getModuleSettings("contentbox-ui").entryPoint;
		
		event.setView("home/finished");
	}

}