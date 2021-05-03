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
		describe( "Page Services", function(){
			beforeEach( function( currentSpec ){
				model = getInstance( "PageService@cb" );
			} );

			it( "can search for entries", function(){
				var r = model.search();
				expect( r.count ).toBeGT( 0 );

				var r = model.search( isPublished = false );
				expect( r.count ).toBeGT( 1 );
				var r = model.search( isPublished = true );
				expect( r.count ).toBeGT( 0 );

				var pages    = entityLoad( "cbPage" );
				var authorID = pages[ 1 ].getAuthor().getAuthorID();
				var r        = model.search( author = authorID );
				expect( r.count ).toBeGT( 0 );

				// search
				var r = model.search( search = "products" );
				expect( r.count ).toBeGT( 0 );

				// parent
				var r = model.search( parent = "" );
				expect( r.count ).toBeGT( 0 );
				var r = model.search( parent = "1" );
				expect( r.count ).toBe( 0 );
			} );

			it( "cand find published pages", function(){
				var r = model.findPublishedContent();
				expect( r.count ).toBeGT( 0 );

				// search
				var r = model.findPublishedContent( searchTerm = "products" );
				expect( r.count ).toBeGT( 0 );

				// parent
				var r = model.findPublishedContent( parent = "" );
				expect( r.count ).toBeGT( 0 );
				var r = model.findPublishedContent( parent = "1" );
				expect( r.count ).toBe( 0 );

				// search
				var r = model.findPublishedContent( showInMenu = true );
				expect( r.count ).toBeGT( 0 );
			} );
		} );
	}

}
