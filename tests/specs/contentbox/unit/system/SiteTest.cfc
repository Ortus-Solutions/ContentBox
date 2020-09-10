/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
*/
component extends="tests.resources.BaseTest"{

/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		describe( "Site", function(){
			beforeEach(function( currentSpec ){
				model = prepareMock( getInstance( "siteService@cb" ).new() );
			});

			it( "can be created", function(){
				expect( model ).toBeComponent();
			});

		});
	}

}