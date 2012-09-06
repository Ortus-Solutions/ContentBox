/**
* The base model test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.ui.editors.EditAreaEditor"{

	void function setup(){
		super.setup();
		
		mockInterceptorService = getMockBox().createEmptyMock("coldbox.system.web.services.InterceptorService")
			.$("appendInterceptionPoints");
		mockEvent = getMockRequestContext();
		mockRequestService = getMockBox().createEmptyMock("coldbox.system.web.services.RequestService")
			.$("getContext", mockEvent);
		mockModuleSettings = {
			"contentbox-admin" = { entryPoint = "cbadmin" }
		};
		mockColdBox = getMockBox().createEmptyMock("coldbox.system.web.Controller")
			.$("getInterceptorService", mockInterceptorService)
			.$("getRequestService", mockRequestService)
			.$("getSetting").$args("modules").$results( mockModuleSettings )
			.$("getSetting").$args("htmlBaseURL").$results( "http://localhost/index.cfm" );
		
		// init the model object
		model.init( mockColdBox );
	}
	
	function testStartup(){
		mockEvent.$("getValue", "cbadmin")
			.$("buildLink", "http://localhost/cbadmin/ckeditor");
		
		t = model.startup();
		
		debug( t );
	}
	
}
