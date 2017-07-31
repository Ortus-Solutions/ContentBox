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
		describe( "Two Factor Services", function(){
			beforeEach(function( currentSpec ){
				model = getInstance( "TwoFactorService@cb" );
				var mockProvider = createStub( implements="contentbox.models.security.twofactor.ITwoFactorProvider" )
					.$( "getName", "email" )
					.$( "getDisplayName", "email" );
				// Register a mock provider for testing usages
				model.registerProvider( mockProvider );
			});

			it( "can initialize and register the default provider", function(){
				expect(	model.getProviders() ).notToBeEmpty();
			});

			it( "can get the default provider name", function(){
				expect(	model.getDefaultProvider() ).toBe( "Email" );
			});

			it( "can get registered providers", function(){
				var a = model.getRegisteredProviders();
				expect(	a ).toInclude( "Email" );
			});

			it( "can get the registered providers display map", function(){
				var map = model.getRegisteredProvidersMap();
				expect(	map[ 1 ].displayName ).toBe( "Email" );
			});

			it( "can get a provider instance", function(){
				var provider = model.getProvider( "email" );
				expect(	provider ).toBeComponent();
			});

			it( "can verify providers", function(){
				expect(	model.hasProvider( "email" ) ).toBeTrue();
			});

			it( "can unregister providers", function(){
				var provider = createStub( implements="contentbox.models.security.twofactor.ITwoFactorProvider" )
					.$( "getName", "mock" )
					.$( "getDisplayName", "mock" );

				model.registerProvider( provider );
				model.unRegisterProvider( "mock" );
				expect(	model.hasProvider( "mock" ) ).toBeFalse();
				
			});

		});

	}

}