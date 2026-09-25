/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ) {
		describe(
			"CB Helper",
			() => {
				beforeEach(
					( currentSpec ) => {
						setup();
						cbHelper = getInstance( "CBHelper@contentbox" );
					}
				);

				it(
					"can be created",
					() => {
						expect( cbHelper ).toBeComponent();
					}
				);

				describe(
					"Site related methods",
					() => {
						it(
							"can build the site root",
							() => {
								expect( cbHelper.siteRoot() ).toInclude( "http://127.0.0.1" );
							}
						);

						it(
							"can build the site base url",
							() => {
								expect( cbHelper.siteBaseUrl() ).toInclude( "http://127.0.0.1" ).notToInclude( "index.cfm" );
							}
						);

						it(
							"can build the site name",
							() => {
								expect( cbHelper.siteName() ).toInclude( "Default Site" );
							}
						);

						it(
							"can build the site tag line",
							() => {
								expect( cbHelper.siteTagLine() ).notToBeEmpty();
							}
						);

						it(
							"can build the site description",
							() => {
								expect( cbHelper.siteDescription() ).notToBeEmpty();
							}
						);

						it(
							"can build the site keywords",
							() => {
								cbHelper.siteKeywords();
							}
						);

						it(
							"can build the site email",
							() => {
								expect( cbHelper.siteEmail() ).notToBeEmpty();
							}
						);

						it(
							"can build the site outgoing email",
							() => {
								expect( cbHelper.siteOutgoingEmail() ).notToBeEmpty();
							}
						);
					}
				);
			}
		);
	}

}