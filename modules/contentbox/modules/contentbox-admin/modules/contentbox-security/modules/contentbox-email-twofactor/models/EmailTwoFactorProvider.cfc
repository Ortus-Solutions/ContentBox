/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Provides email two factor authentication. This provider leverages the `template` cache
* to store unique tokens.
*/
component 
	extends="contentbox.models.security.twofactor.BaseTwoFactorProvider"
	implements="contentbox.models.security.twofactor.ITwoFactorProvider"
	singleton{

	// DI
	property name="mailService"		inject="mailService@cbmailservices";
	property name="cache"			inject="cachebox:template";

	// Static Variables
	variables.ALLOW_TRUSTED_DEVICE 	= true;
	variables.TOKEN_TIMEOUT 		= 5;

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
	* Get the display help for the provider.  Used in the UI verification screen.
	*/
	function getDisplayHelp(){
		return "Please enter the verification code that was sent to your account email address.";
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
		var token = hash( arguments.author.getEmail() & arguments.author.getAuthorID() & now() );
		// Cache the code for 5 minutes
		cache.set(
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
		var results 	= { "error" = false, "messages" = "" };
		var settings 	= getAllSettings();

		try{
			var token = generateValidationToken( arguments.author );

			// Build body tokens
			var bodyTokens = {
				name 			= arguments.author.getName(),
				email 			= arguments.author.getEmail(),
				username 		= arguments.author.getUsername(),
				ip 				= settingService.getRealIP(),
				tokenTimeout 	= TOKEN_TIMEOUT,
				token 			= token,
				siteName 		= settings.cb_site_name
			};

			// Build email out
			var mail = mailservice.newMail(
				to			= arguments.author.getEmail(),
				from		= settings.cb_site_outgoingEmail,
				subject		= "#settings.cb_site_name# Two Factor Validation",
				bodyTokens	= bodyTokens,
				type		= "html",
				server		= settings.cb_site_mail_server,
				username	= settings.cb_site_mail_username,
				password	= settings.cb_site_mail_password,
				port		= settings.cb_site_mail_smtp,
				useTLS		= settings.cb_site_mail_tls,
				useSSL		= settings.cb_site_mail_ssl
			);

			mail.setBody(
				renderer.get()
					.renderLayout(
						layout 		= "/contentbox/email_templates/layouts/email",
						view 		= "emails/verification",
						args 		= { viewModule 	= "contentbox-email-twofactor" }
					)
			);

			// send it out
			var mailResults = mailService.send( mail );

			// Check for errors
			if( mailResults.error ){
				results.error 		= true;
				results.messages 	= arrayToList( mailResults.errorArray );
			} else {
				results.messages = "Validation code sent!";
			}
			
			// Send it to the user
		} catch( Any e ){
			results.error 		= true;
			results.messages 	= "Error Sending Email Challenge: #e.message# #e.detail#"; 
			// Log this.
			log.error( "Error Sending Email Challenge: #e.message# #e.detail#", e );
		}
		
		return results;
	}

	/**
	 * Verify the challenge 
	 * 
	 * @code The verification code
	 * @author The author to verify challenge
	 *
	 * @return struct:{ error:boolean, messages:string }
	 */
	struct function verifyChallenge( required string code, required author ){
		var results = { "error" : false, "messages" = "" };
		var authorID = cache.get( "email-twofactor-token-#arguments.code#" );

		// Verify it exists and is valid
		if( !isNull( authorID ) AND arguments.author.getAuthorID() eq authorID ){
			results.messages = "Code validated!";
		} else {
			results.error = true;
			results.messages = "Invalid code. Please try again!";
		}

		return results;
	}

}