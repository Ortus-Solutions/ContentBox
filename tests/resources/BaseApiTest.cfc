component extends="BaseTest" {

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