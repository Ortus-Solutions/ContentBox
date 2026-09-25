/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll() {
		super.beforeAll();
	}

	// executes after all suites+specs in the run() method
	function afterAll() {
		super.afterAll();
		structDelete( cookie, "CONTENTBOX_2FACTOR_DEVICE" );
	}

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ) {
		describe(
			"Two Factor Services",
			() => {
				beforeEach(
					( currentSpec ) => {
						model = prepareMock( getInstance( "TwoFactorService@contentbox" ) );
						mockProvider = createStub(
							implements = "contentbox.models.security.twofactor.ITwoFactorProvider"
						)
							.$( "getName", "email" )
							.$( "getDisplayName", "email" )
							.$( "allowTrustedDevice", true );
						// Register a mock provider for testing usages
						model.registerProvider( mockProvider );
					}
				);

				it(
					"can validate global force authentication",
					() => {
						expect( model.isForceTwoFactorAuth() ).toBeBoolean();
					}
				);

				it(
					"can initialize and register the default provider",
					() => {
						expect( model.getProviders() ).notToBeEmpty();
					}
				);

				it(
					"can get the default provider name",
					() => {
						expect( model.getDefaultProvider() ).toBe( "Email" );
					}
				);

				it(
					"can get registered providers",
					() => {
						var a = model.getRegisteredProviders();
						expect( a ).toInclude( "Email" );
					}
				);

				it(
					"can get the registered providers display map",
					() => {
						var map = model.getRegisteredProvidersMap();
						expect( map[ 1 ].displayName ).toBe( "Email" );
					}
				);

				it(
					"can get a provider instance",
					() => {
						var provider = model.getProvider( "email" );
						expect( isObject( provider ) ).toBeTrue();
					}
				);

				it(
					"can verify providers",
					() => {
						expect( model.hasProvider( "email" ) ).toBeTrue();
					}
				);

				it(
					"can unregister providers",
					() => {
						var provider = createStub(
							implements = "contentbox.models.security.twofactor.ITwoFactorProvider"
						).$( "getName", "mock" ).$( "getDisplayName", "mock" );

						model.registerProvider( provider );
						model.unRegisterProvider( "mock" );
						expect( model.hasProvider( "mock" ) ).toBeFalse();
					}
				);

				xit(
					"can set trusted devices",
					() => {
						model.setTrustedDevice( "luis" );
						expect( cookie[ "CONTENTBOX_2FACTOR_DEVICE" ] ).notToBeEmpty();
					}
				);

				it(
					"can validate trusted devices",
					() => {
						model.setTrustedDevice( "luis" );
						expect( model.isTrustedDevice( "luis" ) ).toBeTrue();

						expect( model.isTrustedDevice( "mockTesting" ) ).toBeFalse();
					}
				);

				it(
					"can send provider challenges",
					() => {
						var thisUser = getInstance( "AuthorService@contentbox" ).findByUsername( "lmajano" );
						var results = { error: false, messages: "message sent" };
						mockProvider.$( "sendChallenge", results );
						expect( model.sendChallenge( thisUser ) ).toBe( results );
					}
				);

				story(
					"I can challenge for two factor authentication with trusted device features",
					() => {
						beforeEach(
							() => {
								thisUser = getInstance( "AuthorService@contentbox" ).findByUsername( "lmajano" );
								model.registerProvider( mockProvider );
							}
						);
						given(
							"A global force and no trusted device",
							() => {
								then(
									"I should challenge",
									() => {
										model.$( "isForceTwoFactorAuth", true ).$( "isTrustedDevice", false );
										expect( model.canChallenge( thisUser ) ).toBeTrue();
									}
								);
							}
						);
						given(
							"A global force and a trusted device",
							() => {
								then(
									"I should NOT challenge",
									() => {
										model.$( "isForceTwoFactorAuth", true ).$( "isTrustedDevice", true );
										expect( model.canChallenge( thisUser ) ).toBeFalse();
									}
								);
							}
						);
						given(
							"No global force but user set authentication and no trusted device",
							() => {
								then(
									"I should challenge",
									() => {
										thisUser.setIs2FactorAuth( true );
										model.$( "isForceTwoFactorAuth", false ).$( "isTrustedDevice", false );
										expect( model.canChallenge( thisUser ) ).toBeTrue();
									}
								);
							}
						);
						given(
							"No global force but user set authentication and a trusted device",
							() => {
								then(
									"I should NOT challenge",
									() => {
										thisUser.setIs2FactorAuth( true );
										model.$( "isForceTwoFactorAuth", false ).$( "isTrustedDevice", true );
										expect( model.canChallenge( thisUser ) ).toBeFalse();
									}
								);
							}
						);
					}
				);
			}
		);
	}

}