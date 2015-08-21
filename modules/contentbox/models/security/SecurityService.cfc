/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Our contentbox security service
*/
component implements="ISecurityService" singleton{

	// Dependencies
	property name="authorService" 	inject="id:authorService@cb";
	property name="settingService"	inject="id:settingService@cb";
	property name="sessionStorage" 	inject="sessionStorage@cbStorages";
	property name="cookieStorage" 	inject="cookieStorage@cbStorages";
	property name="mailService"		inject="mailService@cbmailservices";
	property name="renderer"		inject="provider:ColdBoxRenderer";
	property name="CBHelper"		inject="id:CBHelper@cb";
	property name="log"				inject="logbox:logger:{this}";
	property name="cache"			inject="cachebox:default";
	
	/**
	* Constructor
	*/
	public SecurityService function init(){
		return this;
	}
	
	/**
	* Update an author's last login timestamp
	*/
	ISecurityService function updateAuthorLoginTimestamp(author){
		arguments.author.setLastLogin( now() );
		authorService.save( arguments.author );
		return this;
	}
	
	/**
	* User validator via security interceptor
	*/
	boolean function userValidator(required struct rule,any messagebox,any controller){
		var isAllowed 	= false;
		var author 		= getAuthorSession();
		
		// First check if user has been authenticated.
		if( author.isLoaded() AND author.isLoggedIn() ){
			
			// Check if the rule requires roles
			if( len(rule.roles) ){
				for(var x=1; x lte listLen(rule.roles); x++){
					if( listGetAt(rule.roles,x) eq author.getRole().getRole() ){
						isAllowed = true;
						break;
					}
				}
			}
			
			// Check if the rule requires permissions
			if( len(rule.permissions) ){
				for(var y=1; y lte listLen(rule.permissions); y++){
					if( author.checkPermission( listGetAt(rule.permissions,y) ) ){
						isAllowed = true;
						break;
					}
				}
			}
			
			// Check for empty rules and perms
			if( !len(rule.roles) AND !len(rule.permissions) ){
				isAllowed = true;
			}
		}
		
		return isAllowed;
	}
	
	/**
	* Get an author from session, or returns a new empty author entity
	*/
	Author function getAuthorSession(){
		
		// Check if valid user id in session
		var authorID = val( sessionStorage.getVar( "loggedInAuthorID", "" ) );
		
		// If that fails, check for a cookie
		if( !authorID ) {
			authorID = getKeepMeLoggedIn();
		}	
			
		// If we found an authorID, load it up
		if( authorID ){
			// try to get it with that ID
			var author = authorService.findWhere( { authorID=authorID, isActive=true } );
			// If user found?
			if( NOT isNull(author) ){
				author.setLoggedIn( true );
				return author;
			}
		}
				
		// return new author, not found or not valid
		return authorService.new();
	}
	
	/**
	* Set a new author in session
	*/
	ISecurityService function setAuthorSession(required Author author){
		sessionStorage.setVar( "loggedInAuthorID", author.getAuthorID() );
		return this;
	} 

	/**
	* Delete author session
	*/
	ISecurityService function logout(){
		sessionStorage.clearAll();
		cookieStorage.deleteVar( name="contentbox_keep_logged_in" );
		
		return this;
	}

	/**
	* Verify if an author is valid
	*/
	boolean function authenticate(required username, required password){
		// hash password
		arguments.password = hash( arguments.password, authorService.getHashType() );
		var author = authorService.findWhere( {username=arguments.username,password=arguments.password,isActive=true} );
		
		//check if found and return verification
		if( not isNull(author) ){
			// Set last login date
			updateAuthorLoginTimestamp( author );
			// set them in session
			setAuthorSession( author );
			return true;
		}
		return false;	
	}
	
	/**
	* Send password reminder email
	*/
	ISecurityService function sendPasswordReminder(required Author author){
		// Store Security Token For 15 minutes
		var token = hash( arguments.author.getEmail() & arguments.author.getAuthorID() & now() );
		cache.set( "reset-token-#cgi.http_host#-#token#", arguments.author.getAuthorID(), 15, 15 );
		
		// get settings
		var settings = settingService.getAllSettings(asStruct=true);
		
		// get mail payload
		var bodyTokens = {
			name=arguments.author.getName(),
			linkToken = CBHelper.linkAdmin( event="security.verifyReset", ssl=settings.cb_admin_ssl ) & "?token=#token#"
		};
		var mail = mailservice.newMail(to=arguments.author.getEmail(),
									   from=settings.cb_site_outgoingEmail,
									   subject="#settings.cb_site_name# Password Reset Verification",
									   bodyTokens=bodyTokens,
									   type="html",
									   server=settings.cb_site_mail_server,
									   username=settings.cb_site_mail_username,
									   password=settings.cb_site_mail_password,
									   port=settings.cb_site_mail_smtp,
									   useTLS=settings.cb_site_mail_tls,
									   useSSL=settings.cb_site_mail_ssl);
		//body=renderer.get().renderExternalView(view="/contentbox/email_templates/password_verification" )									   
		mail.setBody( renderer.get().renderLayout( view="/contentbox/email_templates/password_verification", layout="email", module="contentbox-admin" ) );
		// send it out
		mailService.send( mail );
		
		return this;
	}
	
	/**
	* Resets a user's password if the passed in token is valid
	* Returns [error, author]
	*/
	struct function resetUserPassword(required token){
		var results = { error = false, author = "" };
		var cacheKey = "reset-token-#cgi.http_host#-#arguments.token#";
		var authorID = cache.get( cacheKey );

		// If token not found, don't reset and return back
		if( isNull( authorID ) ){ results.error = true; return results; };
		
		// Verify the author of the token
		results.author = authorService.get( authorID );
		if( isNull( results.author ) ){ results.error = true; return results; };
		
		// Remove token now that we have the data.
		cache.clear( cacheKey );
		
		// generate temporary password
		var genPassword = hash( results.author.getEmail() & results.author.getAuthorID() & now() );
		// get settings
		var settings = settingService.getAllSettings(asStruct=true);
		
		// set it in the user and save reset password
		results.author.setPassword( genPassword );
		authorService.saveAuthor( author=results.author, passwordChange=true );
		
		// get mail payload
		var bodyTokens = {
			genPassword=genPassword,
			name=results.author.getName(),
			linkLogin = CBHelper.linkAdminLogin( ssl=settings.cb_admin_ssl )
		};
		var mail = mailservice.newMail(to=results.author.getEmail(),
									   from=settings.cb_site_outgoingEmail,
									   subject="#settings.cb_site_name# Password Reset Issued",
									   bodyTokens=bodyTokens,
									   type="html",
									   server=settings.cb_site_mail_server,
									   username=settings.cb_site_mail_username,
									   password=settings.cb_site_mail_password,
									   port=settings.cb_site_mail_smtp,
									   useTLS=settings.cb_site_mail_tls,
									   useSSL=settings.cb_site_mail_ssl);
		//,body=renderer.get().renderExternalView(view="/contentbox/email_templates/password_reminder" )
		mail.setBody( renderer.get().renderLayout( view="/contentbox/email_templates/password_reminder", layout="email", module="contentbox-admin" ) );
		// send it out
		mailService.send( mail );
		
		return results;
	}
	
	/**
	* Check to authorize a user to view a content entry or page
	*/
	boolean function authorizeContent(required content, required password){
		// Validate Password
		if( compare(arguments.content.getPasswordProtection(),arguments.password) eq 0 ){
			// Set simple validation
			sessionStorage.setVar( "protection-#hash(arguments.content.getSlug())#",  getContentProtectedHash( arguments.content ) );
			return true;
		}
		
		return false;
	}
	
	/**
	* Checks Whether a content entry or page is protected and user has credentials for it
	*/
	boolean function isContentViewable(required content){
		var protectedHash = sessionStorage.getVar( "protection-#hash(arguments.content.getSlug())#","" );
		//check hash against validated content
		if( compare( protectedHash, getContentProtectedHash( arguments.content ) )  EQ 0 ){
			return true;
		}
		return false;
	}
	
	/**
	* Get password content protected salt
	*/
	private function getContentProtectedHash(content){
		return hash(arguments.content.getSlug() & arguments.content.getPasswordProtection(), "SHA-256" );
	}
	
	/**
	* Get remember me cookie
	*/
	any function getRememberMe(){
		var results = "";
		var cookieValue = cookieStorage.getVar(name="contentbox_remember_me", default="" );
		
		try{
			results = decryptIt(  cookieValue );
		}
		catch(Any e){
			// Errors on decryption
			log.error( "Error decrypting remember me key: #e.message# #e.detail#", cookieValue );
			cookieStorage.deleteVar(name="contentbox_remember_me" );
			results = "";
		}
		
		return results;
	}
	
	
	/**
	* Get remember me cookie
	*/
	any function getKeepMeLoggedIn(){
		var results = 0;
		var cookieValue = cookieStorage.getVar(name="contentbox_keep_logged_in", default="" );
		
		try{
			// Decrypted value should be a number representing the authorID
			results = val( decryptIt(  cookieValue ) );
		}
		catch(Any e){
			// Errors on decryption
			log.error( "Error decrypting Keep Me Logged in key: #e.message# #e.detail#", cookieValue );
			cookieStorage.deleteVar(name="contentbox_keep_logged_in" );
			results = 0;
		}
		
		return results;
	}
	
	
	/**
	* Set remember me cookie
	*/
	ISecurityService function setRememberMe(required username, required numeric days=0 ){
				
		// If the user now only wants to be remembered for this session, remove any existing cookies.
		if( !arguments.days ) {
			cookieStorage.deleteVar( name="contentbox_remember_me" );
			cookieStorage.deleteVar( name="contentbox_keep_logged_in" );
			return this;
		}
		
		// Save the username to pre-populate the login field after their login expires for up to a year.
		cookieStorage.setVar(name="contentbox_remember_me", value=encryptIt( arguments.username ), expires=365 );
		
		// Look up the user ID and store for the duration specified
		var author = authorService.findWhere( { username=arguments.username, isActive=true } );
		if( !isNull( author ) ) {
			// The user will be auto-logged in as long as this cookie exists
			cookieStorage.setVar(name="contentbox_keep_logged_in", value=encryptIt( author.getAuthorID() ), expires=arguments.days );			
		}
		
		return this;
	}
	
	// Cookie encryption
	private function encryptIt(required encValue){
		// if empty just return it
		if( !len( arguments.encValue ) ){ return arguments.encValue; }
		return encrypt( arguments.encValue, getEncryptionKey() , "BLOWFISH", "HEX" );
	}
	
	// Cookie decryption
	private function decryptIt(required decValue){
		if( !len( arguments.decValue) ){ return arguments.decValue; }
		return decrypt( arguments.decValue, getEncryptionKey(), "BLOWFISH", "HEX" );
	}
	
	// Get encryption key according to cookie algorithm
	private function getEncryptionKey(){
		var setting = settingService.findWhere( { name = "cb_enc_key" } );
		
		// if no key, then create it for this ContentBox installation
		if( isNull( setting ) ){
			setting = settingService.new();
			setting.setValue( generateSecretKey( "BLOWFISH" ) );
			setting.setName( "cb_enc_key" );
			settingService.save(entity=setting);
			log.info( "Registered new cookie encryption key" );
		}
		
		return setting.getValue();
	}
}
