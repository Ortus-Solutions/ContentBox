component extends="coldbox.system.testing.BaseTestCase"{

	function setup(){
		super.setup();
		update = getMockBox().prepareMock( getModel("root.workbench.patches.1-5-1.Update") );
		
	}
	
	function testUpdateContentCreators(){
		try{
			transaction action="begin"{
				makePublic( update, "updateCOntentCreators");
				update.updateContentCreators();
				
				// clear it
				ormClearSession();
				transaction action="rollback";
			}
		}
		catch(Any e){
			ormClearSession();
			transaction action="rollback"{};
			fail(e);
		}
	}

	function testpreInstallation(){
		try{
			transaction action="begin"{

				//update.preInstallation();
				
				// clear it
				ormClearSession();
				transaction action="rollback";
			}
		}
		catch(Any e){
			ormClearSession();
			transaction action="rollback"{};
			fail(e);
		}

	}

}