/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		describe( "CB Helper", function(){
			beforeEach( function( currentSpec ){
				setup();
				cbHelper = getInstance( "CBHelper@contentbox" );
			} );

			it( "can be created", function(){
				expect(	cbHelper ).toBeComponent();
			} );

			describe( "Site related methods", function(){
				it( "can build the site root", function(){
					expect( cbHelper.siteRoot() ).toInclude( "http://127.0.0.1" );
				});

				it( "can build the site base url", function(){
					expect( cbHelper.siteBaseUrl() )
						.toInclude( "http://127.0.0.1" )
						.notToInclude( "index.cfm" );
				});

				it( "can build the site name", function(){
					expect( cbHelper.siteName() ).toInclude( "Default Site" );
				});

				it( "can build the site tag line", function(){
					expect( cbHelper.siteTagLine() ).notToBeEmpty();
				});

				it( "can build the site description", function(){
					expect( cbHelper.siteDescription() ).notToBeEmpty();
				});

				it( "can build the site keywords", function(){
					cbHelper.siteKeywords();
				});

				it( "can build the site email", function(){
					expect( cbHelper.siteEmail() ).notToBeEmpty();
				});

				it( "can build the site outgoing email", function(){
					expect( cbHelper.siteOutgoingEmail() ).notToBeEmpty();
				});
			});

		} );
	}

}
