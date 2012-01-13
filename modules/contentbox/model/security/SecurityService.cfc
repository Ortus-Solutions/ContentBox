/**
* Our contentbox security service
*/
component implements="ISecurityService" singleton{

	// Dependencies
	property name="authorService" 	inject="id:authorService@cb";
	property name="settingService"	inject="id:settingService@cb";
	property name="sessionStorage" 	inject="coldbox:plugin:SessionStorage";
	property name="mailService"		inject="coldbox:plugin:MailService";
	property name="renderer"		inject="coldbox:plugin:Renderer";
	property name="CBHelper"		inject="id:CBHelper@cb";
	
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
	boolean function userValidator(required struct rule, messagebox, controller){
		var isAllowed 	= false;
		var author 		= getAuthorSession();
		
		// First check if user has been authenticated.
		if( author.isLoaded() AND author.isLoggedIn() ){
			isAllowed = true;
		}
		
		return isAllowed;
	}
	
	/**
	* Get an author from session, or returns a new empty author entity
	*/
	Author function getAuthorSession(){
		
		// Check if valid user id in session?
		if( sessionStorage.exists("loggedInAuthorID") ){
			// try to get it with that ID
			var author = authorService.findWhere({authorID=sessionStorage.getVar("loggedInAuthorID"),isActive=true});
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
		sessionStorage.setVar("loggedInAuthorID", author.getAuthorID() );
		return this;
	} 

	/**
	* Delete author session
	*/
	ISecurityService function logout(){
		sessionStorage.clearAll();
		return this;
	}

	/**
	* Verify if an author is valid
	*/
	boolean function authenticate(required username, required password){
		// hash password
		arguments.password = hash( arguments.password, authorService.getHashType() );
		var author = authorService.findWhere({username=arguments.username,password=arguments.password,isActive=true});
		
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
	* Send password reminder
	*/
	ISecurityService function sendPasswordReminder(required Author author){
		// generate temporary password
		var genPassword = hash( arguments.author.getEmail() & arguments.author.getAuthorID() & now() );
		// get settings
		var settings = settingService.getAllSettings(asStruct=true);
		
		// set it in the user and save it
		author.setPassword( genPassword );
		authorService.saveAuthor(author=author,passwordChange=true);
		
		// get mail payload
		var bodyTokens = {
			genPassword=genPassword,
			name=arguments.author.getName(),
			linkLogin = CBHelper.linkAdminLogin()
		};
		var mail = mailservice.newMail(to=arguments.author.getEmail(),
									   from=settings.cb_site_outgoingEmail,
									   subject="#settings.cb_site_name# Password Reset Issued",
									   bodyTokens=bodyTokens);
		// generate content for email from template
		mail.setBody( renderer.renderView(view="email_templates/password_reminder",module="contentbox") );
		// send it out
		mailService.send( mail );
		
		return this;
	}
	
	/**
	* Check to authorize a user to view a content entry or page
	*/
	boolean function authorizeContent(required content, required password){
		// Validate Password
		if( compare(arguments.content.getPasswordProtection(),arguments.password) eq 0 ){
			// Set simple validation
			sessionStorage.setVar("protection-#hash(arguments.content.getSlug())#",  getContentProtectedHash( arguments.content ) );
			return true;
		}
		
		return false;
	}
	
	/**
	* Checks Whether a content entry or page is protected and user has credentials for it
	*/
	boolean function isContentViewable(required content){
		var protectedHash = sessionStorage.getVar("protection-#hash(arguments.content.getSlug())#","");
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
		return hash(arguments.content.getSlug() & arguments.content.getPasswordProtection(), "SHA-256");
	}
}
