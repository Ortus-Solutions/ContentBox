component extends="coldbox.system.testing.BaseTestCase"{

	function setup(){
		super.setup();
		update = getMockBox().prepareMock( getInstance("root.workbench.patches.1-5-6.Update") );

	}

	function testCreation(){

	}

}