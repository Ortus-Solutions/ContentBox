/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ContentBox two factor authenticator handler
*/
component extends="baseHandler"{

	// Method Security
	this.allowedMethods = {
		"index" 		= "GET",
		"doValidation" 	= "POST",
		"resendCode" 	= "GET"
	};

	/**
	* Pre handler
	*/
	function preHandler( event, currentAction, rc, prc ){
		super.preHandler( argumentCollection=arguments );
		// Keep Flash data
		flash.keep( "authorData" );
		// Verify if authorData exists, else you can't authenticate via two factor.
		if( !flash.exists( "authorData" ) ){
			// message and redirect
			messagebox.warn( cb.r( "messages.notauthenticated@security" ) );
			// Relocate
			relocate( "#prc.cbAdminEntryPoint#.security.login" );
		}
		// Inflate author for requested events
		prc.oAuthor = authorService.get( flash.get( "authorData" ).authorID );
		// Verify author, just in case
		if( isNull( prc.oAuthor ) OR !prc.oAuthor.isLoaded() ){
			// message and redirect
			messagebox.warn( cb.r( "messages.notauthenticated@security" ) );
			// Relocate
			relocate( "#prc.cbAdminEntryPoint#.security.login" );
		}
	}

	/**
	 * Present Two-Factor Challenge
	 *
	 * Input Parameters
	 * - authorID : To whom we are challenging, defaults to 0
	 * - isEnrollment : Are we in enrollment mode, defaults to false
	 * - rememberMe : Do we remember the device, defaults to false
	 * - securedURL : Where to go next as relocation, defaults to ""
	 */
	function index( event, rc, prc ){
		prc.xehValidate = "#prc.cbAdminEntryPoint#.security.twofactor.doValidation";
		prc.xehResend 	= "#prc.cbAdminEntryPoint#.security.twofactor.resendCode";
		prc.provider 	= twoFactorService.getDefaultProviderObject();

		event.setView( "twofactor/index" );
	}

	/**
	* Validate the two factor code against a provider
	*/
	function doValidation( event, rc, prc ){
		event.paramValue( "twofactorCode", "" )
			.paramValue( "trustDevice", false );

		// Get author data
		var authorData = flash.get( "authorData" );

		// Verify the challenge code
		var results = twoFactorService.verifyChallenge(
			code   = rc.twofactorcode,
			author = prc.oAuthor
		);

		// Check for errors
		if( results.error ){
			announceInterception( "cbadmin_onInvalidTwoFactor", { author = prc.oAuthor } );
			// message and redirect
			messagebox.error( results.messages );
			flash.keep( "authorData" );
			relocate( "#prc.cbAdminEntryPoint#.security.twofactor" );
		} else {
			var oTwoFactorProvider = twoFactorService.getDefaultProviderObject();
			// Are we trusting devices? If so, trust this device if passed
			if( oTwoFactorProvider.allowTrustedDevice() AND rc.trustDevice ){
				twoFactorService.setTrustedDevice( prc.oAuthor.getAuthorID() );
			}
			// Call Provider finalize callback, in case something is needed for teardowns
			oTwoFactorProvider.finalize( rc.twofactorcode, prc.oAuthor );
			// Set keep me log in remember cookie, if set.
			securityService.setRememberMe( prc.oAuthor.getUsername(), val( authorData.rememberMe ) );
			// announce valid two factor
			announceInterception( "cbadmin_onValidTwoFactor", { author = prc.oAuthor } );

			// Are we in enrollment or loging in mode.
			if( authorData.isEnrollment ){
				prc.oAuthor.setIs2FactorAuth( true );
				authorService.save( prc.oAuthor );
				messagebox.info( cb.r( "twofactor.enrollmentSuccess@security" ) );
			}

			// If you are logged in already, then skip this
			if( !prc.oCurrentAuthor.isLoggedIn() ){
				// Set in session, validations are now complete
				securityService.setAuthorSession( prc.oAuthor );
				// announce event
				announceInterception( "cbadmin_onLogin", { author = prc.oAuthor, securedURL = authorData.securedURL } );
			}

			// check if securedURL came in?
			if( len( authorData.securedURL ) ){
				relocate( uri=authorData.securedURL );
			} else {
				relocate( "#prc.cbAdminEntryPoint#.dashboard" );
			}
		}
	}

	/**
	* Resend a two-factor validation code
	*/
	function resendCode( event, rc, prc ){
		// Send challenge
		var twoFactorResults = twoFactorService.sendChallenge( prc.oAuthor );
		// Verify error, if so, log it and setup a messagebox
		if( twoFactorResults.error ){
			log.error( twoFactorResults.messages );
			messagebox.error( cb.r( "twofactor.error@security" ) );
		} else {
			// message and redirect
			messagebox.info( cb.r( "twofactor.codesent@security" ) );
		}
		// Keep Data
		flash.keep( "authorData" );
		// Relocate
		relocate( "#prc.cbAdminEntryPoint#.security.twofactor" );
	}

}
