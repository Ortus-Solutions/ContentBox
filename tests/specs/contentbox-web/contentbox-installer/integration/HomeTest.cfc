component extends="tests.resources.BaseTest" {

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		// all your suites go here.
		describe( "ContentBox Installer", function(){
			beforeEach( function( currentSpec ){
				setup();
			} );

			it( "Can startup the installer", function(){
				var e = execute( "contentbox-installer:Home.index" );
			} );

			it( "Can finalize the installer", function(){
				var e = execute( "contentbox-installer:Home.finished" );
			} );
		} );
	}

}

