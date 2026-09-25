/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	function run( testResults, testBox ) {
		describe(
			"Security Rule Services",
			() => {
				beforeEach(
					( currentSpec ) => {
						model = new contentbox.models.security.SecurityRule();
					}
				);

				it(
					"be created",
					() => {
						expect( model ).toBeComponent();
					}
				);
			}
		);
	}

}