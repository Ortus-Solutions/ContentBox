/**
 * ContentBox API Authentication handler
 */
component extends="baseHandler" {

	// DI
	property name="securityService" inject="securityService@contentbox";

	/**
	 * Login to ContentBox and get your JWT Token
	 *
	 * @tags        Authentication
	 * @requestBody contentbox/apidocs/auth/login/requestBody.json
	 * @responses   contentbox/apidocs/auth/login/responses.json
	 */
	function login( event, rc, prc ){
		param rc.username       = "";
		param rc.password       = "";
		param rc.includes       = "permissions,permissionGroups,role.permissions";
		param rc.excludes       = "";
		param rc.ignoreDefaults = false;

		// Let's try to get log them in
		prc.tokens = jwtAuth().attempt( rc.username, rc.password );

		// If we get here, credentials are good to go!

		// Verify if user needs to reset their password?
		if ( prc.oCurrentAuthor.getIsPasswordReset() ) {
			var errorMessage = "Your user needs to reset their password before using the API Services";
			prc.response
				.setErrorMessage( errorMessage, event.STATUS.NOT_ALLOWED )
				.addMessage( "Please visit #variables.cb.linkAdminLogin()# in order to reset your password." );
			return;
		}

		// Ok, we can log them in now for the request
		variables.securityService.login( prc.oCurrentAuthor );

		// Build out the response
		prc.response
			.setData( {
				"tokens" : prc.tokens,
				"author" : prc.oCurrentAuthor.getMemento(
					includes       = rc.includes,
					excludes       = rc.excludes,
					ignoreDefaults = rc.ignoreDefaults
				)
			} )
			.addMessage( "Bearer token created and it expires in #jwtAuth().getSettings().jwt.expiration# minutes" )
			.addMessage(
				"Refresh token created and it expires in #jwtAuth().getSettings().jwt.refreshExpiration# minutes"
			);
	}

	/**
	 * Logout from ContentBox, you must pass in your JWT Token else we don't know who you are :)
	 *
	 * @tags Authentication
	 */
	function logout( event, rc, prc ){
		jwtAuth().logout();
		prc.response.addMessage( "Bye bye!" );
	}


	/**
	 * Refresh your access token, you must pass in your JWT Refresh token
	 *
	 * @tags Authentication
	 */
	function refreshToken( event, rc, prc ){
		try {
			// Do cool refreshments via header/rc discovery
			prc.newTokens = jwtAuth().refreshToken();
			// Send valid response
			event
				.getResponse()
				.setData( prc.newTokens )
				.addMessage( "Tokens refreshed! The passed in refresh token has been invalidated" );
		} catch ( RefreshTokensNotActive e ) {
			return event.getResponse().setErrorMessage( "Refresh Tokens Not Active", 404, "Disabled" );
		} catch ( TokenNotFoundException e ) {
			return event
				.getResponse()
				.setErrorMessage(
					"The refresh token was not passed via the header or the rc. Cannot refresh the unrefreshable!",
					400,
					"Missing refresh token"
				);
		}
	}


	/**
	 * If logged in, you will be able to see your user information.
	 *
	 * @tags Authentication
	 */
	function whoami( event, rc, prc ) secure{
		param rc.includes       = "permissions,permissionGroups,role.permissions";
		param rc.excludes       = "";
		param rc.ignoreDefaults = false;

		prc.response.setData(
			jwtAuth()
				.getUser()
				.getMemento(
					includes       = rc.includes,
					excludes       = rc.excludes,
					ignoreDefaults = rc.ignoreDefaults
				)
		);
	}

}
