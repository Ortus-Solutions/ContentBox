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
		describe( "DB Search Adapter", function(){
			beforeEach(function( currentSpec ){
				model = entityNew( "cbAuthor" );
			});

			it( "can generate an API Token", function(){
				var APIToken = model.getAPIToken();
				expect(	APIToken ).notToBeEmpty();
				var newToken = model.generateAPIToken().getAPIToken();
				expect(	newToken ).notToBe( APIToken );
			});

			it( "can load properly", function(){
				var testUser = entityLoad( "cbAuthor" )[ 1 ];
				expect(	testUser.isLoaded() ).toBeTrue();
			});

			it( "can display created dates", function(){
				var d = model.getDisplayCreatedDate();
				assertEquals( "", d );
				expect(	d ).toBeEmpty();

				var testUser = entityLoad( "cbAuthor" )[ 1 ];
				var d = testUser.getDisplayCreatedDate();
				expect(	d.len() ).toBeGT( 0 );
			});

			it( "can display last login timestamps", function(){
				var d = model.getDisplayLastLogin();
				expect(	d ).toBe( "Never Logged In" );
				
				var testUser = entityLoad( "cbAuthor" )[ 1 ];
				var d = testUser.getDisplayLastLogin();
				expect(	d ).toBeDate();
			});

			it( "can get/set all preferences", function(){
				expect(	model.getAllPreferences() ).toBeStruct();
				var pref = {
					editor = "textarea", test = "nada"
				};
				model.setPreferences( pref );

				expect(	model.getPreferences() ).toBeJSON();
				expect(	model.getAllPreferences() ).toBe( pref );
			});

			it( "can get and set preferences with marshalling", function(){
				// with default
				var v = model.getPreference( "invalid", "test" );
				expect( v ).toBe( "test" );
				
				// existent
				var pref = {
					editor = "textarea", test = "nada"
				};
				model.setPreferences( pref );
				expect(	model.getPreference( "editor" ) ).toBe( "textarea" );

				// invalid
				expect(	function(){
					model.getPreference( "invalid" );	
				} ).toThrow();

				// with default
				model.setPreference( "UnitTest", "Hello" );
				expect( model.getPreference( "UnitTest" ) ).toBe( "Hello" );
			});

		});

	}

}