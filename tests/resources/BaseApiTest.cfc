component extends="tests.resources.BaseTest" appMapping="/root" autowire=true{

	// DI
	property name="securityService" inject="securityService@cb";
	property name="cbsecure"        inject="CBSecurity@cbsecurity";
	property name="jwt"             inject="JWTService@cbsecurity";

	/**
	 * --------------------------------------------------------------------------
	 * Fixture Data
	 * --------------------------------------------------------------------------
	 * Here is the global fixture data you can use
	 */
	variables.bCryptHashOfPasswordTest = "$2a$12$FE2J7ZLWaI2rSqejAu/84uLy7qlSufQsDsSE1lNNKyA05GG30gr8C";
	variables.testPassword             = "test";
	variables.testAdminUsername = "lmajano";
	variables.testAdminPassword = "lmajano";

	function beforeAll(){
		super.beforeAll();

		// Override the JWT Token Storage due to Lucee Bug
		// TODO: Remove when Lucee fixes their crap! Feature not supported when doing transactions with orm/qb
		variables.jwt.getSettings().jwt.tokenStorage.driver = "cachebox";
		variables.jwt.getSettings().jwt.tokenStorage.properties = { cacheName : "default" };

		// Logout just in case
		variables.securityService.logout();

		// Add Custom Matchers: REMOVE once we fix the issue in the ColdBox matchers.
		addMatchers( {
			toHaveStatus : ( expectation, args = {} ) => {
				// handle both positional and named arguments
				param args.statusCode = "";
				if ( structKeyExists( args, 1 ) ) {
					args.statusCode = args[ 1 ];
				}
				param args.message = "";
				if ( structKeyExists( args, 2 ) ) {
					args.message = args[ 2 ];
				}
				if ( !len( args.statusCode ) ) {
					expectation.message = "No status code provided.";
					return false;
				}
				var statusCode = expectation.actual.getStatusCode();
				if ( statusCode != args.statusCode ) {
					expectation.message = "#args.message#. Received incorrect status code. Expected [#args.statusCode#]. Received [#statusCode#].";
					debug( expectation.actual.getMemento() );
					return false;
				}
				return true;
			},
			// Verifies invalid cbValidation data
			toHaveInvalidData : ( expectation, args = {} ) => {
				param args.field = "";
				if ( structKeyExists( args, 1 ) ) {
					args.field = args[ 1 ];
				}
				param args.error = "";
				if ( structKeyExists( args, 2 ) ) {
					args.error = args[ 2 ];
				}
				param args.message = "";
				if ( structKeyExists( args, 3 ) ) {
					args.message = args[ 3 ];
				}

				// If !400 then there is no invalid data
				if ( expectation.actual.getStatusCode() != 400 ) {
					expectation.message = "#args.message#. Received incorrect status code. Expected [400]. Received [#expectation.actual.getStatusCode()#].";
					debug( expectation.actual.getMemento() );
					return false;
				}
				// If no field passed, we just check that invalid data was found
				if ( !len( args.field ) ) {
					if ( expectation.actual.getData().isEmpty() ) {
						expectation.message = "#args.message#. Received incorrect status code. Expected [400]. Received [#expectation.actual.getStatusCode()#].";
						debug( expectation.actual.getMemento() );
						return false;
					}
					return true;
				}
				// We have a field to check and it has data
				if (
					!structKeyExists(
						expectation.actual.getData(),
						args.field
					) || expectation.actual.getData()[ args.field ].isEmpty()
				) {
					expectation.message = "#args.message#. The requested field [#args.field#] does not have any invalid data.";
					debug( expectation.actual.getMemento() );
					return false;
				}
				// Do we have any error messages to check?
				if ( len( args.error ) ) {
					try {
						expect(
							expectation.actual.getData()[ args.field ]
								.map( ( item ) => item.message )
								.toList()
						).toInclude( args.error );
					} catch ( any e ) {
						debug( expectation.actual.getMemento() );
						rethrow;
					}
				}

				// We checked and it's all good!
				return true;
			}
		} );
	}

	/**
	 * Decorator for each coldbox request setup, basically, put the jwt token in place if logged in
	 */
	function setup(){
		super.setup();

		if ( !isNull( request.testUserData ) ) {
			getRequestContext().setValue(
				"x-auth-token",
				request.testUserData.token
			);
		}

		return;
	}

	/**
	 * Logs in a user into ContentBox. By default we use a fixture username
	 *
	 * @username You can override which user by passing their username here
	 *
	 * @return struct of { user:logged in user, token: their token}
	 */
	struct function loginUser( username = variables.testAdminUsername ){
		request.testUserData = {
			"token" : variables.jwt.attempt( arguments.username, variables.testAdminPassword ),
			"user"  : variables.securityService.getUser()
		};
		return request.testUserData;
	}

}