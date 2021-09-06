component extends="tests.resources.BaseApiTest" {

	/*********************************** LIFE CYCLE Methods ***********************************/
	function beforeAll(){
		super.beforeAll();
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/
	function run(){
		describe( "Authentication Specs", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
				// Make sure nothing is logged in to start our calls
				securityService.logout();
				jwt.getTokenStorage().clearAll();
			} );

			story( "I want to authenticate a user via username/password and receive a JWT token", function(){
				given( "a valid username and password", function(){
					then( "I will be authenticated and will receive the JWT token", function(){
						// Use a user in the seeded db
						var event = this.post(
							"/cbapi/v1/login",
							{
								username : variables.testAdminUsername,
								password : variables.testAdminPassword
							}
						);
						var response = event.getPrivateValue( "Response" );
						expect( response.getError() ).toBeFalse( response.getMessagesString() );
						expect( response.getData() ).toHaveKey( "tokens,author" );
						// debug( response.getData() );
						var decoded = jwt.decode( response.getData().tokens.access_token );
						expect( decoded.sub ).toBe( response.getData().author.authorID );
						expect( decoded.exp ).toBeGTE( dateAdd( "h", 1, decoded.iat ) );
						var decoded = jwt.decode( response.getData().tokens.refresh_token );
						expect( decoded.sub ).toBe( response.getData().author.authorID );
						expect( response.getData().author.email ).toBe( variables.testAdminEmail );
					} );
				} );
				given( "invalid username and password", function(){
					then( "I will receive a 401 invalid credentials exception ", function(){
						var event = this.post(
							"/cbapi/v1/login",
							{ username : "invalid", password : "invalid" }
						);
						var response = event.getPrivateValue( "Response" );
						expect( response.getError() ).toBeTrue();
						expect( response.getStatusCode() ).toBe( 401 );
					} );
				} );
			} );

			story( "I want to be able to logout from the system using my JWT token", function(){
				given( "a valid incoming jwt token and I issue a logout", function(){
					then( "my token should become invalidated and I will be logged out", function(){
						// Log in
						var token = jwt.attempt(
							variables.testAdminUsername,
							variables.testAdminPassword
						);
						var payload = jwt.decode( token.access_token );

						// Now Logout
						var event = post(
							"/cbapi/v1/logout",
							{ "x-auth-token" : token.access_token }
						);
						var response = event.getPrivateValue( "Response" );
						expect( response.getError() ).toBeFalse( response.getMessagesString() );
						expect( response.getStatusCode() ).toBe( 200 );
						expect( securityService.isLoggedIn() ).toBeFalse();
					} );
				} );
				given( "an invalid incoming jwt token and I issue a logout", function(){
					then( "I should see an error message", function(){
						// Now Logout
						var event    = post( "/cbapi/v1/logout", { "x-auth-token" : "123" } );
						var response = event.getPrivateValue( "Response" );
						expect( response.getError() ).toBeTrue( response.getMessagesString() );
						expect( response.getStatusCode() ).toBe( 401 );
					} );
				} );
			} );

			story( "I want to be able to know who I am by passing my token", function(){
				given( "an valid token", function(){
					then( "I should get my information", function(){
						// Log in
						var tokens = jwt.attempt(
							variables.testAdminUsername,
							variables.testAdminPassword
						);
						var payload = jwt.decode( tokens.access_token );
						// Now Logout
						var event   = GET(
							"/cbapi/v1/whoami",
							{ "x-auth-token" : tokens.access_token }
						);
						expect( event.getResponse() ).toHaveStatus( 200 );
						expect( event.getResponse().getData().authorID ).toBe( payload.sub );
					} );
				} );
				given( "an invalid token", function(){
					then( "I should get an error", function(){
						// Now Logout
						var event = GET( "/cbapi/v1/whoami", { "x-auth-token" : "123" } );
						expect( event.getResponse() ).toHaveStatus( 401 );
					} );
				} );
			} );

			xstory( "I want to send a password reset reminder when I forget my password", function(){
				given( "an valid email", function(){
					then( "I should get a reminder sent", function(){
						// Now Logout
						var event = POST(
							"/cbapi/v1/forgotPassword",
							{ "email" : variables.testAdminUsername }
						);
						expect( event.getResponse() ).toHaveStatus( 200 );
					} );
				} );
				given( "an invalid email", function(){
					then( "I should get an error", function(){
						// Now Logout
						var event = POST(
							"/cbapi/v1/forgotPassword",
							{ "email" : "bogus@bogus.com" }
						);
						expect( event.getResponse() ).toHaveStatus( 404 );
					} );
				} );
			} );

			xstory( "I want to verify password reset tokens", function(){
				given( "a valid reset token", function(){
					then( "I should get a true validation", function(){
						var testUser = getInstance( "UserService" ).retrieveUserByUsername(
							variables.testAdminUsername
						);
						var token = securityService.generatePasswordResetToken( testUser );
						// Now Logout
						var event = POST( "/cbapi/v1/verifyPasswordReset", { "token" : token } );
						expect( event.getResponse() ).toHaveStatus( 200 );
						expect( event.getResponse().getData() ).toBeTrue();
					} );
				} );
				given( "an invalid token", function(){
					then( "I should get an error", function(){
						// Now Logout
						var event = POST(
							"/cbapi/v1/verifyPasswordReset",
							{ "token" : "12312312sadfasd4" }
						);
						expect( event.getResponse() ).toHaveStatus( 406 );
						expect( event.getResponse().getData() ).toBeFalse();
					} );
				} );
			} );

			xstory( "I want to reset a user password", function(){
				beforeEach( function( currentSpec ){
					testResetUser = getInstance( "UserService" ).retrieveUserByUsername(
						variables.testContractorEmail
					);
					testResetToken = securityService.generatePasswordResetToken( testResetUser );
				} );

				given( "a valid reset token and not the previous password", function(){
					then( "I should reset the password", function(){
						// Now Logout
						var event = POST(
							"/cbapi/v1/resetPassword",
							{
								"token"                : testResetToken,
								"password"             : "testing123",
								"passwordConfirmation" : "testing123"
							}
						);
						expect( event.getResponse() ).toHaveStatus( 200 );
						expect( event.getResponse().getMessagesString() ).toInclude(
							"Password reset completed"
						);
					} );
				} );
				given( "a valid token but incoming passwords don't match", function(){
					then( "I should get an error", function(){
						// Now Logout
						var event = POST(
							"/cbapi/v1/resetPassword",
							{
								"token"                : testResetToken,
								"password"             : "12345678abc$dd",
								"passwordConfirmation" : "12344"
							}
						);
						expect( event.getResponse() ).toHaveStatus( 400 );
						expect( event.getResponse().getMessagesString() ).toInclude(
							"Passwords do not match"
						);
					} );
				} );
				given( "an invalid token", function(){
					then( "I should get an error", function(){
						// Now Logout
						var event = POST(
							"/cbapi/v1/resetPassword",
							{ "token" : "12312312sadfasd4" }
						);
						expect( event.getResponse() ).toHaveStatus( 500 );
					} );
				} );
			} );
		} );
	}

}
