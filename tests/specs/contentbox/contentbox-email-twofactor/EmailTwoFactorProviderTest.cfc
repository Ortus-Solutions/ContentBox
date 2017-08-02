/**
* Email Two factor provider Test
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
		// all your suites go here.
		describe( "Email Two Factor Provider", function(){
			beforeEach(function( currentSpec ){
				mockUser = getInstance( "authorService@cb" ).findByUsername( "lmajano" );
				provider = getInstance( "EmailTwoFactorProvider@contentbox-email-twofactor" );
			});

			it( "can be created", function(){
				expect(	provider ).toBeComponent();
			});

			it( "can get names", function(){
				expect(	provider.getName() ).toBe( "email" );
				expect(	provider.getDisplayName() ).toBe( "Email" );
			});

			it( "can get trusted devices", function(){
				expect(	provider.allowTrustedDevice() ).toBeTrue();
			});

			it( "can generate validation tokens", function(){
				var token = provider.generateValidationToken( mockUser );
				expect(	token ).notToBeEmpty();
			});

			it( "can send challenges", function(){
				var results = provider.sendChallenge( mockUser );
				debug( results );
				expect(	results.error ).toBeFalse();
			});
		});
	}
	
}