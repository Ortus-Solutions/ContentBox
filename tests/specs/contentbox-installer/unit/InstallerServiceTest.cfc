component extends="tests.resources.BaseTest"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		super.beforeAll();
		super.setup();
		installer 		= getInstance( "InstallerService@cbi" );
		resourcesPath 	= expandPath( "/tests/resources" ) & "/";
	}


/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		// all your suites go here.
		describe( "Installer Service", function(){

			it( "can process ColdBox Reinit passwords", function(){
				var setup 		= getInstance( "Setup@cbi" );
				var original 	= fileRead( resourcesPath & "config/Coldbox.cfc" );

				try{
					installer.setAppPath( resourcesPath );
					installer.processColdBoxPasswords( setup );
					var updated = fileRead( resourcesPath & "config/Coldbox.cfc" );
					expect(	updated ).notToInclude( "@fwPassword@" );
				}
				catch(any e){}
				finally{
					fileWrite( resourcesPath & "config/Coldbox.cfc", original );
				}
			});

		});
	}

}