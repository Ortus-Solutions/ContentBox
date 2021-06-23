component extends="tests.resources.BaseApiTest" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	/**
	 * executes before all suites+specs in the run() method
	 */
	function beforeAll(){
		super.beforeAll();
		// Log in admin
		variables.loggedInData = loginUser();
	}

	/**
	 * executes after all suites+specs in the run() method
	 */
	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ){
		// all your suites go here.
		describe( "Global Settings API Suite", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			} );

			story( "I want to get global settings", function(){
				given( "a valid request", function(){
					then( "it can display all global settings", function(){
						var event = this.get( "/cbapi/v1/settings" );
						expect( event.getResponse() ).toHaveStatus( 200 );
						expect( event.getResponse().getData() ).toBeStruct().notToBeEmpty();
						expect( event.getResponse().getData() ).notToHaveKey(
							"cb_enc_key,cb_salt,cb_site_mail_password"
						);
					} );
				} );
			} ); // end story list all sites
		} ); // end describe
	}
	// end run

}
