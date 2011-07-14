/**
* Manage authors
*/
component extends="baseHandler"{

	// Dependencies
	property name="authorService"		inject="id:authorService@bb";
	
	// index
	function index(event,rc,prc){
		// exit Handlers
		rc.xehAuthorRemove 	= "#rc.bbEntryPoint#.authors.remove";
		// Get all authors
		rc.authors = authorService.list(sortOrder="lastName desc",asQuery=false);
		// View
		event.setView("authors/index");
	}

	// user editor
	function editor(event,rc,prc){
		// get new or persisted author
		rc.author  = authorService.get( event.getValue("authorID",0) );
		// exit handlers
		rc.xehAuthorSave 			= "#rc.bbEntryPoint#.authors.save";
		rc.xehAuthorChangePassword 	= "#rc.bbEntryPoint#.authors.passwordChange";
		// view
		event.setView("authors/editor");
	}	

	// save user
	function save(event,rc,prc){
		
		// get and populate author
		var oAuthor	= populateModel( authorService.get(id=rc.authorID) );
    	// save Author
		authorService.saveAuthor( oAuthor );
		// message
		getPlugin("MessageBox").setMessage("info","Author saved!");
		// relocate
		setNextEvent(rc.xehAuthors);
	}
	
	// change passord
	function passwordChange(event,rc,prc){
		var oAuthor = authorService.get(id=rc.authorID);
		
		// validate passwords
		if( compareNoCase(rc.password,rc.password_confirm) EQ 0){
			oAuthor.setPassword( rc.password );
			authorService.saveAuthor(author=oAuthor,passwordChange=true);
			// message
			getPlugin("MessageBox").info("Password Updated!");
		}
		else{
			// message
			getPlugin("MessageBox").error("Passwords do not match, please try again!");
		}
		
		// relocate
		setNextEvent(event=rc.xehAuthorEditor,queryString="authorID=#rc.authorID#");
	}
	
	// remove user
	function remove(event,rc,prc){
		var oAuthor	= authorService.get( rc.authorID );
    	
		if( isNull(oAuthor) ){
			getPlugin("MessageBox").setMessage("warning","Invalid Author detected!");
			setNextEvent( rc.xehAuthors );
		}
		
		authorService.delete( oAuthor );
		
		getPlugin("MessageBox").setMessage("info","Author Removed!");
		
		setNextEvent(rc.xehAuthors);
	}
}
