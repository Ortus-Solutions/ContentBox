/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
*/
component extends="coldbox.system.testing.BaseInterceptorTest" interceptor="contentbox.models.system.NotificationService"{
	
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
