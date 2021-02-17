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
		describe( "DB Search Adapter", function(){
			beforeEach( function( currentSpec ){
				setup();
				model = getInstance( "DBSearch@cb" );
			} );

			it( "can do search with no results", function(){
				var r = model.search( searchTerm = "bogus pocus" );

				expect( r.getTotal() ).toBe( 0 );
				expect( r.getSearchTerm() ).toBe( "bogus pocus" );
				expect( r.getResults() ).toBeArray();
				expect( r.getError() ).toBeFalse();
			} );

			it( "can do search with results", function(){
				var r = model.search( searchTerm = "welcome" );

				expect( r.getTotal() ).toBeGT( 0 );
				expect( r.getSearchTerm() ).toBe( "welcome" );
				expect( r.getResults() ).toBeArray();
				expect( r.getResults().size() ).toBeGT( 0 );
				expect( r.getError() ).toBeFalse();
			} );

			it( "can render search results", function(){
				// setup
				var r            = model.search( searchTerm = "welcome" );
				var prc          = getRequestContext().getPrivateCollection();
				prc.cbEntryPoint = "/";
				prc.cbSettings   = {};

				var rendering = model.renderSearchWithResults( r );
				// debug( rendering );
				expect( rendering ).toInclude( "welcome" ).toInclude( "searchResults" );
			} );

			it( "can render search with no results", function(){
				// setup
				var r            = model.search( searchTerm = "bogus pocus" );
				var prc          = getRequestContext().getPrivateCollection();
				prc.cbEntryPoint = "/";
				prc.cbSettings   = {};

				var rendering = model.renderSearchWithResults( r );
				// debug( rendering );
				expect( rendering ).toInclude( "searchResults" ).toInclude( "<strong>0</strong>" );
			} );
		} );
	}

}
