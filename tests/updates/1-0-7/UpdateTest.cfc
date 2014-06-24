component extends="coldbox.system.testing.BaseTestCase"{

	function setup(){
		super.setup();
		update = getMockBox().prepareMock( getModel("root.workbench.patches.1-0-7.Update") );
		
	}

	function testpreInstallation(){
		try{
			transaction action="begin"{

				update.preInstallation();
				
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