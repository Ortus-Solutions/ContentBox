component extends="coldbox.system.testing.BaseTestCase" appMapping='/contentbox-shell'{

	function setup(){
		super.setup();
		installer = getModel("InstallerService@cbi");
		resourcesPath = expandPath("/contentbox-test/resources") & "/";
	}
	
	function testprocessColdBoxPasswords(){
		setup = getModel("SetupBean@cbi");
		var original = fileRead(resourcesPath & "config/Coldbox.cfc");
		
		try{
			installer.setAppPath( resourcesPath );
			installer.processColdBoxPasswords( setup );
			var updated = fileRead(resourcesPath & "config/Coldbox.cfc");
			assertFalse( findnocase(updated,"@fwPassword@") );
		}
		catch(any e){}
		finally{
			fileWrite(resourcesPath & "config/Coldbox.cfc", original);
		}
	}
	
} 