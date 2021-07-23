/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

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
		describe( "Content Version Service", function(){
			beforeEach( function( currentSpec ){
				model = getInstance( "ContentVersionService@contentbox" );
			} );

			it( "can find related versions", function(){
				var r = model.findRelatedVersions(
					contentID = "779cd234-a444-11eb-ab6f-0290cc502ae3"
				);
				expect( r.count ).toBeGT( 0 );
			} );
		} );
	}

}
