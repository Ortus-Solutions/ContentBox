/**
* Manage authors
*/
component extends="baseHandler"{

	// Dependencies
	property name="authorService"		inject="id:authorService@cb";
	property name="entryService"		inject="id:entryService@cb";
	
	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab control
		prc.tabAuthors = true;
	}
	
	// index
	function index(event,rc,prc){
		// paging
		event.paramValue("page",1);
		
		// prepare paging plugin
		rc.pagingPlugin = getMyPlugin(plugin="Paging",module="contentbox");
		rc.paging 		= rc.pagingPlugin.getBoundaries();
		rc.pagingLink 	= event.buildLink('#prc.xehAuthors#.page.@page@');
		
		// exit Handlers
		rc.xehAuthorRemove 	= "#prc.cbAdminEntryPoint#.authors.remove";
		prc.xehAuthorsearch 	= "#prc.cbAdminEntryPoint#.authors";
		
		// Get all authors or search
		if( len(event.getValue("searchAuthor","")) ){
			rc.authors = authorService.search( rc.searchAuthor );
			rc.authorCount = arrayLen(rc.authors);
		}
		else{
			rc.authors		= authorService.list(sortOrder="lastName desc",asQuery=false,offset=rc.paging.startRow-1,max=prc.cbSettings.cb_paging_maxrows);
			rc.authorCount 	= authorService.count();
		}
		
		// View all tab
		prc.tabAuthors_viewAll = true;
		
		// View
		event.setView("authors/index");
	}

	// user editor
	function editor(event,rc,prc){
		// exit handlers
		prc.xehAuthorsave 			= "#prc.cbAdminEntryPoint#.authors.save";
		prc.xehAuthorChangePassword = "#prc.cbAdminEntryPoint#.authors.passwordChange";
		
		// get new or persisted author
		prc.author  = authorService.get( event.getValue("authorID",0) );
		// viewlets
		prc.entryViewlet = "";
		prc.pageViewlet  = "";
		if( prc.author.isLoaded() ){
			var args = {authorID=rc.authorID};
			prc.entryViewlet = runEvent(event="contentbox-admin:entries.pager",eventArguments=args);
			prc.pageViewlet  = runEvent(event="contentbox-admin:pages.pager",eventArguments=args);
		}
		
		// Editor
		prc.tabAuthors_editor = true;
		
		// view
		event.setView("authors/editor");
	}	

	// save user
	function save(event,rc,prc){
		
		// get and populate author
		var oAuthor	= populateModel( authorService.get(id=rc.authorID) );
    	// announce event
		announceInterception("cbadmin_preAuthorSave",{author=oAuthor,authorID=rc.authorID});
		// save Author
		authorService.saveAuthor( oAuthor );
		// announce event
		announceInterception("cbadmin_postAuthorSave",{author=oAuthor});
		// message
		getPlugin("MessageBox").setMessage("info","Author saved!");
		// relocate
		setNextEvent(prc.xehAuthors);
	}
	
	// change passord
	function passwordChange(event,rc,prc){
		var oAuthor = authorService.get(id=rc.authorID);
		
		// validate passwords
		if( compareNoCase(rc.password,rc.password_confirm) EQ 0){
			// set new password
			oAuthor.setPassword( rc.password );
			authorService.saveAuthor(author=oAuthor,passwordChange=true);
			// announce event
			announceInterception("cbadmin_onAuthorPasswordChange",{author=oAuthor,password=rc.password});
			// message
			getPlugin("MessageBox").info("Password Updated!");
		}
		else{
			// message
			getPlugin("MessageBox").error("Passwords do not match, please try again!");
		}
		
		// relocate
		setNextEvent(event=prc.xehAuthorEditor,queryString="authorID=#rc.authorID#");
	}
	
	// remove user
	function remove(event,rc,prc){
		var oAuthor	= authorService.get( rc.authorID );
    	
		if( isNull(oAuthor) ){
			getPlugin("MessageBox").setMessage("warning","Invalid Author detected!");
			setNextEvent( prc.xehAuthors );
		}
		// announce event
		announceInterception("cbadmin_preAuthorRemove",{author=oAuthor,authorID=rc.authorID});
		// remove
		authorService.delete( oAuthor );
		// announce event
		announceInterception("cbadmin_postAuthorRemove",{authorID=rc.authorID});
		// message
		getPlugin("MessageBox").setMessage("info","Author Removed!");
		// redirect
		setNextEvent(prc.xehAuthors);
	}
}
