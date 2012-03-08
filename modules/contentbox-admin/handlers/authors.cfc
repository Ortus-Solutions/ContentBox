/**
* Manage authors
*/
component extends="baseHandler"{

	// Dependencies
	property name="authorService"		inject="id:authorService@cb";
	property name="entryService"		inject="id:entryService@cb";
	property name="permissionService"	inject="id:permissionService@cb";
	property name="roleService"			inject="id:roleService@cb";

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);
		// Tab control
		prc.tabUsers = true;
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
		prc.xehAuthorsearch = "#prc.cbAdminEntryPoint#.authors";

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
		prc.tabUsers_manage = true;

		// View
		event.setView("authors/index");
	}

	// username check
	function usernameCheck(event,rc,prc){
		var found = true;

		event.paramValue("username","");

		// only check if we have a username
		if( len(username) ){
			found = authorService.usernameFound( rc.username );
		}

		event.renderData(type="json",data=found);
	}

	// user editor
	function editor(event,rc,prc){
		// exit handlers
		prc.xehAuthorsave 			= "#prc.cbAdminEntryPoint#.authors.save";
		prc.xehAuthorChangePassword = "#prc.cbAdminEntryPoint#.authors.passwordChange";
		prc.xehAuthorPermissions 	= "#prc.cbAdminEntryPoint#.authors.permissions";
		prc.xehUsernameCheck	 	= "#prc.cbAdminEntryPoint#.authors.usernameCheck";

		// get new or persisted author
		prc.author  = authorService.get( event.getValue("authorID",0) );
		// get roles
		prc.roles = roleService.list(sortOrder="role",asQuery=false);

		// viewlets
		prc.entryViewlet = "";
		prc.pageViewlet  = "";
		if( prc.author.isLoaded() ){
			var args = {authorID=rc.authorID};
			prc.entryViewlet = runEvent(event="contentbox-admin:entries.pager",eventArguments=args);
			prc.pageViewlet  = runEvent(event="contentbox-admin:pages.pager",eventArguments=args);
		}

		// Editor
		prc.tabUsers_manage = true;

		// view
		event.setView("authors/editor");
	}

	// save user
	function save(event,rc,prc){
		var oAuthor = authorService.get(id=rc.authorID);

		// Validate credentials
		if(  !prc.oAuthor.checkPermission("AUTHOR_ADMIN") AND oAuthor.getAuthorID() NEQ prc.oAuthor.getAuthorID() ){
			// relocate
			getPlugin("MessageBox").error("You do not have permissions to do this!");
			setNextEvent(event=prc.xehAuthorEditor,queryString="authorID=#rc.authorID#");
			return;
		}

		// get and populate author
		populateModel( oAuthor );
		var newAuthor 	= (NOT oAuthor.isLoaded());

    	// role assignment
    	if( prc.oAuthor.checkPermission("AUTHOR_ADMIN") ){
    		oAuthor.setRole( roleService.get( rc.roleID ) );
    	}

    	// validate it
		var errors = oAuthor.validate();

		if( !arrayLen(errors) ){
			// announce event
			announceInterception("cbadmin_preAuthorSave",{author=oAuthor,authorID=rc.authorID,isNew=newAuthor});
			// save Author
			authorService.saveAuthor( oAuthor );
			// announce event
			announceInterception("cbadmin_postAuthorSave",{author=oAuthor,isNew=newAuthor});
			// message
			getPlugin("MessageBox").setMessage("info","Author saved!");
			// relocate
			setNextEvent(prc.xehAuthors);
		}
		else{
			getPlugin("MessageBox").warn(messageArray=errors);
			setNextEvent(event=prc.xehAuthorEditor,queryString="author=#oAuthor.getAuthorID()#");
		}

	}

	// change passord
	function passwordChange(event,rc,prc){
		var oAuthor = authorService.get(id=rc.authorID);

		// Validate credentials
		if(  !prc.oAuthor.checkPermission("AUTHOR_ADMIN") AND oAuthor.getAuthorID() NEQ prc.oAuthor.getAuthorID() ){
			// relocate
			getPlugin("MessageBox").error("You do not have permissions to do this!");
			setNextEvent(event=prc.xehAuthorEditor,queryString="authorID=#rc.authorID#");
			return;
		}

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

	// permissions
	function permissions(event,rc,prc){
		// exit Handlers
		prc.xehPermissionRemove = "#prc.cbAdminEntryPoint#.authors.removePermission";
		prc.xehPermissionSave 	= "#prc.cbAdminEntryPoint#.authors.savePermission";
		prc.xehRolePermissions 	= "#prc.cbAdminEntryPoint#.authors.permissions";
		// Get all permissions
		prc.permissions = permissionService.list(sortOrder="permission",asQuery=false);
		// Get author
		prc.author = authorService.get( rc.authorID );
		// view
		event.setView(view="authors/permissions",layout="ajax");
	}

	// Save permission to the author and gracefully end.
	function savePermission(event,rc,prc){
		var oAuthor 	= authorService.get( rc.authorID );
		var oPermission = permissionService.get( rc.permissionID );

		// Assign it
		if( !oAuthor.hasPermission( oPermission) ){
			oAuthor.addPermission( oPermission );
			// Save it
			authorService.saveAuthor( oAuthor );
		}
		// Saved
		event.renderData(data="true",type="json");
	}

	// remove permission to a author and gracefully end.
	function removePermission(event,rc,prc){
		var oAuthor 	= authorService.get( rc.authorID );
		var oPermission = permissionService.get( rc.permissionID );

		// Remove it
		oAuthor.removePermission( oPermission );
		// Save it
		authorService.saveAuthor( oAuthor );
		// Saved
		event.renderData(data="true",type="json");
	}
}
