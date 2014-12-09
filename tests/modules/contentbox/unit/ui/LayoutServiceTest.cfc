/**
* The base model test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.ui.LayoutService"{

	void function setup(){
		super.setup();
		
		// init the model object
		model.init();
		mockCBHelper = getMockBox().createStub();
		model.$property( "wirebox", "variables", mockWirebox );
		model.$property( "cbHelper", "variables", mockCBHelper );
	}

	function testOnDIComplete(){
		moduleSettings = {
			"contentbox" = { 
				path = expandPath( "/modules/contentbox" ),
				mapping = "/modules/contentbox",
				invocationPath = "modules.contentbox"
			}
		};
		model.$property("moduleSettings", "variables", moduleSettings)
			.$("buildLayoutRegistry", queryNew(""));
			
		model.onDIComplete();
		assertTrue( model.$once( "buildLayoutRegistry" ) );
	}
	
	function testBuildLayoutRegistry(){
		//mocks
		moduleSettings = {
			"contentbox" = { 
				path = expandPath( "/modules/contentbox" ),
				mapping = "/modules/contentbox",
				invocationPath = "modules.contentbox"
			}
		};
		model.$property("moduleSettings", "variables", moduleSettings);
		model.onDICOmplete();
		model.buildLayoutRegistry();
	}
	
	function testRemoveLayout(){
		// 1 No layout name
		r = model.removeLayout( "" );
		assertFalse( r );
		
		// 2 real layout test
		
		// mocks
		mockLayout = getMockBox().createStub().$("onDelete");
		mockLayout.settings = {};
		model.setlayoutCFCRegistry( { "unittest" = mockLayout } );
		model.setLayoutsPath( expandPath( "/modules/contentbox/layouts" ) );
		model.$("unregisterLayoutSettings")
			.$("buildLayoutRegistry", queryNew("") );
		
		directoryCreate( model.getLayoutsPath() & "/unittest" );
		r = model.removeLayout( "unittest" );
		assertTrue( r );
		assertTrue( mockLayout.$once("onDelete") );
		assertTrue( model.$once( "unregisterLayoutSettings" ) );
		assertTrue( model.$once( "buildLayoutRegistry" ) );
		assertFalse( structKeyExists( model.getLayoutCFCRegistry(), "unittest" ) );
	}
	
	function testthemeMaintenanceViewExists(){
		// No
		mockCBHelper.$("layoutRoot", "/");
		assertFalse( model.themeMaintenanceViewExists() );
		
		// No
		mockCBHelper.$("layoutRoot", "/modules/contentbox/layouts/default");
		assertTrue( model.themeMaintenanceViewExists() );
	}
	
	function testgetThemeMaintenanceLayout(){
		// default
		mockCBHelper.$("layoutRoot", "/");
		r = model.getThemeMaintenanceLayout();
		assertEquals( "pages", r );
		
		// Valid
		mockCBHelper.$("layoutRoot", "/modules/contentbox/layouts/default");
		r = model.getThemeMaintenanceLayout();
		assertEquals( "maintenance", r );
	}
	
	function testgetThemeSearchLayout(){
		// default
		mockCBHelper.$("layoutRoot", "/");
		r = model.getThemeSearchLayout();
		assertEquals( "pages", r );
		
		// Valid
		mockCBHelper.$("layoutRoot", "/modules/contentbox/layouts/default");
		r = model.getThemeSearchLayout();
		assertEquals( "search", r );
		
	}
}
