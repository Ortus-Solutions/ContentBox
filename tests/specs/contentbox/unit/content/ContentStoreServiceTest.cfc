/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
*/
component extends="tests.resources.BaseTest"{

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
		describe( "Content Store Service", function(){
			beforeEach(function( currentSpec ){
				model = getInstance( "ContentStoreService@cb" );
			});

			it( "can search for content items", function(){
				// test get all
				var r = model.search();
				expect(	r.count ).toBeGT( 0 );
						
				r = model.search( search="Most greatest news" );
				expect(	r.count ).toBeGT( 0 );

				r = model.search( search="sidebar" );
				expect(	r.count ).toBeGT( 0 );
			});
		
		});
	}

}