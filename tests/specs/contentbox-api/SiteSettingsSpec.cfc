component extends="tests.resources.BaseApiTest" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	/**
	 * executes before all suites+specs in the run() method
	 */
	function beforeAll() {
		super.beforeAll();
		// Log in admin
		variables.loggedInData = loginUser();
	}

	/**
	 * executes after all suites+specs in the run() method
	 */
	function afterAll() {
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run( testResults, testBox ) {
		// all your suites go here.
		describe(
			"Sites Settings API Suite",
			() => {
				beforeEach(
					( currentSpec ) => {
						// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
						setup();
					}
				);

				story(
					"I want to get site settings",
					() => {
						given(
							"a valid site slug",
							() => {
								then(
									"it can display all site settings",
									() => {
										var event = this.get( "/cbapi/v1/sites/default/settings" );
										expect( event.getResponse() ).toHaveStatus( 200 );
										expect( event.getResponse().getData() ).toBeStruct().notToBeEmpty();
									}
								);
							}
						);

						given(
							"an invalid site slug",
							() => {
								then(
									"it will show me an error",
									() => {
										var event = this.get( "/cbapi/v1/sites/bogus/settings" );
										expect( event.getResponse() ).toHaveStatus( 404 );
									}
								);
							}
						);
					}
				); // end story list all sites
			}
		); // end describe
	}


	// end run
}