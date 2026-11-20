/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component extends="tests.resources.BaseTest" {

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ) {
		describe(
			"Author Suite",
			() => {
				beforeEach(
					( currentSpec ) => {
						model = entityNew( "cbAuthor" );
					}
				);

				it(
					"can load properly",
					() => {
						var testUser = entityLoad( "cbAuthor" )[ 1 ];
						expect( testUser.isLoaded() ).toBeTrue();
					}
				);

				it(
					"can display created dates",
					() => {
						var d = model.getDisplayCreatedDate( timeFormat = "hh:mm tt" );
						expect( dateDiff(
								"d",
								now(),
								d
							) ).toBe( 0 );
					}
				);

				it(
					"can display last login timestamps",
					() => {
						var d = model.getDisplayLastLogin();
						expect( d ).toBe( "Never Logged In" );

						var testUser = entityLoad( "cbAuthor" )[ 1 ];
						var d = testUser.getDisplayLastLogin( timeFormat = "hh:mm tt" );
						expect( d ).toBeDate();
					}
				);

				it(
					"can get/set all preferences",
					() => {
						expect( model.getAllPreferences() ).toBeStruct();
						var pref = { editor: "textarea", test: "nada" };
						model.setPreferences( pref );

						expect( model.getPreferences() ).toBeJSON();
						expect( model.getAllPreferences() ).toBe( pref );
					}
				);

				it(
					"can get and set preferences with marshalling",
					() => {
						// with default
						var v = model.getPreference( "invalid", "test" );
						expect( v ).toBe( "test" );

						// existent
						var pref = { editor: "textarea", test: "nada" };
						model.setPreferences( pref );
						expect( model.getPreference( "editor" ) ).toBe( "textarea" );

						// invalid
						expect(
							() => {
								model.getPreference( "invalid" );
							}
						).toThrow();

						// with default
						model.setPreference( "UnitTest", "Hello" );
						expect( model.getPreference( "UnitTest" ) ).toBe( "Hello" );
					}
				);

				it(
					"can check permissions even without a role",
					() => {
						expect( model.hasPermission( "test" ) ).toBeFalse();
					}
				);
			}
		);
	}

}