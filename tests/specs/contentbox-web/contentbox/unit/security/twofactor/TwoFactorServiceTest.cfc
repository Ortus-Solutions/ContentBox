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
		structDelete( cookie, "CONTENTBOX_2FACTOR_DEVICE" );
	}

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		describe( "Two Factor Services", function(){
			beforeEach( function( currentSpec ){
				model        = prepareMock( getInstance( "TwoFactorService@cb" ) );
				mockProvider = createStub(
					implements = "contentbox.models.security.twofactor.ITwoFactorProvider"
				).$( "getName", "email" )
					.$( "getDisplayName", "email" )
					.$( "allowTrustedDevice", true );
				// Register a mock provider for testing usages
				model.registerProvider( mockProvider );
			} );

			it( "can validate global force authentication", function(){
				expect( model.isForceTwoFactorAuth() ).toBeBoolean();
			} );

			it( "can initialize and register the default provider", function(){
				expect( model.getProviders() ).notToBeEmpty();
			} );

			it( "can get the default provider name", function(){
				expect( model.getDefaultProvider() ).toBe( "Email" );
			} );

			it( "can get registered providers", function(){
				var a = model.getRegisteredProviders();
				expect( a ).toInclude( "Email" );
			} );

			it( "can get the registered providers display map", function(){
				var map = model.getRegisteredProvidersMap();
				expect( map[ 1 ].displayName ).toBe( "Email" );
			} );

			it( "can get a provider instance", function(){
				var provider = model.getProvider( "email" );
				expect( isObject( provider ) ).toBeTrue();
			} );

			it( "can verify providers", function(){
				expect( model.hasProvider( "email" ) ).toBeTrue();
			} );

			it( "can unregister providers", function(){
				var provider = createStub(
					implements = "contentbox.models.security.twofactor.ITwoFactorProvider"
				).$( "getName", "mock" ).$( "getDisplayName", "mock" );

				model.registerProvider( provider );
				model.unRegisterProvider( "mock" );
				expect( model.hasProvider( "mock" ) ).toBeFalse();
			} );

			xit( "can set trusted devices", function(){
				model.setTrustedDevice( "luis" );
				expect( cookie[ "CONTENTBOX_2FACTOR_DEVICE" ] ).notToBeEmpty();
			} );

			it( "can validate trusted devices", function(){
				model.setTrustedDevice( "luis" );
				expect( model.isTrustedDevice( "luis" ) ).toBeTrue();

				expect( model.isTrustedDevice( "mockTesting" ) ).toBeFalse();
			} );

			it( "can send provider challenges", function(){
				var thisUser = getInstance( "AuthorService@cb" ).findByUsername( "lmajano" );
				var results  = { error : false, messages : "message sent" };
				mockProvider.$( "sendChallenge", results );
				expect( model.sendChallenge( thisUser ) ).toBe( results );
			} );

			story( "I can challenge for two factor authentication with trusted device features", function(){
				beforeEach( function(){
					thisUser = getInstance( "AuthorService@cb" ).findByUsername( "lmajano" );
					model.registerProvider( mockProvider );
				} );
				given( "A global force and no trusted device", function(){
					then( "I should challenge", function(){
						model.$( "isForceTwoFactorAuth", true ).$( "isTrustedDevice", false );
						expect( model.canChallenge( thisUser ) ).toBeTrue();
					} );
				} );
				given( "A global force and a trusted device", function(){
					then( "I should NOT challenge", function(){
						model.$( "isForceTwoFactorAuth", true ).$( "isTrustedDevice", true );
						expect( model.canChallenge( thisUser ) ).toBeFalse();
					} );
				} );
				given( "No global force but user set authentication and no trusted device", function(){
					then( "I should challenge", function(){
						thisUser.setIs2FactorAuth( true );
						model.$( "isForceTwoFactorAuth", false ).$( "isTrustedDevice", false );
						expect( model.canChallenge( thisUser ) ).toBeTrue();
					} );
				} );
				given( "No global force but user set authentication and a trusted device", function(){
					then( "I should NOT challenge", function(){
						thisUser.setIs2FactorAuth( true );
						model.$( "isForceTwoFactorAuth", false ).$( "isTrustedDevice", true );
						expect( model.canChallenge( thisUser ) ).toBeFalse();
					} );
				} );
			} );
		} );
	}

}
