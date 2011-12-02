/**
* The ContentBox installer handler
*/
component{

	// DI
	property name="installerService" inject="id:installerService@cbi";
	
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
		// start installation
		installerService.execute( populateModel("SetupBean@cbi") );
		
		// Take them to the admin now
		getPlugin("MessageBox").info("Setup complete! Log in to your ContentBox installation now.");
		setNextEvent( getModuleSettings("contentbox-admin").entryPoint );
	}

}