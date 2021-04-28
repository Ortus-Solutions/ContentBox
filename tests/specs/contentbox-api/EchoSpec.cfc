component extends="tests.resources.BaseApiTest" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		// do your own stuff here
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "My ContentBox RESTFUl Service", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			} );

			it( "can handle invalid HTTP Calls", function(){
				var event = execute(
					event          = "contentbox-api-v1:echo.onInvalidHTTPMethod",
					renderResults  = true,
					eventArguments = { faultAction : "test" }
				);
				var response = event.getPrivateValue( "response" );
				expect( response.getError() ).toBeTrue();
				expect( response.getStatusCode() ).toBe( 405 );
			} );

			it( "can handle global exceptions", function(){
				var event = execute(
					event          = "contentbox-api-v1:echo.onError",
					renderResults  = true,
					eventArguments = {
						exception : {
							message    : "unit test",
							detail     : "unit test",
							stacktrace : ""
						}
					}
				);

				var response = event.getPrivateValue( "response" );
				expect( response.getError() ).toBeTrue();
				expect( response.getStatusCode() ).toBe( 500 );
			} );

			it( "can handle an echo", function(){
				var event    = this.request( "/cbapi/v1" );
				var response = event.getPrivateValue( "response" );
				expect( response.getError() ).toBeFalse();
				expect( response.getData() ).toBe( "Welcome to the ContentBox API v1.x Services" );
			} );

			it( "can handle missing actions", function(){
				var event    = this.request( "/cbapi/v1/echo/bogus" );
				var response = event.getPrivateValue( "response" );
				expect( response.getError() ).tobeTrue();
				expect( response.getStatusCode() ).toBe( 404 );
			} );
		} );
	}

}
