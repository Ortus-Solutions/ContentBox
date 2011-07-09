/**
* Our blogbox security service
*/
component singleton{

	// Dependencies
	property name="authorService" 	inject="id:authorService@bb";
	property name="sessionStorage" 	inject="coldbox:plugin:sessionStorage";
	
	/**
	* Constructor
	*/
	public SecurityService function init(){
		return this;
	}
	
	/**
	* Update an author's last login timestamp
	*/
	void function updateAuthorLoginTimestamp(){
		var author = getAuthorSession();
		author.setLastLogin( now() );
		authorService.save( author );
	}
	
	/**
	* User validator via security interceptor
	*/
	boolean function userValidator(struct rule,any messagebox, any controller){
		var isAllowed 	= false;
		var author 		= getAuthorSession();
		
		// is user found in session?
		if( len( author.getAuthorID() ) ){
			isAllowed = true;
		}
		
		return isAllowed;
	}
	
	/**
	* Get an author from session, or returns a new empty author entity
	*/
	any function getAuthorSession(){
		
		// Check if valid user id in session?
		if( sessionStorage.exists("loggedInAuthorID") ){
			// try to get it with that ID
			var author = authorService.get( sessionStorage.getVar("loggedInAuthorID") );
			if( not isNull(author) ){
				return author;
			}
		}
		
		// return new author, not found or not valid
		return authorService.new();
	}
	
	/**
	* Set a new author in session
	*/
	void function setAuthorSession(any author){
		sessionStorage.setVar("author", author.getAuthorID() );
	} 

	/**
	* Delete author session
	*/
	void function deleteAuthorSession(){
		sessionStorage.clearAll();
	}

	/**
	* Verify if an author is valid
	*/
	boolean function isAuthorVerified(required username, required password){
		
		var author = authorService.findWhere({username=arguments.username,password=arguments.password});
		
		//check if found and return verification
		if( not isNull(author) ){
			setAuthorSession( author );
			return true;
		}
		
		return false;	
	}

}
