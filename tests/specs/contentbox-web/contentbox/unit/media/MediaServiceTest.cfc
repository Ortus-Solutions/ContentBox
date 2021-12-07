/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	function run( testResults, testBox ){
		describe( "DB Search Adapter", function(){
			beforeEach( function( currentSpec ){
				setup();
				model = getInstance( "MediaService@contentbox" );
			} );

			it( "can get a provider", function(){
				var provider = model.getProvider( "CFContentMediaProvider" );
				expect( provider ).toBeComponent();
				assertEquals( "CFContentMediaProvider", provider.getName() );
				assertEquals( "CF Content Media Provider", provider.getDisplayName() );
			} );


			it( "can get the default provider", function(){
				assertEquals( "CFContentMediaProvider", model.getDefaultProviderName() );
			} );
		} );
	}

}
