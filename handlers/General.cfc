component{	function index(event,rc,prc){		rc.welcomeMessage = "Welcome to ColdBox!";		event.setView("home");	}		function viewlet(event,rc,prc){		return "I am a cool viewlet";
	}}