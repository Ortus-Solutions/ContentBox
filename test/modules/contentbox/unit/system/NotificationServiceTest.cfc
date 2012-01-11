/**
* The base interceptor test case will use the 'interceptor' annotation as the instantiation path to the interceptor
* and then create it, prepare it for mocking, and then place it in the variables scope as 'interceptor'. It is your
* responsibility to update the interceptor annotation instantiation path.
*/
component extends="coldbox.system.testing.BaseInterceptorTest" interceptor="contentbox.model.system.NotificationService"{
	
	/**
	* You can remove this setup method if you do not have anything to setup
	*/
	void function setup(){
		// interceptor configuration properties, if any
		configProperties = {};
		// init and configure interceptor
		super.setup();
		// we are now ready to test this interceptor
	}
	
	function testConfigure(){
		// any mocking here
		
		// test configure
		interceptor.configure();
	}



}
