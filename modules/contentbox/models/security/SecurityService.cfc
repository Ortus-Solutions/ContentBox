/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Our contentbox security service
*/
component implements="ISecurityService" singleton{

	// Dependencies
	property name="authorService" 		inject="id:authorService@cb";
	property name="settingService"		inject="id:settingService@cb";
	property name="cacheStorage" 		inject="cacheStorage@cbStorages";
	property name="cookieStorage" 		inject="cookieStorage@cbStorages";
	property name="mailService"			inject="mailService@cbmailservices";
	property name="renderer"			inject="provider:ColdBoxRenderer";
	property name="CBHelper"			inject="id:CBHelper@cb";
	property name="log"					inject="logbox:logger:{this}";
	property name="cache"				inject="cachebox:template";
	property name="bCrypt"				inject="BCrypt@BCrypt";

	// Properties
	property name="encryptionKey";

	// Static Variables
	RESET_TOKEN_TIMEOUT = 60;

	/**
	* Constructor
	*/
	public SecurityService function init(){
		variables.encryptionKey = "";
		return this;
	}

	/**
	* Update an author's last login timestamp
	* @author The author object
	*/
	ISecurityService function updateAuthorLoginTimestamp( required author ){
		arguments.author.setLastLogin( now() );
		authorService.save( arguments.author );
		return this;
	}

	/**
	* Validates if a user can access an event. Called via the cbSecurity module.
	*
	* @rule The security rule being tested for
	* @controller The ColdBox controller calling the validation
	*/
	boolean function userValidator( required struct rule, any controller ){
		var isAllowed 	= false;
		var author 		= getAuthorSession();

		// First check if user has been authenticated.
		if( author.isLoaded() AND author.isLoggedIn() ){

			// Check if the rule requires roles
			if( len( rule.roles ) ){
				for(var x=1; x lte listLen( rule.roles ); x++){
					if( listGetAt( rule.roles, x ) eq author.getRole().getRole() ){
						isAllowed = true;
						break;
					}
				}
			}

			// Check if the rule requires permissions
			if( len( rule.permissions ) ){
				for(var y=1; y lte listLen( rule.permissions ); y++){
					if( author.checkPermission( listGetAt( rule.permissions, y ) ) ){
						isAllowed = true;
						break;
					}
				}
			}

			// Check for empty rules and perms
			if( !len( rule.roles ) AND !len( rule.permissions ) ){
				isAllowed = true;
			}
		}

		// Check Messages
		if( !isAllowed AND structKeyExists( rule, "message" ) AND len( rule.message) ){
			controller.getWireBox().getInstance( "messagebox@cbmessagebox" ).setMessage(
				type 	= ( structKeyExists( rule, "messageType" ) && len( rule.messageType ) ? rule.messageType : 'info' ),
				message = rule.message
			);
		}

		return isAllowed;
	}

	/**
	* Get an author from session, or returns a new empty author entity
	*/
	Author function getAuthorSession(){

		// Check if valid user id in session
		var authorID = val( cacheStorage.getVar( "loggedInAuthorID", "" ) );

		// If that fails, check for a cookie
		if( !authorID ) {
			authorID = getKeepMeLoggedIn();
		}

		// If we found an authorID, load it up
		if( authorID ){
			// try to get it with that ID
			var author = authorService.findWhere( { authorID=authorID, isActive=true } );
			// If user found?
			if( NOT isNull( author ) ){
				author.setLoggedIn( true );
				return author;
			}
		}

		// return new author, not found or not valid
		return authorService.new();
	}

	/**
	* Set a new author in session
	* @author The author to store
	*
	* @return SecurityService
	*/
	ISecurityService function setAuthorSession( required Author author ){
		cacheStorage.setVar( "loggedInAuthorID", author.getAuthorID() );
		return this;
	}

	/**
	* Delete author session
	*
	* @return SecurityService
	*/
	ISecurityService function logout(){
		cacheStorage.clearAll();
		cookieStorage.deleteVar( name="contentbox_keep_logged_in" );

		return this;
	}

	/**
	* Authenticate an author via ContentBox credentials.
	* This method returns a structure containing an indicator if the authentication was valid (`isAuthenticated` and
	* The `author` object which it represents.
	*
	* @username The username to validate
	* @password The password to validate
	*
	* @return struct:{ isAuthenticated:boolean, author:Author }
	*/
	struct function authenticate( required username, required password ){
		var results = { isAuthenticated = false, author = authorService.new() };

		// Find username
		var oAuthor = authorService.findWhere( {
			username 	= arguments.username,
			isActive 	= true,
			isDeleted 	= false
		} );

		// Verify if author found
		if( isNull( oAuthor ) ){
			// return not authenticated
			return results;
		}

		// Determine password type
		var isBcrypt = ( findNoCase( "$", oAuthor.getPassword() ) ? true : false );
		// Hash password according to algorithm
		var isSamePassword = false;
		if( isBcrypt ){
			try{
				isSamePassword = variables.bCrypt.checkPassword( arguments.password, oAuthor.getPassword() );
			} catch( "java.lang.IllegalArgumentException" e){
				// Usually means the value is not bcrypt.
				isSamePassword = false;
			}
		} else {
			// Legacy hash compare
			isSamePassword = ( compareNoCase( hash( arguments.password, "SHA-256" ), oAuthor.getPassword() ) eq 0 ? true : false );
		}

		//check if found and return verification
		if( isSamePassword ){
			// Do we update the password algorithm?
			if( !isBcrypt ){
				oAuthor.setPassword( encryptString( arguments.password ) );
			}
			// Set last login date
			updateAuthorLoginTimestamp( oAuthor );

			// User authenticated, mark and return
			results.isAuthenticated = true;
			results.author = oAuthor;
		}

		return results;
	}

	/**
	* Leverages bcrypt to encrypt a string
	* @string The string to bcrypt
	*/
	string function encryptString( required string ){
		return bCrypt.hashPassword( arguments.string );
	}

	/**
	 * This function will store a reset token in hash for the user to pickup on password resets
	 *
	 * @author The author to create the reset token for.
	 */
	string function generateResetToken( required Author author ){
		// Store Security Token For X minutes
		var token = hash( arguments.author.getEmail() & arguments.author.getAuthorID() & now() );
		cache.set(
			"reset-token-#cgi.http_host#-#token#",
			arguments.author.getAuthorID(),
			RESET_TOKEN_TIMEOUT,
			RESET_TOKEN_TIMEOUT
		);
		return token;
	}

	/**
	* Sends a new author their reminder to reset their password and log in to their account
	*
	* @author The author to send the reminder to
	*
	* @return error:boolean,errorArray
	*/
	struct function sendNewAuthorReminder( required Author author ){
		// Generate security token
		var token = generateResetToken( arguments.author );

		// get settings
		var settings = settingService.getAllSettings( asStruct=true );

		// get mail payload
		var bodyTokens = {
			name 		= arguments.author.getName(),
			email 		= arguments.author.getEmail(),
			username 	= arguments.author.getUsername(),
			linkTimeout = RESET_TOKEN_TIMEOUT,
			linkToken 	= CBHelper.linkAdmin( event="security.verifyReset", ssl=settings.cb_admin_ssl ) & "?token=#token#",
			resetLink 	= CBHelper.linkAdmin( event="security.lostPassword", ssl=settings.cb_admin_ssl ),
			siteName 	= settings.cb_site_name,
			issuedBy 	= "",
			issuedEmail	= ""
		};

		// Build email out
		var mail = mailservice.newMail(
			to			= arguments.author.getEmail(),
			from		= settings.cb_site_outgoingEmail,
			subject		= "#settings.cb_site_name# Account was created for you",
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
					view 	= "/contentbox/email_templates/author_welcome",
					layout 	= "/contentbox/email_templates/layouts/email"
				)
		);

		// send it out
		return mailService.send( mail );
	}

	/**
	* Send password reminder email, this verifies that the email is valid and they must click on the token
	* link in order to reset their password.
	* @author 		The author to send the reminder to
	* @adminIssued 	Was this reset issued by a user or an admin
	* @issuer 		The admin that issued the reset
	*
	* @return The mailing results of the password reminder: struct.
	*/
	struct function sendPasswordReminder(
		required Author author,
		boolean adminIssued=false,
		Author issuer
	){
		// Generate security token
		var token = generateResetToken( arguments.author );

		// get settings
		var settings = settingService.getAllSettings( asStruct=true );

		// get mail payload
		var bodyTokens = {
			name 		= arguments.author.getName(),
			ip 			= settingService.getRealIP(),
			linkTimeout = RESET_TOKEN_TIMEOUT,
			siteName 	= settings.cb_site_name,
			linkToken 	= CBHelper.linkAdmin( event="security.verifyReset", ssl=settings.cb_admin_ssl ) & "?token=#token#",
			issuedBy 	= "",
			issuedEmail	= ""
		};

		// Check if an issuer was passed
		if( !isNull( arguments.issuer ) ){
			bodyTokens.issuedBy 	= arguments.issuer.getName();
			bodyTokens.issuedEmail 	= arguments.issuer.getEmail();
		}

		// Build email out
		var mail = mailservice.newMail(
			to			= arguments.author.getEmail(),
			from		= settings.cb_site_outgoingEmail,
			subject		= "#settings.cb_site_name# Password Reset Verification",
			bodyTokens	= bodyTokens,
			type		= "html",
			server		= settings.cb_site_mail_server,
			username	= settings.cb_site_mail_username,
			password	= settings.cb_site_mail_password,
			port		= settings.cb_site_mail_smtp,
			useTLS		= settings.cb_site_mail_tls,
			useSSL		= settings.cb_site_mail_ssl
		);

		// Decide template depending if issued by user or admin
		var emailTemplate = "password_verification";
		if( arguments.adminIssued ){
			emailTemplate &= "_admin";
		}

		mail.setBody(
			renderer.get()
				.renderLayout(
					view 	= "/contentbox/email_templates/#emailTemplate#",
					layout 	= "/contentbox/email_templates/layouts/email"
				)
		);

		// send it out
		return mailService.send( mail );
	}

	/**
	 * This function validates an incoming pw reset token to figure out their user.
	 * The token is not removed just yet. It will be removed once the password has been reset.
	 * @token The security token
	 *
	 * @returns {error, author}
	 */
	struct function validateResetToken( required token ){
		var results = { error = false, author = "" };
		var cacheKey = "reset-token-#cgi.http_host#-#arguments.token#";
		var authorID = cache.get( cacheKey );

		// If token not found, don't reset and return back
		if( isNull( authorID ) ){
			results.error = true;
			return results;
		};

		// Verify the author of the token
		results.author = authorService.get( authorID );
		if( isNull( results.author ) ){
			results.error = true;
			return results;
		};

		return results;
	}

	/**
	* Resets a user's password.
	* @token 	Security token
	* @author 	The author you are reseting the password for
	* @password The password you have chosen
	*
	* @Returns {error:boolean, messages:string}
	*/
	struct function resetUserPassword( required token, required Author author, required password ){
		var results = { error = false, messages = "" };
		var cacheKey = "reset-token-#cgi.http_host#-#arguments.token#";
		var authorID = cache.get( cacheKey );

		// If token not found, don't reset and return back
		if( isNull( authorID ) ){
			results.error 		= true;
			results.messages 	= "Token does not exist or has expired";
			return results;
		};

		// Verify the author of the token
		if( arguments.author.getAuthorID() neq authorID ){
			results.error 		= true;
			results.messages 	= "Author reset token mismatch";
			return results;
		};

		// Remove token now that we have the data and it has been validated
		cache.clear( cacheKey );

		// get settings
		var settings = settingService.getAllSettings( asStruct=true );

		// set it in the user and save reset password
		arguments.author.setPassword( arguments.password );
		arguments.author.setIsPasswordReset( false );
		authorService.saveAuthor( author=arguments.author, passwordChange=true );

		// get mail payload
		var bodyTokens = {
			name		= arguments.author.getName(),
			ip 			= settingService.getRealIP(),
			linkLogin 	= CBHelper.linkAdminLogin( ssl=settings.cb_admin_ssl ),
			siteName 	= settings.cb_site_name,
			adminEmail 	= settings.cb_site_email
		};
		var mail = mailservice.newMail(
			to			= arguments.author.getEmail(),
			from		= settings.cb_site_outgoingEmail,
			subject		= "#settings.cb_site_name# Password Reset Completed",
			bodyTokens	= bodyTokens,
			type		= "html",
			server		= settings.cb_site_mail_server,
			username	= settings.cb_site_mail_username,
			password	= settings.cb_site_mail_password,
			port		= settings.cb_site_mail_smtp,
			useTLS		= settings.cb_site_mail_tls,
			useSSL		= settings.cb_site_mail_ssl
		);
		//,body=renderer.get().renderExternalView(view="/contentbox/email_templates/password_reminder" )
		mail.setBody(
			renderer.get()
				.renderLayout(
					view 	= "/contentbox/email_templates/password_reset",
					layout 	= "/contentbox/email_templates/layouts/email"
				)
		);
		// send it out
		mailService.send( mail );

		return results;
	}

	/**
	* Check to authorize a user to view a content entry or page
	* @content The content object
	* @password The password to check
	*/
	boolean function authorizeContent( required content, required password ){
		// Validate Password
		if( compare( arguments.content.getPasswordProtection(), arguments.password ) eq 0 ){
			// Set simple validation
			cacheStorage.setVar( "protection-#hash(arguments.content.getSlug())#",  getContentProtectedHash( arguments.content ) );
			return true;
		}

		return false;
	}

	/**
	* Checks Whether a content entry or page is protected and user has credentials for it
	* @content The content object to check
	*/
	boolean function isContentViewable( required content ){
		var protectedHash = cacheStorage.getVar( "protection-#hash(arguments.content.getSlug())#","" );
		//check hash against validated content
		if( compare( protectedHash, getContentProtectedHash( arguments.content ) )  EQ 0 ){
			return true;
		}
		return false;
	}

	/**
	* Get password content protected salt
	* @content The content object
	*/
	private string function getContentProtectedHash( required content ){
		return hash( arguments.content.getSlug() & arguments.content.getPasswordProtection(), "SHA-256" );
	}

	/**
	* Get remember me cookie
	*/
	any function getRememberMe(){
		var cookieValue = cookieStorage.getVar( name="contentbox_remember_me", default="" );

		try{
			return decryptIt(  cookieValue );
		} catch( Any e ){
			// Errors on decryption
			log.error( "Error decrypting remember me key: #e.message# #e.detail#", cookieValue );
			cookieStorage.deleteVar( name="contentbox_remember_me" );
			return "";
		}
	}


	/**
	* Get keep me logged in cookie
	*/
	any function getKeepMeLoggedIn(){
		var cookieValue = cookieStorage.getVar( name="contentbox_keep_logged_in", default="" );

		try{
			// Decrypted value should be a number representing the authorID
			return val( decryptIt(  cookieValue ) );
		} catch( Any e ){
			// Errors on decryption
			log.error( "Error decrypting Keep Me Logged in key: #e.message# #e.detail#", cookieValue );
			cookieStorage.deleteVar( name="contentbox_keep_logged_in" );
			return 0;
		}
	}


	/**
	* Set remember me cookie
	* @username The username to store
	* @days The days to store
	*/
	ISecurityService function setRememberMe( required username, required numeric days=0 ){

		// If the user now only wants to be remembered for this session, remove any existing cookies.
		if( !arguments.days ) {
			cookieStorage.deleteVar( name="contentbox_remember_me" );
			cookieStorage.deleteVar( name="contentbox_keep_logged_in" );
			return this;
		}

		// Save the username to pre-populate the login field after their login expires for up to a year.
		cookieStorage.setVar( name="contentbox_remember_me", value=encryptIt( arguments.username ), expires=365 );

		// Look up the user ID and store for the duration specified
		var author = authorService.findWhere( { username=arguments.username, isActive=true } );
		if( !isNull( author ) ) {
			// The user will be auto-logged in as long as this cookie exists
			cookieStorage.setVar( name="contentbox_keep_logged_in", value=encryptIt( author.getAuthorID() ), expires=arguments.days );
		}

		return this;
	}

	/**
	* ContentBox encryption
	* @encValue value to encrypt
	*/
	string function encryptIt( required encValue ){
		// if empty just return it
		if( !len( arguments.encValue ) ){ return arguments.encValue; }
		return encrypt( arguments.encValue, getEncryptionKey() , "BLOWFISH", "HEX" );
	}

	/**
	* ContentBox Decryption
	* @decValue value to decrypt
	*/
	string function decryptIt( required decValue ){
		if( !len( arguments.decValue) ){ return arguments.decValue; }
		return decrypt( arguments.decValue, getEncryptionKey(), "BLOWFISH", "HEX" );
	}

	/**
	* Verifies we have a salt in our installation
	* if not, it will generate a new cb_enc_key
	*/
	string function getEncryptionKey(){

		// Is the encryption key loaded?
		if( len( variables.encryptionKey ) ){
			return variables.encryptionKey;
		}

		// Verify we have one in the installation, else generate one
		var oSetting = settingService.findWhere( { name = "cb_enc_key" } );

		// if no key, then create it for this ContentBox installation
		if( isNull( oSetting ) ){
			oSetting = settingService.new( {
				name = "cb_enc_key",
				value = generateSecretKey( "BLOWFISH" )
			} );
			settingService.save( entity=oSetting );
			log.info( "Registered new cookie encryption key" );
		}

		// Seed it locally, so we do not ask the DB again
		variables.encryptionKey = oSetting.getValue();

		// Return it.
		return oSetting.getValue();
	}
}
