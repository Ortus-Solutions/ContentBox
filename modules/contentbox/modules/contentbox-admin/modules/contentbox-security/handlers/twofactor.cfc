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
			setNextEvent( "#prc.entryPoint#.login" );
		}
		// Inflate author for requested events
		prc.oAuthor = authorService.get( flash.get( "authorData" ).authorID );
		// Verify author, just in case
		if( isNull( prc.oAuthor ) OR !prc.oAuthor.isLoaded() ){
			// message and redirect
			messagebox.warn( cb.r( "messages.notauthenticated@security" ) );
			// Relocate
			setNextEvent( "#prc.entryPoint#.login" );
		}
	}

	/**
	* Present Two-Factor Challenge
	*/
	function index( event, rc, prc ){
		prc.xehValidate = "#prc.entryPoint#.twofactor.doValidation";
		prc.xehResend 	= "#prc.entryPoint#.twofactor.resendCode";
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
			setNextEvent( "#prc.entryPoint#.twofactor" );
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
			// Set in session, validations are now complete
			securityService.setAuthorSession( prc.oAuthor );
			
			// announce events
			announceInterception( "cbadmin_onValidTwoFactor", { author = prc.oAuthor } );
			// announce event
			announceInterception( "cbadmin_onLogin", { author = prc.oAuthor, securedURL = authorData.securedURL } );
			
			// check if securedURL came in?
			if( len( authorData.securedURL ) ){
				setNextEvent( uri=authorData.securedURL );
			} else {
				setNextEvent( "#prc.cbAdminEntryPoint#.dashboard" );
			}
		}
	}

	/**
	* Resend a two-factor validation code
	*/
	function resendCode( event, rc, prc ){
		// Send challenge
		prc.twoFactorResult = twoFactorService.sendChallenge( prc.oAuthor );
		// check the result of the send request
		if( prc.twoFactorResult.error ){
			// log the error and notify the user
			log.error( prc.twoFactorResult.messages ); 
			messagebox.warning( "There was an error sending your code. Please contact the site administrator for more information." );
		} else {
			// message and redirect
			messagebox.info( cb.r( "twofactor.codesent@security" ) );
		}
		// Relocate
		setNextEvent( "#prc.entryPoint#.twofactor" );
	}

}
