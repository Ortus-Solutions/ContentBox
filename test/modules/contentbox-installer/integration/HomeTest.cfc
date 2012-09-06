component extends="coldbox.system.testing.BaseTestCase" appMapping="/"{
	
	/**
	* You can remove this setup method if you do not have anything to setup
	*/
	void function setup(){
		//Call the super setup method to setup the app.
		super.setup();
		
		// Your own setup here if needed
	}

	function testindex(){
		
		event = execute("contentbox-installer:Home.index");
		
	}
	
	function testFinished(){
		
		event = execute("contentbox-installer:Home.finished");
		
	}


}
