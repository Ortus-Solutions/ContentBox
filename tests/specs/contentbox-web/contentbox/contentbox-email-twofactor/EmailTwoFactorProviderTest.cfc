/**
 * Email Two factor provider Test
 */
component extends="tests.resources.BaseTest" {

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ) {
		// all your suites go here.
		describe(
			"Email Two Factor Provider",
			() => {
				beforeEach(
					( currentSpec ) => {
						mockUser = getInstance( "authorService@contentbox" ).findByUsername( "lmajano" );
						provider = getInstance( "EmailTwoFactorProvider@contentbox-email-twofactor" );
					}
				);

				it(
					"can get names",
					() => {
						expect( provider.getName() ).toBe( "email" );
						expect( provider.getDisplayName() ).toBe( "Email" );
					}
				);

				it(
					"can get trusted devices",
					() => {
						expect( provider.allowTrustedDevice() ).toBeTrue();
					}
				);

				it(
					"can generate validation tokens",
					() => {
						var token = provider.generateValidationToken( mockUser );
						expect( token ).notToBeEmpty();
					}
				);

				it(
					"can send challenges",
					() => {
						var results = provider.sendChallenge( mockUser );
						debug( results );
						expect( results.error ).toBeFalse( results.toString() );
					}
				);
			}
		);
	}

}