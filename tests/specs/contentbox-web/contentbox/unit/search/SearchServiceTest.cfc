/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	function run( testResults, testBox ) {
		describe(
			"Search Service",
			() => {
				beforeEach(
					( currentSpec ) => {
						setup();
						searchService = getInstance( "SearchService@contentbox" );
					}
				);

				it(
					"can get the search adapter",
					() => {
						var adapter = searchService.getSearchAdapter();
						expect( adapter ).toBeComponent();
					}
				);
			}
		);
	}

}