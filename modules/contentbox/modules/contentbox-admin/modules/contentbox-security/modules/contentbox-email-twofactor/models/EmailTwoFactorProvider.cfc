/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Provides email two factor authentication. This provider leverages the `template` cache
 * to store unique tokens.
 */
component
	extends   ="contentbox.models.security.twofactor.BaseTwoFactorProvider"
	implements="contentbox.models.security.twofactor.ITwoFactorProvider"
	singleton
	threadsafe
{

	// DI
	property name="mailService" inject="mailService@cbmailservices";
	property name="cache" inject="cachebox:template";

	// Static Variables
	variables.ALLOW_TRUSTED_DEVICE = true;
	variables.TOKEN_TIMEOUT        = 5;

	/**
	 * Constructor
	 */
	function init(){
		return this;
	}

	/**
	 * Get the internal name of the provider
	 */
	function getName(){
		return "email";
	}

	/**
	 * Get the display name of the provider
	 */
	function getDisplayName(){
		return "Email";
	};

	/**
	 * Returns html to display to the user for required two-factor fields
	 */
	function getAuthorSetupForm( required author ){
		return "
            <label class=""control-label"" for=""email"">Email: </label>
            <input class=""form-control"" disabled type=""email"" id=""email"" name=""email"" value=""#author.getEmail()#"" />
        ";
	}

	/**
	 * Get the display help for the provider.  Used in the UI setup screens for the author
	 */
	function getAuthorSetupHelp( required author ){
		return "Make sure you have a valid email address setup in your author details.  We will use this email account
			to send you verification tokens to increase your account's security.";
	}

	/**
	 * Get the display help for the provider.  Used in the UI verification screen.
	 */
	function getVerificationHelp(){
		return "Please enter the verification code that was sent to your account email address.";
	}

	/**
	 * Get the author options form. This will be sent for saving. You can listen to save operations by
	 * listening to the event 'cbadmin_onAuthorTwoFactorSaveOptions'
	 */
	function getAuthorOptions(){
		return "";
	}

	/**
	 * If true, then ContentBox will set a tracking cookie for the authentication provider user browser.
	 * If the user, logs in and the device is within the trusted timespan, then no two-factor authentication validation will occur.
	 */
	boolean function allowTrustedDevice(){
		return variables.ALLOW_TRUSTED_DEVICE;
	}

	/**
	 * This function will store a validation token in hash for the user to validate on
	 *
	 * @author The author to create the token for.
	 */
	string function generateValidationToken( required author ){
		// Store Security Token For X minutes
		var token = left( hash( arguments.author.getEmail() & arguments.author.getAuthorID() & now() ), 6 );
		// Cache the code for 5 minutes
		variables.cache.set(
			"email-twofactor-token-#token#",
			arguments.author.getAuthorID(),
			TOKEN_TIMEOUT,
			TOKEN_TIMEOUT
		);
		return token;
	}

	/**
	 * Send a challenge via the 2 factor auth implementation.
	 * The return must be a struct with an error boolean bit and a messages string
	 *
	 * @author The author to challenge
	 *
	 * @return struct:{ error:boolean, messages=string }
	 */
	struct function sendChallenge( required author ){
		var results  = { "error" : false, "messages" : "" };
		var settings = getAllSettings();
		var site     = getDefaultSite();

		try {
			var token = generateValidationToken( arguments.author );

			// Build body tokens
			var bodyTokens = {
				name         : arguments.author.getFullName(),
				email        : arguments.author.getEmail(),
				username     : arguments.author.getUsername(),
				ip           : variables.securityService.getRealIP(),
				tokenTimeout : TOKEN_TIMEOUT,
				token        : token,
				siteName     : site.getName()
			};

			// Build email out
			var mail = variables.mailservice.newMail(
				to        : arguments.author.getEmail(),
				from      : settings.cb_site_outgoingEmail,
				subject   : "#site.getName()# Two Factor Validation",
				bodyTokens: bodyTokens,
				type      : "html",
				server    : settings.cb_site_mail_server,
				username  : settings.cb_site_mail_username,
				password  : settings.cb_site_mail_password,
				port      : settings.cb_site_mail_smtp,
				useTLS    : settings.cb_site_mail_tls,
				useSSL    : settings.cb_site_mail_ssl
			);

			mail.setBody(
				variables.renderer.renderLayout(
					layout = "/contentbox/email_templates/layouts/email",
					view   = "/contentbox-email-twofactor/emails/verification"
				)
			);

			// send it out
			var mailResults = variables.mailService.send( mail );

			// Check for errors
			if ( mailResults.error ) {
				results.error    = true;
				results.messages = arrayToList( mailResults.errorArray );
			} else {
				results.messages = "Validation code sent!";
			}

			// Send it to the user
		} catch ( Any e ) {
			results.error    = true;
			results.messages = "Error Sending Email Challenge: #e.message# #e.detail#";
			// Log this.
			variables.log.error( "Error Sending Email Challenge: #e.message# #e.detail#", e );
		}

		return results;
	}

	/**
	 * Verify the challenge
	 *
	 * @code   The verification code
	 * @author The author to verify challenge
	 *
	 * @return struct:{ error:boolean, messages:string }
	 */
	struct function verifyChallenge( required string code, required author ){
		var results  = { "error" : false, "messages" : "" };
		var authorID = variables.cache.get( "email-twofactor-token-#arguments.code#" );

		// Verify it exists and is valid
		if ( !isNull( authorID ) AND arguments.author.getAuthorID() eq authorID ) {
			results.messages = "Code validated!";
		} else {
			results.error    = true;
			results.messages = "Invalid code. Please try again!";
		}

		return results;
	}

	/**
	 * This method is called once a two factor challenge is accepted and valid.
	 * Meaning the user has completed the validation and will be logged in to ContentBox now.
	 *
	 * @code   The verification code
	 * @author The author to verify challenge
	 */
	function finalize( required string code, required author ){
		// clear out the codes
		variables.cache.clear( "email-twofactor-token-#arguments.code#" );
	}

}
