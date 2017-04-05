component extends="coldbox.system.testing.BaseTestCase" appMapping="/"{
	
/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		super.beforeAll();
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
		super.afterAll();
	}

/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		// all your suites go here.
		describe( "ContentBox Installer", function(){

			beforeEach(function( currentSpec ){
				setup();
			});

			it( "Can startup the installer", function(){
				var e = execute("contentbox-installer:Home.index");
			});

			it( "Can finalize the installer", function() {
				var e = execute("contentbox-installer:Home.finished");
			} );

		});
	}
	
}

