/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * This is our security validator that works with CBSecurity in order to validate
 * rules and annotations when working with JWT tokens
 */
component extends="SecurityValidator" singleton {

	// Dependencies
	property name="jwt" inject="JWTService@cbsecurity";

	/**
	 * Validates if a user can access an event. Called via the cbSecurity module.
	 *
	 * @rule The security rule being tested for
	 * @controller The ColdBox controller calling the validation
	 *
	 * @return Validation struct of: { allow:boolean, type:(authentication|authorization), messages }
	 */
	struct function validateSecurity( struct rule, securedValue, any controller ){
		var results = {
			"allow"    : false,
			"type"     : "authentication",
			"messages" : ""
		};

		try {
			// Try to get the payload from the jwt token, if we have exceptions, we have failed :(
			var payload = variables.jwt.getPayload();
		} catch ( Any e ) {
			results.messages = e.type & ":" & e.message;
			return results;
		}

		// Get the currently logged in user that represents the token we just parsed
		var author = variables.securityService.getAuthorSession();

		// First check if user has been authenticated.
		if ( author.isLoaded() AND author.isLoggedIn() ) {
			// Check if the rule requires roles
			if ( !isNull( arguments.rule ) && len( arguments.rule.roles ) ) {
				for ( var x = 1; x lte listLen( arguments.rule.roles ); x++ ) {
					if ( listGetAt( arguments.rule.roles, x ) eq author.getRoleName() ) {
						results.allow = true;
						results.type  = "authorization";
						break;
					}
				}
			}

			// Check if the rule requires permissions
			if ( !isNull( arguments.rule ) && len( arguments.rule.permissions ) ) {
				for ( var y = 1; y lte listLen( arguments.rule.permissions ); y++ ) {
					if ( author.checkPermission( listGetAt( arguments.rule.permissions, y ) ) ) {
						results.allow = true;
						results.type  = "authorization";
						break;
					}
				}
			}

			// Check if the secured annotations is set
			if ( !isNull( arguments.securedValue ) && len( arguments.securedValue ) ) {
				for ( var y = 1; y lte listLen( arguments.securedValue ); y++ ) {
					if ( author.checkPermission( listGetAt( arguments.securedValue, y ) ) ) {
						results.allow = true;
						results.type  = "authorization";
						break;
					}
				}
			}

			results.allow = true;
		}

		return results;
	}

}
