/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Our contentbox security service must match our interface: ISecurityService
 */
component singleton {

	// Dependencies
	property name="authorService" inject="authorService@cb";
	property name="settingService" inject="settingService@cb";
	property name="siteService" inject="siteService@cb";
	property name="cacheStorage" inject="cacheStorage@cbStorages";
	property name="cookieStorage" inject="cookieStorage@cbStorages";
	property name="mailService" inject="mailService@cbmailservices";
	property name="renderer" inject="coldbox:renderer";
	property name="CBHelper" inject="CBHelper@cb";
	property name="log" inject="logbox:logger:{this}";
	property name="cache" inject="cachebox:template";
	property name="bCrypt" inject="BCrypt@BCrypt";

	// Properties
	property name="encryptionKey";

	/**
	 * Constructor
	 */
	SecurityService function init(){
		variables.encryptionKey = "";
		return this;
	}

	/**
	 * Update an author's last login timestamp
	 *
	 * @author The author object
	 */
	SecurityService function updateAuthorLoginTimestamp( required author ){
		arguments.author.setLastLogin( now() );
		authorService.save( arguments.author );
		return this;
	}

	/**
	 * This function is called once an incoming event matches a security rule.
	 * You will receive the security rule that matched and an instance of the
	 * ColdBox controller.
	 *
	 * You must return a struct with two keys:
	 * - allow:boolean True, user can continue access, false, invalid access actions will ensue
	 * - type:string(authentication|authorization) The type of block that ocurred.  Either an authentication or an authorization issue.
	 * - messages:string Info/debug messages
	 *
	 * @return { allow:boolean, type:authentication|authorization, messages:string }
	 */
	struct function ruleValidator( required rule, required controller ){
		return validateSecurity( rule: arguments.rule, controller: arguments.controller );
	}

	/**
	 * This function is called once access to a handler/action is detected.
	 * You will receive the secured annotation value and an instance of the ColdBox Controller
	 *
	 * You must return a struct with two keys:
	 * - allow:boolean True, user can continue access, false, invalid access actions will ensue
	 * - type:string(authentication|authorization) The type of block that ocurred.  Either an authentication or an authorization issue.
	 * - messages:string Info/debug messages
	 *
	 * @return { allow:boolean, type:authentication|authorization, messages:string }
	 */
	struct function annotationValidator( required securedValue, required controller ){
		return validateSecurity(
			securedValue: arguments.securedValue,
			controller  : arguments.controller
		);
	}

	/**
	 * Validates if a user can access an event. Called via the cbSecurity module.
	 *
	 * @rule The security rule being tested for
	 * @controller The ColdBox controller calling the validation
	 */
	struct function validateSecurity( struct rule, securedValue, any controller ){
		var results = {
			"allow"    : false,
			"type"     : "authentication",
			"messages" : ""
		};
		// Get the currently logged in user, if any
		var author = getAuthorSession();

		// First check if user has been authenticated.
		if ( author.isLoaded() AND author.isLoggedIn() ) {
			// Check if the rule requires roles
			if ( !isNull( arguments.rule ) && len( arguments.rule.roles ) ) {
				for ( var x = 1; x lte listLen( arguments.rule.roles ); x++ ) {
					if ( listGetAt( arguments.rule.roles, x ) eq author.getRole().getRole() ) {
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

			// Check for empty rules and perms
			if ( !len( rule.roles ) AND !len( rule.permissions ) ) {
				results.allow = true;
			}
		}

		// If the rule has a message, then set a messagebox
		if (
			!results.allow &&
			!isNull( arguments.rule ) &&
			structKeyExists( rule, "message" ) &&
			len( rule.message )
		) {
			arguments.controller
				.getWireBox()
				.getInstance( "messagebox@cbmessagebox" )
				.setMessage(
					type: (
						structKeyExists( rule, "messageType" ) && len( rule.messageType ) ? rule.messageType : "info"
					),
					message: rule.message
				);
		}

		return results;
	}

	/**
	 * Get an author from session, or returns a new empty author entity
	 *
	 * @return Logged in or new user object
	 */
	Author function getAuthorSession(){
		// Check if valid user id in session
		var authorID = val( cacheStorage.get( "loggedInAuthorID", "" ) );

		// If that fails, check for a cookie
		if ( !authorID ) {
			authorID = getKeepMeLoggedIn();
		}

		// If we found an authorID, load it up
		if ( authorID ) {
			// try to get it with that ID
			var author = authorService.findWhere( { authorID : authorID, isActive : true } );
			// If user found?
			if ( NOT isNull( author ) ) {
				author.setLoggedIn( true );
				return author;
			}
		}

		// return new author, not found or not valid
		return authorService.new();
	}

	/**
	 * Set a new author in session
	 *
	 * @author The author to login to ContentBox
	 *
	 * @return SecurityService
	 */
	SecurityService function setAuthorSession( required Author author ){
		cacheStorage.set( "loggedInAuthorID", author.getAuthorID() );
		return this;
	}

	/**
	 * Delete an author session
	 *
	 * @return SecurityService
	 */
	SecurityService function logout(){
		cacheStorage.clearAll();
		cookieStorage.delete( "contentbox_keep_logged_in" );

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
		var results = { isAuthenticated : false, author : authorService.new() };

		// Find username
		var oAuthor = authorService.findWhere( {
			username  : arguments.username,
			isActive  : true,
			isDeleted : false
		} );

		// Verify if author found
		if ( isNull( oAuthor ) ) {
			// return not authenticated
			return results;
		}

		// Determine password type
		var isBcrypt       = ( findNoCase( "$", oAuthor.getPassword() ) ? true : false );
		// Hash password according to algorithm
		var isSamePassword = false;
		if ( isBcrypt ) {
			try {
				isSamePassword = variables.bCrypt.checkPassword(
					arguments.password,
					oAuthor.getPassword()
				);
			} catch ( "java.lang.IllegalArgumentException" e ) {
				// Usually means the value is not bcrypt.
				isSamePassword = false;
			}
		} else {
			// Legacy hash compare
			isSamePassword = (
				compareNoCase( hash( arguments.password, "SHA-256" ), oAuthor.getPassword() ) eq 0 ? true : false
			);
		}

		// check if found and return verification
		if ( isSamePassword ) {
			// Do we update the password algorithm?
			if ( !isBcrypt ) {
				oAuthor.setPassword( encryptString( arguments.password ) );
			}
			// Set last login date
			updateAuthorLoginTimestamp( oAuthor );

			// User authenticated, mark and return
			results.isAuthenticated = true;
			results.author          = oAuthor;
		}

		return results;
	}

	/**
	 * Leverages bcrypt to encrypt a string
	 *
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
		var tokenTimeout = variables.settingService.getSetting(
			"cb_security_password_reset_expiration"
		);
		// Store Security Token For X minutes
		var token = hash( arguments.author.getEmail() & arguments.author.getAuthorID() & now() );
		cache.set(
			"reset-token-#token#",
			arguments.author.getAuthorID(),
			tokenTimeout,
			tokenTimeout
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

		// get settings + default site
		var settings    = variables.settingService.getAllSettings();
		var defaultSite = variables.siteService.getDefaultSite();

		// get mail payload
		var bodyTokens = {
			name        : arguments.author.getName(),
			email       : arguments.author.getEmail(),
			username    : arguments.author.getUsername(),
			linkTimeout : settings.cb_security_password_reset_expiration,
			linkToken   : CBHelper.linkAdmin(
				event = "security.verifyReset",
				ssl   = settings.cb_admin_ssl
			) & "?token=#token#",
			resetLink : CBHelper.linkAdmin(
				event = "security.lostPassword",
				ssl   = settings.cb_admin_ssl
			),
			siteName    : defaultSite.getName(),
			issuedBy    : "",
			issuedEmail : ""
		};

		// Build email out
		var mail = mailservice.newMail(
			to         = arguments.author.getEmail(),
			from       = settings.cb_site_outgoingEmail,
			subject    = "#defaultSite.getName()# Account was created for you",
			bodyTokens = bodyTokens,
			type       = "html",
			server     = settings.cb_site_mail_server,
			username   = settings.cb_site_mail_username,
			password   = settings.cb_site_mail_password,
			port       = settings.cb_site_mail_smtp,
			useTLS     = settings.cb_site_mail_tls,
			useSSL     = settings.cb_site_mail_ssl
		);

		mail.setBody(
			renderer.renderLayout(
				view   = "/contentbox/email_templates/author_welcome",
				layout = "/contentbox/email_templates/layouts/email"
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
		boolean adminIssued = false,
		Author issuer
	){
		// Generate security token
		var token = generateResetToken( arguments.author );

		// get settings
		var settings    = variables.settingService.getAllSettings();
		var defaultSite = variables.siteService.getDefaultSite();

		// get mail payload
		var bodyTokens = {
			name        : arguments.author.getName(),
			ip          : getRealIP(),
			linkTimeout : settings.cb_security_password_reset_expiration,
			siteName    : defaultSite.getName(),
			linkToken   : CBHelper.linkAdmin(
				event = "security.verifyReset",
				ssl   = settings.cb_admin_ssl
			) & "?token=#token#",
			issuedBy    : "",
			issuedEmail : ""
		};

		// Check if an issuer was passed
		if ( !isNull( arguments.issuer ) ) {
			bodyTokens.issuedBy    = arguments.issuer.getName();
			bodyTokens.issuedEmail = arguments.issuer.getEmail();
		}

		// Build email out
		var mail = variables.mailservice.newMail(
			to         = arguments.author.getEmail(),
			from       = settings.cb_site_outgoingEmail,
			subject    = "#defaultSite.getName()# Password Reset Verification",
			bodyTokens = bodyTokens,
			type       = "html",
			server     = settings.cb_site_mail_server,
			username   = settings.cb_site_mail_username,
			password   = settings.cb_site_mail_password,
			port       = settings.cb_site_mail_smtp,
			useTLS     = settings.cb_site_mail_tls,
			useSSL     = settings.cb_site_mail_ssl
		);

		// Decide template depending if issued by user or admin
		var emailTemplate = "password_verification";
		if ( arguments.adminIssued ) {
			emailTemplate &= "_admin";
		}

		mail.setBody(
			renderer.renderLayout(
				view   = "/contentbox/email_templates/#emailTemplate#",
				layout = "/contentbox/email_templates/layouts/email"
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
		var results  = { "error" : false, "author" : "" };
		var cacheKey = "reset-token-#arguments.token#";
		var authorID = cache.get( cacheKey );

		// If token not found, don't reset and return back
		if ( isNull( authorID ) ) {
			results.error = true;
			return results;
		};

		// Verify the author of the token
		results.author = authorService.get( authorID );
		if ( isNull( results.author ) ) {
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
	 * @return {error:boolean, messages:string}
	 */
	struct function resetUserPassword(
		required token,
		required Author author,
		required password
	){
		var results  = { "error" : false, "messages" : "" };
		var cacheKey = "reset-token-#arguments.token#";
		var authorID = cache.get( cacheKey );

		// If token not found, don't reset and return back
		if ( isNull( authorID ) ) {
			results.error    = true;
			results.messages = "Token does not exist or has expired";
			return results;
		};

		// Verify the author of the token
		if ( arguments.author.getAuthorID() neq authorID ) {
			results.error    = true;
			results.messages = "Author reset token mismatch";
			return results;
		};

		// Remove token now that we have the data and it has been validated
		cache.clear( cacheKey );

		// get settings
		var settings    = settingService.getAllSettings();
		var defaultSite = variables.siteService.getDefaultSite();

		// set it in the user and save reset password
		arguments.author.setPassword( arguments.password );
		arguments.author.setIsPasswordReset( false );
		authorService.saveAuthor( author = arguments.author, passwordChange = true );

		// get mail payload
		var bodyTokens = {
			name       : arguments.author.getName(),
			ip         : getRealIP(),
			linkLogin  : CBHelper.linkAdminLogin( ssl = settings.cb_admin_ssl ),
			siteName   : defaultSite.getName(),
			adminEmail : settings.cb_site_email
		};
		var mail = mailservice.newMail(
			to         = arguments.author.getEmail(),
			from       = settings.cb_site_outgoingEmail,
			subject    = "#defaultSite.getName()# Password Reset Completed",
			bodyTokens = bodyTokens,
			type       = "html",
			server     = settings.cb_site_mail_server,
			username   = settings.cb_site_mail_username,
			password   = settings.cb_site_mail_password,
			port       = settings.cb_site_mail_smtp,
			useTLS     = settings.cb_site_mail_tls,
			useSSL     = settings.cb_site_mail_ssl
		);
		// ,body=renderer.$get().renderExternalView(view="/contentbox/email_templates/password_reminder" )
		mail.setBody(
			renderer.renderLayout(
				view   = "/contentbox/email_templates/password_reset",
				layout = "/contentbox/email_templates/layouts/email"
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
		if ( compare( arguments.content.getPasswordProtection(), arguments.password ) eq 0 ) {
			// Set simple validation
			cacheStorage.set(
				"protection-#hash( arguments.content.getSlug() )#",
				getContentProtectedHash( arguments.content )
			);
			return true;
		}

		return false;
	}

	/**
	 * Checks Whether a content entry or page is protected and user has credentials for it
	 * @content The content object to check
	 */
	boolean function isContentViewable( required content ){
		var protectedHash = cacheStorage.get(
			"protection-#hash( arguments.content.getSlug() )#",
			""
		);
		// check hash against validated content
		if ( compare( protectedHash, getContentProtectedHash( arguments.content ) ) EQ 0 ) {
			return true;
		}
		return false;
	}

	/**
	 * Get password content protected salt
	 * @content The content object
	 */
	private string function getContentProtectedHash( required content ){
		return hash(
			arguments.content.getSlug() & arguments.content.getPasswordProtection(),
			"SHA-256"
		);
	}

	/**
	 * Get remember me cookie
	 */
	any function getRememberMe(){
		var cookieValue = cookieStorage.get( "contentbox_remember_me", "" );

		try {
			return decryptIt( cookieValue );
		} catch ( Any e ) {
			// Errors on decryption
			log.error( "Error decrypting remember me key: #e.message# #e.detail#", cookieValue );
			cookieStorage.delete( "contentbox_remember_me" );
			return "";
		}
	}


	/**
	 * Get keep me logged in cookie
	 */
	any function getKeepMeLoggedIn(){
		var cookieValue = cookieStorage.get( "contentbox_keep_logged_in", "" );

		try {
			// Decrypted value should be a number representing the authorID
			return val( decryptIt( cookieValue ) );
		} catch ( Any e ) {
			// Errors on decryption
			log.error(
				"Error decrypting Keep Me Logged in key: #e.message# #e.detail#",
				cookieValue
			);
			cookieStorage.delete( "contentbox_keep_logged_in" );
			return 0;
		}
	}

	/**
	 * Set remember me cookie
	 * @username The username to store
	 * @days The days to store
	 */
	SecurityService function setRememberMe( required username, required numeric days = 0 ){
		// If the user now only wants to be remembered for this session, remove any existing cookies.
		if ( !arguments.days ) {
			cookieStorage.delete( "contentbox_remember_me" );
			cookieStorage.delete( "contentbox_keep_logged_in" );
			return this;
		}

		// Save the username to pre-populate the login field after their login expires for up to a year.
		cookieStorage.set(
			name    = "contentbox_remember_me",
			value   = encryptIt( arguments.username ),
			expires = 365
		);

		// Look up the user ID and store for the duration specified
		var author = authorService.findWhere( { username : arguments.username, isActive : true } );
		if ( !isNull( author ) ) {
			// The user will be auto-logged in as long as this cookie exists
			cookieStorage.set(
				name    = "contentbox_keep_logged_in",
				value   = encryptIt( author.getAuthorID() ),
				expires = arguments.days
			);
		}

		return this;
	}

	/**
	 * ContentBox encryption
	 * @encValue value to encrypt
	 */
	string function encryptIt( required encValue ){
		// if empty just return it
		if ( !len( arguments.encValue ) ) {
			return arguments.encValue;
		}
		return encrypt(
			arguments.encValue,
			getEncryptionKey(),
			"BLOWFISH",
			"HEX"
		);
	}

	/**
	 * ContentBox Decryption
	 * @decValue value to decrypt
	 */
	string function decryptIt( required decValue ){
		if ( !len( arguments.decValue ) ) {
			return arguments.decValue;
		}
		return decrypt(
			arguments.decValue,
			getEncryptionKey(),
			"BLOWFISH",
			"HEX"
		);
	}

	/**
	 * Verifies we have a salt in our installation
	 * if not, it will generate a new cb_enc_key
	 */
	string function getEncryptionKey(){
		// Is the encryption key loaded?
		if ( len( variables.encryptionKey ) ) {
			return variables.encryptionKey;
		}

		// Verify we have one in the installation, else generate one
		var oSetting = settingService.findWhere( { name : "cb_enc_key" } );

		// if no key, then create it for this ContentBox installation
		if ( isNull( oSetting ) ) {
			oSetting = settingService.new( {
				name  : "cb_enc_key",
				value : generateSecretKey( "BLOWFISH" )
			} );
			settingService.save( entity = oSetting );
			log.info( "Registered new cookie encryption key" );
		}

		// Seed it locally, so we do not ask the DB again
		variables.encryptionKey = oSetting.getValue();

		// Return it.
		return oSetting.getValue();
	}

	/**
	 * Get Real IP, by looking at clustered, proxy headers and locally.
	 */
	function getRealIP(){
		var headers = getHTTPRequestData().headers;

		// Very balanced headers
		if ( structKeyExists( headers, "x-cluster-client-ip" ) ) {
			return headers[ "x-cluster-client-ip" ];
		}
		if ( structKeyExists( headers, "X-Forwarded-For" ) ) {
			return headers[ "X-Forwarded-For" ];
		}

		return len( CGI.REMOTE_ADDR ) ? trim( listFirst( CGI.REMOTE_ADDR ) ) : "127.0.0.1";
	}

}
