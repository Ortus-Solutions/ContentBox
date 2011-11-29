/**
* The ContentBox installer handler
*/
component{
	
	function preHandler(event,currentAction){
		var prc = event.getCollection(private=true);
		// setup asset root from administrator as that is the holder of 
		// all things assets :)
		prc.assetRoot = getModuleSettings("contentbox-admin").mapping;
	}

	function index(event){
		event.setView("home/index");
	}

}