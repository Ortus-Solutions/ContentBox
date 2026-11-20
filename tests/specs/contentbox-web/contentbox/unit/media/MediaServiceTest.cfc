/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	function run( testResults, testBox ) {
		describe(
			"DB Search Adapter",
			() => {
				beforeEach(
					( currentSpec ) => {
						setup();
						service = getInstance( "MediaService@contentbox" ).init( getWireBox() );
					}
				);

				it(
					"can register and get providers",
					() => {
						var provider = service.getProvider( "CFContentMediaProvider" );
						expect( provider ).toBeComponent();
						assertEquals( "CFContentMediaProvider", provider.getName() );
						assertEquals( "CF Content Media Provider", provider.getDisplayName() );
					}
				);

				it(
					"can get the default provider",
					() => {
						assertEquals( "CFContentMediaProvider", service.getDefaultProviderName() );
					}
				);

				it(
					"can unregister a provider",
					() => {
						service.unregisterProvider( "CFContentMediaProvider" );
						expect( service.getRegisteredProviders() ).notToInclude( "CFContentMediaProvider" );
					}
				);

				it(
					"can get the registered providers map",
					() => {
						var map = service.getRegisteredProvidersMap();
						debug( map );
						expect( map ).toBeArray().notToBeEmpty();
					}
				);

				it(
					"can get the path to the core media root",
					() => {
						var path = service.getCoreMediaRoot();
						expect( path ).toInclude( "/contentbox-custom/_content" );
					}
				);

				it(
					"can get the absolute path to the core media root",
					() => {
						var path = service.getCoreMediaRoot( true );
						expect( directoryExists( path ) ).toBeTrue();
					}
				);
			}
		);
	}

}