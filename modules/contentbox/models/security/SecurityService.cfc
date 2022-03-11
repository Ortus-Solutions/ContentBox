/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Our contentbox security service must match our interface: ISecurityService
 */
component singleton {

	// Dependencies
	property name="authorService" inject="authorService@contentbox";
	property name="settingService" inject="settingService@contentbox";
	property name="siteService" inject="siteService@contentbox";
	property name="cacheStorage" inject="cacheStorage@cbStorages";
	property name="cookieStorage" inject="cookieStorage@cbStorages";
	property name="requestStorage" inject="RequestStorage@cbstorages";
	property name="mailService" inject="mailService@cbmailservices";
	property name="renderer" inject="coldbox:renderer";
	property name="CBHelper" inject="CBHelper@contentbox";
	property name="log" inject="logbox:logger:{this}";
	property name="cache" inject="cachebox:template";
	property name="bCrypt" inject="BCrypt@BCrypt";
	property name="cbCSRF" inject="@cbcsrf";

	// Properties
	property name="encryptionKey";

	// Static key to identify an author in a request: more for api interaction than web.
	variables.AUTHOR_KEY = "contentbox_author";

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
	Author function updateAuthorLoginTimestamp( required author ){
		arguments.author.setLastLogin( now() );
		variables.authorService.save( arguments.author );
		return arguments.author;
	}

	/**
	 * Alias to getAuthorSession() created to satisfy JWT Service
	 */
	function getUser(){
		return this.getAuthorSession();
	}

	/**
	 * Tries to get the currently logged in user by using our lookup algorithm:
	 *
	 * - Look in request storage
	 * - Look in cache
	 * - Look in remember me cookie
	 * - Tough look, you are an invalid user, return an unauthenticated user
	 *
	 * @return Logged in or new author object
	 */
	Author function getAuthorSession(){
		// Check if valid author id in session or request respectively
		var oAuthor = variables.requestStorage.get( variables.AUTHOR_KEY, variables.authorService.new() );
		if ( oAuthor.isLoggedIn() ) {
			return oAuthor;
		}

		// Verify we have in secondary storage
		var authorID = variables.cacheStorage.get( "loggedInAuthorID", "" );
		// Check remember me inflatable cookie
		if ( !len( authorID ) ) {
			authorID = getKeepMeLoggedIn();
		}

		// If we found an authorID, load it up and check it
		if ( len( authorID ) ) {
			// try to get it with that ID
			var author = variables.authorService.findWhere( { authorID : authorID, isActive : true, isDeleted : false } );
			// If user found? Inflate them back
			if ( !isNull( author ) ) {
				return login( author );
			}
		}

		// return unathenticated user
		return oAuthor;
	}

	/**
	 * Verifies if a user is logged in or not. Required for JWT Services
	 */
	boolean function isLoggedIn(){
		return this.getAuthorSession().isLoggedIn();
	}

	/**
	 * Logs an authenticated author into the system. Required for JWT services
	 *
	 * @author The author to log in
	 */
	Author function login( required author ){
		// Mark as logged in
		arguments.author.setLoggedIn( true );
		// Store for the duration of the request, API mode
		variables.requestStorage.set( variables.AUTHOR_KEY, arguments.author );
		// Store on the long-lived cache for HTML mode
		variables.cacheStorage.set( "loggedInAuthorID", arguments.author.getAuthorID() );
		return arguments.author;
	}

	/**
	 * Delete an author session wether web or api based: Required for JWT services
	 *
	 * @return SecurityService
	 */
	SecurityService function logout(){
		variables.requestStorage.delete( variables.AUTHOR_KEY );
		variables.cacheStorage.clearAll();
		variables.cookieStorage.delete( "contentbox_keep_logged_in" );
		variables.cbCSRF.rotate();

		return this;
	}

	/**
	 * Authenticate an author via ContentBox credentials. If the user is not valid an InvalidCredentials is thrown. Required for JWT services
	 *
	 * The usage of the LogThemIn boolean flag is essential for two-factor authentication, where a user is authenticated
	 * but not yet validated by a two-factor mechanism.  Thus, the default is to ONLY authenticate but not log them in yet.
	 *
	 * For our RESTFul API, we can do an authenticate and login at the same time.
	 *
	 * @username  The username to validate
	 * @password  The password to validate
	 * @logThemIn If true, we will log them in automatically, else it will be the caller's job to do so via the `login()` method.
	 *
	 * @return User : The logged in user object
	 *
	 * @throws InvalidCredentials
	 */
	Author function authenticate(
		required username,
		required password,
		boolean logThemIn = false
	){
		// Find them
		try {
			var oAuthor = variables.authorService.retrieveUserByUsername( arguments.username );
		} catch ( EntityNotFound e ) {
			variables.log.warn(
				"Invalid username authentication from #getRealIP()# for username: #arguments.username#",
				getHTTPRequestData( false )
			);
			throw( type = "InvalidCredentials", message = "Incorrect Credentials Entered" );
		}

		// Validate password using bcrypt
		try {
			var isSamePassword = variables.bcrypt.checkPassword( arguments.password, oAuthor.getPassword() );
		} catch ( any e ) {
			var isSamePassword = false;
		}

		// Verify Password
		if ( !isSamePassword ) {
			variables.log.warn(
				"Invalid password authentication from #getRealIP()# for username: #arguments.username#",
				getHTTPRequestData( false )
			);
			throw( type = "InvalidCredentials", message = "Incorrect Credentials Entered" );
		}

		// Set last login date
		updateAuthorLoginTimestamp( oAuthor );

		// Verify if we need to automatically log them in, usually from a rest call
		if ( arguments.logThemIn ) {
			this.login( oAuthor );
		}

		return oAuthor;
	}

	/**
	 * Leverages bcrypt to do a one way encrypt of a string using our salts
	 *
	 * @string The string to bcrypt
	 */
	string function encryptString( required string ){
		return variables.bCrypt.hashPassword( arguments.string );
	}

	/**
	 * This function will store a reset token in hash for the user to pickup on password resets
	 *
	 * @author The author to create the reset token for.
	 */
	string function generateResetToken( required Author author ){
		var tokenTimeout = variables.settingService.getSetting( "cb_security_password_reset_expiration" );
		// Store Security Token For X minutes
		var token        = hash( arguments.author.getEmail() & arguments.author.getAuthorID() & now() );
		cache.set(
			"reset-token-#token#",
			arguments.author.getAuthorID(),
			tokenTimeout,
			tokenTimeout
		);
		return token;
	}

	/**
	 * Send password reminder email, this verifies that the email is valid and they must click on the token
	 * link in order to reset their password.
	 *
	 * @author      The author to send the reminder to
	 * @adminIssued Was this reset issued by a user or an admin
	 * @issuer      The admin that issued the reset
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
			name        : arguments.author.getFullName(),
			ip          : getRealIP(),
			linkTimeout : settings.cb_security_password_reset_expiration,
			siteName    : defaultSite.getName(),
			linkToken   : CBHelper.linkAdmin( event = "security.verifyReset", ssl = settings.cb_admin_ssl ) & "?token=#token#",
			issuedBy    : "",
			issuedEmail : ""
		};

		// Check if an issuer was passed
		if ( !isNull( arguments.issuer ) ) {
			bodyTokens.issuedBy    = arguments.issuer.getFullName();
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
	 *
	 * @token The security token
	 *
	 * @return {error, author}
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
		results.author = variables.authorService.get( authorID );
		if ( isNull( results.author ) ) {
			results.error = true;
			return results;
		};

		return results;
	}

	/**
	 * Resets a user's password.
	 *
	 * @token    Security token
	 * @author   The author you are reseting the password for
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
		variables.authorService.save( author = arguments.author, passwordChange = true );

		// get mail payload
		var bodyTokens = {
			name       : arguments.author.getFullName(),
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
	 *
	 * @content  The content object
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
	 *
	 * @content The content object to check
	 */
	boolean function isContentViewable( required content ){
		var protectedHash = cacheStorage.get( "protection-#hash( arguments.content.getSlug() )#", "" );
		// check hash against validated content
		if ( compare( protectedHash, getContentProtectedHash( arguments.content ) ) EQ 0 ) {
			return true;
		}
		return false;
	}

	/**
	 * Get password content protected salt
	 *
	 * @content The content object
	 */
	private string function getContentProtectedHash( required content ){
		return hash( arguments.content.getSlug() & arguments.content.getPasswordProtection(), "SHA-256" );
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
			return decryptIt( cookieValue );
		} catch ( Any e ) {
			// Errors on decryption
			log.error( "Error decrypting Keep Me Logged in key: #e.message# #e.detail#", cookieValue );
			cookieStorage.delete( "contentbox_keep_logged_in" );
			return "";
		}
	}

	/**
	 * Set remember me cookie
	 *
	 * @username The username to store
	 * @days     The days to store
	 */
	SecurityService function setRememberMe( required username, required numeric days = 0 ){
		// If the user now only wants to be remembered for this session, remove any existing cookies.
		if ( !arguments.days ) {
			variables.cookieStorage.delete( "contentbox_remember_me" );
			variables.cookieStorage.delete( "contentbox_keep_logged_in" );
			return this;
		}

		// Save the username to pre-populate the login field after their login expires for up to a year.
		variables.cookieStorage.set(
			name    = "contentbox_remember_me",
			value   = encryptIt( arguments.username ),
			expires = 365
		);

		// Look up the user ID and store for the duration specified
		var author = variables.authorService.findWhere( {
			username  : arguments.username,
			isActive  : true,
			isDeleted : false
		} );
		if ( !isNull( author ) ) {
			// The user will be auto-logged in as long as this cookie exists
			variables.cookieStorage.set(
				name    = "contentbox_keep_logged_in",
				value   = encryptIt( author.getAuthorID() ),
				expires = arguments.days
			);
		}

		return this;
	}

	/**
	 * ContentBox encryption
	 *
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
	 *
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
		var headers = getHTTPRequestData( false ).headers;

		// When going through a proxy, the IP can be a delimtied list, thus we take the last one in the list

		if ( structKeyExists( headers, "x-cluster-client-ip" ) ) {
			return trim( listLast( headers[ "x-cluster-client-ip" ] ) );
		}
		if ( structKeyExists( headers, "X-Forwarded-For" ) ) {
			return trim( listFirst( headers[ "X-Forwarded-For" ] ) );
		}

		return len( cgi.remote_addr ) ? trim( listFirst( cgi.remote_addr ) ) : "127.0.0.1";
	}

}
