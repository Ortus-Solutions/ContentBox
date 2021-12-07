/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	function run( testResults, testBox ){
		describe( "Search Results", function(){
			beforeEach( function( currentSpec ){
				setup();
				model = getInstance( "SearchResults@contentbox" );
			} );


			it( "can get the memento", function(){
				var results = model.getMemento();
				expect( results ).toBeStruct();
			} );

			it( "can populate", function(){
				var r = {
					results       : [],
					searchTime    : getTickCount(),
					total         : 0,
					metadata      : { name : "luis", value : "awesome" },
					error         : false,
					errorMessages : [],
					searchTerm    : "luis"
				};

				model.populate( r );
				var m = model.getMemento();
				assertEquals( r, m );
			} );
		} );
	}

}
