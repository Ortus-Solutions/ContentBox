/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * ContentBox security handler
 */
component extends="baseHandler" {

	// DI
	property name="antiSamy" inject="antisamy@cbantisamy";
	property name="markdown" inject="Processor@cbmarkdown";

	// Method Security
	this.allowedMethods = { doLogin : "POST", doLostPassword : "POST" };

	/**
	 * Change language
	 */
	function changeLang( event, rc, prc ){
		event.paramValue( "lang", "en_US" );
		setFWLocale( rc.lang );
		relocate( "#prc.cbAdminEntryPoint#/security" );
	}

	/**
	 * Login screen
	 */
	function login( event, rc, prc ){
		// exit handlers
		prc.xehDoLogin      = "#prc.cbAdminEntryPoint#.security.doLogin";
		prc.xehLostPassword = "#prc.cbAdminEntryPoint#.security.lostPassword";
		// remember me
		prc.rememberMe      = variables.antiSamy.htmlSanitizer( variables.securityService.getRememberMe() );
		// secured URL from security interceptor
		arguments.event.paramValue( "_securedURL", "" );
		rc._securedURL = variables.antiSamy.htmlSanitizer( rc._securedURL );
		// Markdown Processing of sign in text
		prc.signInText = variables.markdown.toHTML( prc.cbSettings.cb_security_login_signin_text );
		// view
		event.setView( view = "security/login" );
	}

	/**
	 * Do a login
	 */
	function doLogin( event, rc, prc ){
		// params
		event
			.paramValue( "rememberMe", 0 )
			.paramValue( "_securedURL", "" )
			.paramValue( "_csrftoken", "" );

		// Sanitize
		rc.username    = variables.antiSamy.htmlSanitizer( rc.username );
		rc.password    = variables.antiSamy.htmlSanitizer( rc.password );
		rc.rememberMe  = variables.antiSamy.htmlSanitizer( rc.rememberMe );
		rc._securedURL = variables.antiSamy.htmlSanitizer( rc._securedURL );
		rc._csrftoken  = variables.antiSamy.htmlSanitizer( rc._csrftoken );

		// announce event
		announce( "cbadmin_preLogin" );

		// CSRF Checks
		if ( !csrfVerify( rc._csrftoken ) ) {
			variables.messagebox.warning( cb.r( "messages.invalid_token@security" ) );
			return relocate( "#prc.cbAdminEntryPoint#.security.login" );
		}

		try {
			// Authenticate credentials: Don't log them in because we could have a reset password bit or a mfa check.
			prc.oAuthor = securityService.authenticate(
				username : rc.username,
				password : rc.password,
				logThemIn: false
			);

			// Verify if user needs to reset their password?
			if ( prc.oAuthor.getIsPasswordReset() ) {
				var token = variables.securityService.generateResetToken( prc.oAuthor );
				variables.messagebox.info( cb.r( "messages.password_reset_detected@security" ) );
				return relocate( event = "#prc.cbAdminEntryPoint#.security.verifyReset", queryString = "token=#token#" );
			}

			// If Global MFA is turned on and the user is not enrolled to a provider, then force it to enroll
			if ( variables.twoFactorService.isForceTwoFactorAuth() AND !prc.oAuthor.getIs2FactorAuth() ) {
				return runEvent(
					event          = "contentbox-security:twoFactorEnrollment.forceEnrollment",
					eventArguments = {
						authorID      : prc.oAuthor.getAuthorID(),
						relocationURL : _securedURL,
						rememberMe    : rc.rememberMe
					}
				);
			}

			// Verify if we have to challenge via two factor auth
			if ( variables.twoFactorService.canChallenge( prc.oAuthor ) ) {
				// Flash data needed for authorizations
				flash.put(
					"authorData",
					{
						authorID     : prc.oAuthor.getAuthorID(),
						rememberMe   : rc.rememberMe,
						securedURL   : rc._securedURL,
						isEnrollment : false
					}
				);
				// Send challenge
				var twoFactorResults = variables.twoFactorService.sendChallenge( prc.oAuthor );
				// Verify error, if so, log it and setup a messagebox
				if ( twoFactorResults.error ) {
					log.error( twoFactorResults.messages );
					variables.messagebox.error( cb.r( "twofactor.error@security" ) );
				}
				// Relocate to two factor auth presenter
				relocate( "#prc.cbAdminEntryPoint#.security.twofactor" );
			}

			// Set keep me log in remember cookie, if set.
			variables.securityService.setRememberMe( username: rc.username, days: val( rc.rememberMe ) );
			// Set in session, validations are now complete
			variables.securityService.login( prc.oAuthor );

			// announce event
			announce( "cbadmin_onLogin", { author : prc.oAuthor, securedURL : rc._securedURL } );

			// check if securedURL came in?
			if ( len( rc._securedURL ) ) {
				relocate( uri = rc._securedURL );
			} else {
				relocate( "#prc.cbAdminEntryPoint#.dashboard" );
			}
		} catch ( InvalidCredentials e ) {
			// announce event
			announce( "cbadmin_onBadLogin" );
			// message and redirect
			variables.messagebox.warn( cb.r( "messages.invalid_credentials@security" ) );
			// Relocate back to login
			relocate( "#prc.cbAdminEntryPoint#.security.login" );
		} catch ( any e ) {
			rethrow;
		}
	}

	/**
	 * Logout a user
	 */
	function doLogout( event, rc, prc ){
		// announce event
		announce( "cbadmin_onLogout" );
		// logout
		variables.securityService.logout();
		// message redirect
		variables.messagebox.info( cb.r( "messages.seeyou@security" ) );
		// relocate
		var relocateTo = prc.cbSettings.cb_security_login_signout_url;
		if ( !len( relocateTo ) ) {
			relocateTo = "#prc.cbAdminEntryPoint#.security.login";
		}
		relocate( relocateTo );
	}

	/**
	 * Present lost password screen
	 */
	function lostPassword( event, rc, prc ){
		prc.xehLogin          = "#prc.cbAdminEntryPoint#.security.login";
		prc.xehDoLostPassword = "#prc.cbAdminEntryPoint#.security.doLostPassword";

		event.setView( "security/lostPassword" );
	}

	/**
	 * Do lost password reset
	 */
	function doLostPassword( event, rc, prc ){
		var errors  = [];
		var oAuthor = "";

		// Param email
		event.paramValue( "email", "" ).paramValue( "_csrftoken", "" );

		// Sanitize
		rc.email      = antiSamy.htmlSanitizer( rc.email );
		rc._csrftoken = antiSamy.htmlSanitizer( rc._csrftoken );

		if ( !csrfVerify( rc._csrftoken ) ) {
			messagebox.warning( cb.r( "messages.invalid_token@security" ) );

			return relocate( event = "#prc.cbAdminEntryPoint#.security.lostPassword" );
		}

		// Validate email
		if ( NOT trim( rc.email ).length() ) {
			arrayAppend( errors, "#cb.r( "validation.need_email@security" )#<br />" );
		} else {
			// Try To get the Author
			oAuthor = authorService.findWhere( { email : rc.email, isActive : 1 } );
			if ( isNull( oAuthor ) OR NOT oAuthor.isLoaded() ) {
				// Don't give away that the email did not exist.
				messagebox.info( cb.r( resource = "messages.lostpassword_check@security", values = "5" ) );
				return relocate( "#prc.cbAdminEntryPoint#.security.lostPassword" );
			}
		}

		// Check if Errors
		if ( NOT arrayLen( errors ) ) {
			// Send Reminder
			securityService.sendPasswordReminder( oAuthor );
			// announce event
			announce( "cbadmin_onPasswordReminder", { author : oAuthor } );
			// messagebox
			messagebox.info( cb.r( resource = "messages.reminder_sent@security", values = "30" ) );
		} else {
			// announce event
			announce( "cbadmin_onInvalidPasswordReminder", { errors : errors, email : rc.email } );
			// messagebox
			messagebox.error( errors );
		}
		// Re Route
		relocate( "#prc.cbAdminEntryPoint#.security.lostPassword" );
	}

	/**
	 * Verify the reset
	 */
	function verifyReset( event, rc, prc ){
		event.paramValue( "token", "" );

		// Sanitize
		rc.token = variables.antiSamy.htmlSanitizer( rc.token );

		// Validate Token
		var results = variables.securityService.validateResetToken( trim( rc.token ) );
		if ( results.error ) {
			// announce event
			announce( "cbadmin_onInvalidPasswordReset", { token : rc.token } );
			// Exception
			variables.messagebox.error( cb.r( "messages.invalid_token@security" ) );
			return relocate( "#prc.cbAdminEntryPoint#.security.lostPassword" );
		}

		// Present rest password page.
		prc.xehPasswordChange = "#prc.cbAdminEntryPoint#.security.doPasswordChange";
		event.setView( "security/verifyReset" );
	}

	/**
	 * Reset a user password. Must have a valid user token setup already
	 */
	function doPasswordChange( event, rc, prc ){
		event
			.paramValue( "token", "" )
			.paramValue( "password", "" )
			.paramValue( "password_confirmation", "" )
			.paramValue( "_csrftoken", "" );

		// Sanitize
		rc.token                 = antiSamy.htmlSanitizer( rc.token );
		rc.password              = antiSamy.htmlSanitizer( rc.password );
		rc.password_confirmation = antiSamy.htmlSanitizer( rc.password_confirmation );
		rc._csrftoken            = antiSamy.htmlSanitizer( rc._csrftoken );

		// Validate CSRF
		if ( !csrfVerify( rc._csrftoken ) ) {
			messagebox.warning( cb.r( "messages.invalid_token@security" ) );

			return relocate( event = "#prc.cbAdminEntryPoint#.security.verifyReset", queryString = "token=#rc.token#" );
		}

		// Validate passwords
		if ( !len( rc.password ) || !len( rc.password_confirmation ) ) {
			// Exception
			messagebox.error( cb.r( "messages.invalid_password@security" ) );
			relocate( event = "#prc.cbAdminEntryPoint#.security.verifyReset", queryString = "token=#rc.token#" );
			return;
		}

		// Validate confirmed password
		if ( compare( rc.password, rc.password_confirmation ) neq 0 ) {
			messagebox.error( cb.r( "messages.password_mismatch@security" ) );
			relocate( event = "#prc.cbAdminEntryPoint#.security.verifyReset", queryString = "token=#rc.token#" );
			return;
		}

		// Validate Token
		var results = securityService.validateResetToken( trim( rc.token ) );
		if ( results.error ) {
			// announce event
			announce( "cbadmin_onInvalidPasswordReset", { token : rc.token } );
			// Exception
			messagebox.error( cb.r( "messages.invalid_token@security" ) );
			relocate( "#prc.cbAdminEntryPoint#.security.lostPassword" );
			return;
		}

		// Validate you are not using the same password if persisted already
		if ( authorService.isSameHash( rc.password, results.author.getPassword() ) ) {
			// announce event
			announce( "cbadmin_onInvalidPasswordReset", { token : rc.token } );
			// Exception
			messagebox.error( cb.r( "messages.password_used@security" ) );
			relocate( event = "#prc.cbAdminEntryPoint#.security.verifyReset", queryString = "token=#rc.token#" );
			return;
		}

		// Token is valid, let's reset this sucker.
		var resetResults = securityService.resetUserPassword(
			token    = rc.token,
			author   = results.author,
			password = rc.password
		);

		if ( resetResults.error ) {
			// announce event
			announce( "cbadmin_onInvalidPasswordReset", { token : rc.token } );
			messagebox.error( resetResults.messages );
			relocate( "#prc.cbAdminEntryPoint#.security.lostPassword" );
			return;
		}

		// announce event and relcoate to login with new password
		announce( "cbadmin_onPasswordReset", { author : results.author } );
		messagebox.info( cb.r( "messages.password_reset@security" ) );
		relocate( "#prc.cbAdminEntryPoint#.security.login" );
	}

}
