/**
* The base model test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.security.Author"{

	void function setup(){
		super.setup();
		
		// init the model object
		model.init( );
	}
	
	function testIsLoaded(){
		assertFalse( model.isLoaded() );
		testUser = entityLoad("cbAuthor")[1];
		assertTrue( testUser.isLoaded() );
	}
	
	function testGetDisplayCreateDate(){
		d = model.getDisplayCreatedDate();
		assertEquals( "", d );
		testUser = entityLoad("cbAuthor")[1];
		d = testUser.getDisplayCreatedDate();
		assertTrue( len(d) );
	}
	
	function testgetDisplayLastLogin(){
		d = model.getDisplayLastLogin();
		assertEquals( "Never", d );
		testUser = entityLoad("cbAuthor")[1];
		d = testUser.getDisplayLastLogin();
		assertNotEquals( "Never", d );
	}
	
	function testGetSetAllPreferences(){
		assertEquals( {}, model.getAllPreferences() );
		var pref = {
			editor = "textarea", test = "nada"
		};
		model.setPreferences( pref );
		assertTrue( isJSON( model.getPreferences() ) , "JSON Preferences Failed");
		assertEquals( pref, model.getAllPreferences() , "JSON Inflation of Preferences Failed");
	}
	
	function testGetPreference(){
		// with default
		v = model.getPreference("invalid", "test");
		assertEquals( "test", v , "Failed with default value" );
		// existent
		var pref = {
			editor = "textarea", test = "nada"
		};
		model.setPreferences( pref );
		assertEquals( "textarea", model.getPreference("editor"), "Failed existing preference" );
		// invalid
		expectException("User.PreferenceNotFound");
		model.getPreference("invalid");
	}
	
	function testSetPreference(){
		// with default
		model.setPreference("UnitTest", "Hello");
		assertEquals( "Hello", model.getPreference("UnitTest") );
		
	}

}
