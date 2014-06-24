/**
* The base model test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="coldbox.system.testing.BaseModelTest" model="contentbox.model.ui.editors.EditorService"{

	function setup(){
		super.setup();
		
		mockWireBox.$("getInstance", new MockEditor() );
		
		// init the model object
		model.init( mockWireBox );
	}
	
	function teardown(){
		
	}
	
	function testGetRegisteredEditors(){
		model.getEditors()["test"] = this;
		model.getEditors()["Awesome"] = this;
		a = model.getRegisteredEditors();
		//debug(a);
		assertEquals( "Awesome", a[1] );
		assertEquals( "mock-editor", a[2] );
		assertEquals( "test", a[3] );
	}
	
	
	function testregisterEditor(){
		editor = getMockBox().prepareMock( new MockEditor() );
		model.registerEditor( editor );
		assertEquals( editor, model.getEditor("mock-editor") );
	}
	
	function testUnregisterEditor(){
		editor = getMockBox().prepareMock( new MockEditor() );
		model.registerEditor( editor ).unRegisterEditor( "mock-editor" );
		assertFalse( structKeyExists( model.getEditors(), "mock-editor") );
	}
	
	function testGetRegisteredEditorsMap(){
		model.getEditors()["test"] = getMockBox().createStub(implements="contentbox.model.ui.editors.IEditor");
		model.getEditors()["Awesome"] = getMockBox().createStub(implements="contentbox.model.ui.editors.IEditor");
		a = model.getRegisteredEditorsMap();
		debug(a);
		assertEquals( "Awesome", a[1].name );
		assertEquals( "mock-editor", a[2].name );
		assertEquals( "test", a[3].name );
	}

}
