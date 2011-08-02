/**
* Manage authors
*/
component extends="baseHandler"{

	// Dependencies
	property name="authorService"		inject="id:authorService@bb";
	property name="entryService"		inject="id:entryService@bb";
	
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
		rc.pagingPlugin = getMyPlugin(plugin="Paging",module="blogbox");
		rc.paging 		= rc.pagingPlugin.getBoundaries();
		rc.pagingLink 	= event.buildLink('#rc.xehAuthors#.page.@page@');
		
		// exit Handlers
		rc.xehAuthorRemove 	= "#prc.bbEntryPoint#.authors.remove";
		rc.xehAuthorSearch 	= "#prc.bbEntryPoint#.authors";
		
		// Get all authors or search
		if( len(event.getValue("searchAuthor","")) ){
			rc.authors = authorService.search( rc.searchAuthor );
			rc.authorCount = arrayLen(rc.authors);
		}
		else{
			rc.authors		= authorService.list(sortOrder="lastName desc",asQuery=false,offset=rc.paging.startRow-1,max=prc.bbSettings.bb_paging_maxrows);
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
		rc.xehAuthorSave 			= "#prc.bbEntryPoint#.authors.save";
		rc.xehAuthorChangePassword 	= "#prc.bbEntryPoint#.authors.passwordChange";
		rc.xehEntriesPager			= "blogbox-admin:entries.pager";
		
		// get new or persisted author
		rc.author  = authorService.get( event.getValue("authorID",0) );
		// pager Viewlet
		rc.pagerViewlet = "";
		if( rc.author.isLoaded() ){
			rc.pagerViewlet = runEvent(event=rc.xehEntriesPager,eventArguments={authorID=rc.authorID});
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
		announceInterception("bbadmin_preAuthorSave",{author=oAuthor,authorID=rc.authorID});
		// save Author
		authorService.saveAuthor( oAuthor );
		// announce event
		announceInterception("bbadmin_postAuthorSave",{author=oAuthor});
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
			// set new password
			oAuthor.setPassword( rc.password );
			authorService.saveAuthor(author=oAuthor,passwordChange=true);
			// announce event
			announceInterception("bbadmin_onAuthorPasswordChange",{author=oAuthor,password=rc.password});
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
		// announce event
		announceInterception("bbadmin_preAuthorRemove",{author=oAuthor,authorID=rc.authorID});
		// remove
		authorService.delete( oAuthor );
		// announce event
		announceInterception("bbadmin_postAuthorRemove",{authorID=rc.authorID});
		// message
		getPlugin("MessageBox").setMessage("info","Author Removed!");
		// redirect
		setNextEvent(rc.xehAuthors);
	}
}
