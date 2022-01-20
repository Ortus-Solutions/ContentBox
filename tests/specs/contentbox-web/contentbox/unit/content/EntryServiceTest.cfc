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
		describe( "Entry Services", function(){
			beforeEach( function( currentSpec ){
				model = getInstance( "EntryService@contentbox" );
			} );

			it( "can get archives report", function(){
				var r = model.getArchiveReport();
				expect( arrayLen( r ) ).toBeGT( 0 );
			} );

			it( "can get IDs by slug", function(){
				var r = model.getIDBySlug( "bogus" );
				expect( r ).toBe( "" );

				var r = model.getIDBySlug( "this-is-just-awesome" );
				debug( r );
			} );

			it( "can search for entries", function(){
				var r = model.search();
				expect( r.count ).toBeGT( 0 );

				var r = model.search( isPublished = false );
				expect( r.count ).toBe( 2 );

				var r = model.search( isPublished = true );
				expect( r.count ).toBeGT( 0 );

				var entries  = entityLoad( "cbEntry" );
				var authorID = entries[ 1 ].getAuthor().getAuthorID();
				var r        = model.search( author = authorID );
				expect( r.count ).toBeGT( 0 );

				// search
				var r = model.search( search = "everybody" );
				expect( r.count ).toBeGT( 0 );

				// no categories
				var r = model.search( category = "none" );
				expect( r.count ).toBeGT( 0 );

				// no categories
				var r = model.search( category = "786a98cc-a444-11eb-ab6f-0290cc502ae3" );
				expect( r.count ).toBe( 0 );
			} );

			it( "can find published entries by published dates", function(){
				var entry = entityLoad( "cbEntry" )[ 1 ];

				// nothing
				var r = model.findPublishedEntriesByDate( year = 2000 );
				expect( arrayLen( r.entries ) ).toBeFalse( "Year 2000" );

				// year
				var r = model.findPublishedEntriesByDate( year = dateFormat( entry.getPublishedDate(), "yyyy" ) );
				expect( arrayLen( r.entries ) ).toBeGTE( 1, "Using entry publish year" );

				// year + Month
				var r = model.findPublishedEntriesByDate(
					year  = dateFormat( entry.getPublishedDate(), "yyyy" ),
					month = dateFormat( entry.getPublishedDate(), "mm" )
				);
				expect( arrayLen( r.entries ) ).toBeGTE( 1, "Using entry publish year and month" );

				// year + Month + day
				var r = model.findPublishedEntriesByDate(
					year  = dateFormat( entry.getPublishedDate(), "yyyy" ),
					month = dateFormat( entry.getPublishedDate(), "mm" ),
					day   = dateFormat( entry.getPublishedDate(), "dd" )
				);
				expect( arrayLen( r.entries ) ).toBeGTE( 1, "Using entry publish year, month, and day" );
			} );

			it( "can find published entries by criteria", function(){
				var r = model.findPublishedContent();
				expect( r.count ).toBeGT( 0 );

				// categories
				var r = model.findPublishedContent( category = "software" );
				expect( r.count ).toBe( 0 );
				var r = model.findPublishedContent( category = "ColdFusion" );
				expect( r.count ).toBeGTE( 1 );

				// search
				var r = model.findPublishedContent( search = "first" );
				expect( r.count ).toBeGT( 0 );
			} );
		} );
	}

}
