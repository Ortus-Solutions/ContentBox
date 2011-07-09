/**
* Manage authors
*/
component{

	// Dependencies
	property name="authorService"		inject="id:authorService@bb";

	// pre handler
	function preHandler(event,action){
		var rc = event.getCollection();
		// exit Handlers
		rc.xehAuthors 		= "#rc.bbEntryPoint#.admin.authors";
		rc.xehAuthorEditor 	= "#rc.bbEntryPoint#.admin.authors.editor";
		rc.xehAuthorRemove 	= "#rc.bbEntryPoint#.admin.authors.remove";
	}
	
	// index
	function index(event,rc,prc){
		rc.authors = authorService.list(sortOrder="lastName desc",asQuery=false);
		event.setView("admin/authors/index");
	}

	// user editor
	function editor(event,rc,prc){
		// get new or persisted author
		rc.author  = authorService.get( event.getValue("authorID",0) );
		// exit handlers
		rc.xehAuthorSave 	= "#rc.bbEntryPoint#.admin.authors.save";
		// view
		event.setView("admin/authors/editor");
	}	

	// save user
	function save(event,rc,prc){
		var oAuthor	= populateModel( authorService.get(id=rc.authorID) );
    	
		authorService.save( oAuthor );
		
		getPlugin("MessageBox").setMessage("info","Author saved!");
		
		setNextEvent(rc.xehAuthors);
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
