/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll() {
		super.beforeAll();
		provider = getInstance( "BaseTwoFactorProvider@contentbox" );
	}

	// executes after all suites+specs in the run() method
	function afterAll() {
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ) {
		describe(
			"Base Two Factor Provider",
			() => {
				it(
					"can get all settings",
					() => {
						expect( provider.getAllSettings() ).toBeStruct();
					}
				);
			}
		);
	}

}