/**
 * ContentBox API Authentication handler
 */
component extends="baseHandler" {

	// DI
	property name="securityService" inject="securityService@cb";

	/**
	 * Login to ContentBox and get your JWT Token
	 */
	function login( event, rc, prc ){
		param rc.username       = "";
		param rc.password       = "";
		param rc.includes       = "permissions,permissionGroups,role.permissions";
		param rc.excludes       = "";
		param rc.ignoreDefaults = false;

		// Let's try to get log them in
		prc.token = jwtAuth().attempt( rc.username, rc.password );

		// If we get here, credentials are good to go!

		// Verify if user needs to reset their password?
		if ( prc.oCurrentAuthor.getIsPasswordReset() ) {
			var errorMessage = "Your user needs to reset their password before using the API Services";
			prc.response
				.setErrorMessage( errorMessage, event.STATUS.NOT_ALLOWED )
				.addMessage(
					"Please visit #variables.cb.linkAdminLogin()# in order to reset your password."
				);
			return;
		}

		// Ok, we can log them in now for the request
		variables.securityService.login( prc.oCurrentAuthor );

		// Build out the response
		prc.response
			.setData( {
				"token"  : prc.token,
				"author" : prc.oCurrentAuthor.getMemento(
					includes       = rc.includes,
					excludes       = rc.excludes,
					ignoreDefaults = rc.ignoreDefaults
				)
			} )
			.addMessage(
				"Bearer token created and it expires in #jwtAuth().getSettings().jwt.expiration# minutes"
			);
	}

	/**
	 * Logout from ContentBox, you must pass in your JWT Token else we don't know who you are :)
	 */
	function logout( event, rc, prc ){
		jwtAuth().logout();
		prc.response.addMessage( "Bye bye!" );
	}

	/**
	 * If logged in, you will be able to see your user information.
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
