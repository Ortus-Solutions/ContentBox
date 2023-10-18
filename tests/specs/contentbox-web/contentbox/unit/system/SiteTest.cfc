/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		describe( "Site", function(){
			beforeEach( function( currentSpec ){
				model = prepareMock( getInstance( "siteService@contentbox" ).new() );
			} );

			it( "can be created", function(){
				expect( model ).toBeComponent();
			} );

			it( "can have an empty domain aliases by default", function(){
				expect( model.getDomainAliases() ).toBeArray().toBeEmpty();
			} );

			it( "can store domain aliases as a json string", function(){
				model.setDomainAliases( [ "www\.foo\.com", "bar\.com" ] );
				expect( model.getDomainAliases() ).toBeArray().toHaveLength( 2 );
			} );
		} );
	}

}
