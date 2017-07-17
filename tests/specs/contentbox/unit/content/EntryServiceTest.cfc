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
		describe( "Entry Services", function(){
			beforeEach(function( currentSpec ){
				model = getInstance( "EntryService@cb" );
			});

			it( "can get archives report", function(){
				var r = model.getArchiveReport();
				expect(	arrayLen( r ) ).toBeGT( 0 );
			});

			it( "can get IDs by slug", function(){
				var r = model.getIDBySlug( 'bogus' );
				expect(	r ).toBe( '' );
				
				var r = model.getIDBySlug( 'this-is-just-awesome' );
				debug( r );
			});

			it( "can search for entries", function(){
				var r = model.search();
				expect(	r.count ).toBeGT( 0 );
				
				var r = model.search( isPublished=false );
				expect(	r.count ).toBe( 2 );
				
				var r = model.search(isPublished=true);
				expect(	r.count ).toBeGT( 0 );
				
				var entries = entityLoad( "cbEntry" );
				var authorID = entries[ 1 ].getAuthor().getAuthorID();
				var r = model.search(author=authorID);
				expect(	r.count ).toBeGT( 0 );
				
				// search
				var r = model.search(search="everybody" );
				expect(	r.count ).toBeGT( 0 );
				
				// no categories
				var r = model.search(category="none" );
				expect(	r.count ).toBeGT( 0 );
				
				// no categories
				var r = model.search(category="1" );
				expect(	r.count ).toBe( 0 );
			});

			it( "can find published entries by published dates", function(){
				var entry = entityLoad( "cbEntry" )[ 1 ];
		
				// nothing
				var r = model.findPublishedEntriesByDate( year=2000 );
				expect(	arrayLen( r.entries ) ).toBeFalse();
				
				// year
				var r = model.findPublishedEntriesByDate( year = dateformat( entry.getPublishedDate(), "yyyy" ) );
				expect(	arrayLen( r.entries ) ).toBeGT( 1 );
				
				// year + Month
				var r = model.findPublishedEntriesByDate(
					year 	= dateformat( entry.getPublishedDate(), "yyyy" ), 
					month 	= dateFormat( entry.getPublishedDate(), "mm" ) 
				);
				expect(	arrayLen( r.entries ) ).toBeGTE( 1 );
				
				// year + Month + day
				var r = model.findPublishedEntriesByDate(
					year	= dateformat( entry.getPublishedDate(), "yyyy" ),
					month	= dateFormat( entry.getPublishedDate(), "mm" ),
					day 	= dateFormat( entry.getPublishedDate(), "dd" )
				);
				expect(	arrayLen( r.entries ) ).toBeGT( 1 );
			});

			it( "can find published entries by criteria", function(){
				var r = model.findPublishedEntries();
				expect(	r.count ).toBeGT( 0 );
				
				// categories
				var r = model.findPublishedEntries( category="software" );
				expect(	r.count ).toBe( 0 );
				var r = model.findPublishedEntries( category="ColdFusion" );
				expect(	r.count ).toBeGTE( 1 );
				
				// search
				var r = model.findPublishedEntries(search="first" );
				expect(	r.count ).toBeGT( 0 );
			});

		});
	}

}
