component extends="tests.resources.BaseTest" {

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ) {
		// all your suites go here.
		describe(
			"ContentBox Installer",
			() => {
				beforeEach( ( currentSpec ) => {
						setup();
					} );

				it(
					"Can startup the installer",
					() => {
						var e = execute( "contentbox-installer:Home.index" );
					}
				);

				it(
					"Can finalize the installer",
					() => {
						var e = execute( "contentbox-installer:Home.finished" );
					}
				);
			}
		);
	}

}