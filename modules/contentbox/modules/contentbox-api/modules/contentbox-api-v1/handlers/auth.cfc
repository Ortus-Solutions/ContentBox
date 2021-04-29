/**
 * ContentBox API Authentication handler
 */
component extends="BaseHandler" {

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

		prc.token = jwtAuth().attempt( rc.username, rc.password );
		prc.response
			.setData( {
				"token" : prc.token,
				"user"  : cbSecure()
					.getAuthService()
					.getUser()
					.getMemento(
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
