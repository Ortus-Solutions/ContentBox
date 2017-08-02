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
	};

	/**
	* Pre handler
	*/
	function preHandler( event, currentAction, rc, prc ){
		super.preHandler( argumentCollection=arguments );
		// If current author is not logged in, they can't access the secondary validation
		if( !prc.oCurrentAuthor.isLoggedIn() ){
			// message and redirect
			messagebox.warn( cb.r( "messages.notauthenticated@security" ) );
			// Relocate
			setNextEvent( "#prc.entryPoint#.security.login" );
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

		// Verify the challenge code
		var results = twoFactorService.verifyChallenge( 
			code   = rc.twofactorcode, 
			author = prc.oCurrentAuthor 
		);

		// Check for errors
		if( results.error ){
			announceInterception( "cbadmin_onInvalidTwoFactor", { author = prc.oCurrentAuthor } );
			// message and redirect
			messagebox.error( results.messages );
			setNextEvent( "#prc.entryPoint#.twofactor" );
		} else {
			// Are we trusting devices? If so, trust this device
			if( twoFactorService.getDefaultProviderObject().allowTrustedDevice() ){
				twoFactorService.setTrustedDevice( prc.oCurrentAuthor.getAuthorID() );
			}
			// announce event
			announceInterception( "cbadmin_onValidTwoFactor", { author = prc.oCurrentAuthor } );
			// Redirect to dashboard, success!!
			setNextEvent( "#prc.cbAdminEntryPoint#.dashboard" );
		}
	}

	/**
	* Resend a two-factor validation code
	*/
	function resendCode( event, rc, prc ){
		// Send challenge
		twoFactorService.sendChallenge( prc.oCurrentAuthor );
		// message and redirect
		messagebox.info( cb.r( "twofactor.codesent@security" ) );
		// Relocate
		setNextEvent( "#prc.entryPoint#.twofactor" );
	}

}