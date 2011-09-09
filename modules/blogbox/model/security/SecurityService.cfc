/**
* Our blogbox security service
*/
component singleton{

	// Dependencies
	property name="authorService" 	inject="id:authorService@bb";
	property name="settingService"	inject="id:settingService@bb";
	property name="sessionStorage" 	inject="coldbox:plugin:SessionStorage";
	property name="mailService"		inject="coldbox:plugin:MailService";
	property name="renderer"		inject="coldbox:plugin:Renderer";
	
	/**
	* Constructor
	*/
	public SecurityService function init(){
		return this;
	}
	
	/**
	* Update an author's last login timestamp
	*/
	void function updateAuthorLoginTimestamp(author){
		arguments.author.setLastLogin( now() );
		authorService.save( arguments.author );
	}
	
	/**
	* User validator via security interceptor
	*/
	boolean function userValidator(struct rule,messagebox,controller){
		var isAllowed 	= false;
		var author 		= getAuthorSession();
		
		// is user found in session?
		if( author.isLoaded() AND author.isLoggedIn() ){
			isAllowed = true;
		}
		return isAllowed;
	}
	
	/**
	* Get an author from session, or returns a new empty author entity
	*/
	function getAuthorSession(){
		
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
	void function setAuthorSession(author){
		sessionStorage.setVar("loggedInAuthorID", author.getAuthorID() );
	} 

	/**
	* Delete author session
	*/
	void function logout(){
		sessionStorage.clearAll();
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
	function sendPasswordReminder(author){
		// generate temporary password
		var genPassword = hash( arguments.author.getEmail() & arguments.author.getAuthorID() & now() );
		// get settings
		var settings = settingService.getAllSettings(asStruct=true);
		
		// set it in the user and save it
		author.setPassword( genPassword );
		authorService.saveUser(author=author,passwordChange=true);
		
		// get mail payload
		var bodyTokens = {genPassword=genPassword,name=arguments.author.getName()};
		var mail = mailservice.newMail(to=arguments.author.getEmail(),
									   from=settings.bb_site_outgoingEmail,
									   subject="#settings.bb_site_name# Password Reset Issued",
									   bodyTokens=bodyTokens);
		// generate content for email from template
		mail.setBody( renderer.renderView(view="email_templates/password_reminder",module="blogbox") );
		// send it out
		mailService.send( mail );
	}

}
