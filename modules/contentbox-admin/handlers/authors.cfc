﻿/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
* Manage ContentBox users
*/
component extends="baseHandler"{

	// Dependencies
	property name="authorService"		inject="id:authorService@cb";
	property name="entryService"		inject="id:entryService@cb";
	property name="permissionService"	inject="id:permissionService@cb";
	property name="roleService"			inject="id:roleService@cb";
	property name="editorService"		inject="id:editorService@cb";
	
	// pre handler
	function preHandler( event, rc, prc, action, eventArguments){
		// Tab control
		prc.tabUsers = true;
		
		// Specific admin validation actions
		if( listFindNoCase( "save,editor,savePreferences,passwordChange,saveRawPreferences", arguments.action ) ){
			// Get incoming author to verify credentials
			arguments.event.paramValue("authorID", 0);
			var oAuthor = authorService.get( rc.authorID );
			// Validate credentials only if you are an admin or you are yourself.
			if(  !prc.oAuthor.checkPermission("AUTHOR_ADMIN") AND oAuthor.getAuthorID() NEQ prc.oAuthor.getAuthorID() ){
				// relocate
				getPlugin("MessageBox").error("You do not have permissions to do this!");
				setNextEvent(event=prc.xehAuthors);
				return;
			}
		}
	}

	// index
	function index( event, rc, prc ){
		// View all tab
		prc.tabUsers_manage = true;

		// exit handlers
		prc.xehAuthorTable	 	= "#prc.cbAdminEntryPoint#.authors.indexTable";
		prc.xehImportAll		= "#prc.cbAdminEntryPoint#.authors.importAll";
		prc.xehExportAll 		= "#prc.cbAdminEntryPoint#.authors.exportAll";
		prc.xehAuthorRemove 	= "#prc.cbAdminEntryPoint#.authors.remove";
		prc.xehAuthorsearch 	= "#prc.cbAdminEntryPoint#.authors";

		// Get Roles
		prc.roles = roleService.getAll( sortOrder="role" );
		
		// View
		event.setView("authors/index");
	}

	// build out user table
	function indexTable( event, rc, prc ){
		// paging
		event.paramValue( "page", 1 )
			.paramValue( "showAll", false )
			.paramValue( "searchAuthors", "" )
			.paramValue( "isFiltering", false, true )
			.paramValue( "fStatus", "any" )
			.paramValue( "fRole", "any" );

		// prepare paging plugin
		prc.pagingPlugin = getMyPlugin( plugin="Paging", module="contentbox" );
		prc.paging 		 = prc.pagingPlugin.getBoundaries();
		prc.pagingLink 	 = 'javascript:contentPaginate(@page@)';

		// exit Handlers
		prc.xehAuthorRemove 	= "#prc.cbAdminEntryPoint#.authors.remove";
		prc.xehExport 			= "#prc.cbAdminEntryPoint#.authors.export";

		// is Filtering?
		if( rc.fRole neq "all" OR rc.fStatus neq "any" or rc.showAll ){ 
			prc.isFiltering = true;
		}
		
		// Get all authors or search
		var results 		= authorService.search( searchTerm=rc.searchAuthors,
													offset=( rc.showAll ? 0 : prc.paging.startRow-1 ),
											   		max=( rc.showAll ? 0 : prc.cbSettings.cb_paging_maxrows ),
											   		sortOrder="lastName asc",
											   		isActive=rc.fStatus,
											   		role=rc.fRole
											   	   );
		prc.authors 		= results.authors;
		prc.authorCount 	= results.count;

		// View
		event.setView( view="authors/indexTable", layout="ajax" );
	}

	// username check
	function usernameCheck( event, rc, prc ){
		var found = true;

		event.paramValue("username","");

		// only check if we have a username
		if( len(username) ){
			found = authorService.usernameFound( rc.username );
		}

		event.renderData(type="json",data=found);
	}

	// user editor
	function editor( event, rc, prc ){
		// exit handlers
		prc.xehAuthorsave 			= "#prc.cbAdminEntryPoint#.authors.save";
		prc.xehAuthorPreferences 	= "#prc.cbAdminEntryPoint#.authors.savePreferences";
		prc.xehAuthorRawPreferences = "#prc.cbAdminEntryPoint#.authors.saveRawPreferences";
		prc.xehAuthorChangePassword = "#prc.cbAdminEntryPoint#.authors.passwordChange";
		prc.xehAuthorPermissions 	= "#prc.cbAdminEntryPoint#.authors.permissions";
		prc.xehUsernameCheck	 	= "#prc.cbAdminEntryPoint#.authors.usernameCheck";

		// get new or persisted author
		prc.author  = authorService.get( event.getValue( "authorID", 0 ) );
		// get roles
		prc.roles = roleService.list( sortOrder="role", asQuery=false );

		// viewlets
		prc.entryViewlet = "";
		prc.pageViewlet  = "";
		if( prc.author.isLoaded() ){
			var args = { authorID=rc.authorID, sorting=false };
			prc.entryViewlet 		= runEvent( event="contentbox-admin:entries.pager", eventArguments=args );
			prc.pageViewlet  		= runEvent( event="contentbox-admin:pages.pager", eventArguments=args );
			prc.contentStoreViewlet	= runEvent( event="contentbox-admin:contentStore.pager", eventArguments=args );
			prc.preferencesViewlet 	= listPreferences(  event, rc, prc  );
		}

		// Editor
		prc.tabUsers_manage = true;

		// view
		event.setView("authors/editor");
	}

	// shortcut to your profile
	function myprofile( event, rc, prc ){
		rc.authorID = prc.oAuthor.getAuthorID();
		editor( argumentCollection=arguments );
	}
	
	// List preferences
	private function listPreferences( event, rc, prc ){
		// get editors for preferences
		prc.editors = editorService.getRegisteredEditors();
		// Get All registered markups so we can display them
		prc.markups = editorService.getRegisteredMarkups();
		// render out view
		return renderView(view="authors/listPreferences", module="contentbox-admin");
	}
	
	// change user editor preferences
	function changeEditor( event, rc, prc ){
		var results = { "ERROR" = false, "MESSAGES" = "" };
		try{
			// store the new author preference	
			prc.oAuthor.setPreference(name="editor", value=rc.editor);
			// save Author preference
			authorService.saveAuthor( prc.oAuthor );
			results[ "MESSAGES" ] = "Editor changed to #rc.editor#";
		}
		catch(Any e){
			log.error("Error saving preferences.", e);
			results[ "ERROR" ] = true;
			results[ "MESSAGES" ] = e.detail & e.message;
		}
		// return preference saved
		event.renderData(type="json", data=results);
	}
	
	// change user sidebar preferences
	function changeSidebarState( event, rc, prc ){
		event.paramvalue( "sidebarState", false );
		var results = { "ERROR" = false, "MESSAGES" = "" };
		try{
			// store the new author preference	
			prc.oAuthor.setPreference(name="sidebarstate", value=rc.sidebarstate);
			// save Author preference
			authorService.saveAuthor( prc.oAuthor );
			results[ "MESSAGES" ] = "Sidebar state saved";
		}
		catch(Any e){
			log.error("Error saving preferences.", e);
			results[ "ERROR" ] = true;
			results[ "MESSAGES" ] = e.detail & e.message;
		}
		// return preference saved
		event.renderData(type="json", data=results);
	}
	

	// save user
	function savePreferences( event, rc, prc ){
		var oAuthor 		= authorService.get(id=rc.authorID);
		var allPreferences 	= {};
		
		// iterate rc keys that start with "preference."
		for(var key in rc){
			if( listFirst( key, "." ) eq "preference" ){
				allPreferences[ listLast( key, "." ) ] = rc[ key ];
			}
		}
		// Store Preferences
		oAuthor.setPreferences( allPreferences );
		// announce event
		announceInterception("cbadmin_preAuthorPreferencesSave",{author=oAuthor, preferences=allPreferences});
		// save Author
		authorService.saveAuthor( oAuthor );
		// announce event
		announceInterception("cbadmin_postAuthorPreferencesSave",{author=oAuthor, preferences=allPreferences});
		// message
		getPlugin("MessageBox").setMessage("info","Author Preferences Saved!");
		// relocate
		setNextEvent(event=prc.xehAuthorEditor,queryString="authorID=#oAuthor.getAuthorID()###preferences");
	}
	
	// save raw preferences
	function saveRawPreferences( event, rc, prc ){
		var oAuthor = authorService.get(id=rc.authorID);
		// Validate raw preferences
		var vResult = validateModel(target=rc, constraints={ preferences = {required=true, type="json" } });
		if( !vResult.hasErrors() ){
			// store preferences
			oAuthor.setPreferences( rc.preferences );
			// announce event
			announceInterception("cbadmin_preAuthorPreferencesSave",{author=oAuthor, preferences=rc.preferences});
			// save Author
			authorService.saveAuthor( oAuthor );
			// announce event
			announceInterception("cbadmin_postAuthorPreferencesSave",{author=oAuthor, preferences=rc.preferences});
			// message
			getPlugin("MessageBox").setMessage("info","Author Preferences Saved!");
			// relocate
			setNextEvent(event=prc.xehAuthorEditor,queryString="authorID=#oAuthor.getAuthorID()###preferences");	
		}
		else{
			// message
			getPlugin("MessageBox").error(messageArray=vResult.getAllErrors());
			// relocate
			setNextEvent(event=prc.xehAuthorEditor,queryString="authorID=#oAuthor.getAuthorID()###preferences");
		}	
	}
	
	// save user
	function save( event, rc, prc ){
		// Get new or persisted user
		var oAuthor = authorService.get(id=rc.authorID);
		// get and populate author
		populateModel( oAuthor );
		// Tag new or updated user
		var newAuthor = (NOT oAuthor.isLoaded());

    	// role assignment if permission allows it
    	if( prc.oAuthor.checkPermission("AUTHOR_ADMIN") ){
    		oAuthor.setRole( roleService.get( rc.roleID ) );
    	}

    	// validate it
    	var vResults = validateModel(target=oAuthor, excludes=( structKeyExists(rc, "password") ? "" : "password" ));
		if( !vResults.hasErrors() ){
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
			getPlugin("MessageBox").warn(messageArray=vResults.getAllErrors());
			setNextEvent(event=prc.xehAuthorEditor,queryString="authorID=#oAuthor.getAuthorID()#");
		}

	}

	// change passord
	function passwordChange( event, rc, prc ){
		var oAuthor = authorService.get(id=rc.authorID);

		// validate passwords
		if( compareNoCase(rc.password, rc.password_confirm) EQ 0){
			// set new password
			oAuthor.setPassword( rc.password );
			authorService.saveAuthor(author=oAuthor, passwordChange=true);
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
		setNextEvent(event=prc.xehAuthorEditor, queryString="authorID=#rc.authorID#");
	}

	// remove user
	function remove( event, rc, prc ){
		var oAuthor	= authorService.get( rc.authorID );

		if( isNull(oAuthor) ){
			getPlugin("MessageBox").setMessage("warning","Invalid Author detected!");
			setNextEvent( prc.xehAuthors );
		}
		// announce event
		announceInterception("cbadmin_preAuthorRemove",{author=oAuthor,authorID=rc.authorID});
		// remove
		oAuthor.clearPermissions();
		authorService.delete( oAuthor );
		// announce event
		announceInterception("cbadmin_postAuthorRemove",{authorID=rc.authorID});
		// message
		getPlugin("MessageBox").setMessage("info","Author Removed!");
		// redirect
		setNextEvent(prc.xehAuthors);
	}

	// permissions
	function permissions( event, rc, prc ){
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
	function savePermission( event, rc, prc ){
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
	function removePermission( event, rc, prc ){
		var oAuthor 	= authorService.get( rc.authorID );
		var oPermission = permissionService.get( rc.permissionID );

		// Remove it
		oAuthor.removePermission( oPermission );
		// Save it
		authorService.saveAuthor( oAuthor );
		// Saved
		event.renderData(data="true",type="json");
	}
	
	// Export Entry
	function export( event, rc, prc ){
		event.paramValue("format", "json");
		// get user
		prc.user  = authorService.get( event.getValue("authorID",0) );
		
		// relocate if not existent
		if( !prc.user.isLoaded() ){
			getPlugin("MessageBox").warn("authorID sent is not valid");
			setNextEvent( "#prc.cbAdminEntryPoint#.authors" );
		}
		//writeDump( prc.role.getMemento() );abort;
		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "#prc.user.getUsername()#." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=prc.user.getMemento(), type=rc.format, xmlRootName="user")
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#"); 
				break;
			}
			default:{
				event.renderData(data="Invalid export type: #rc.format#");
			}
		}
	}
	
	// Export All Entries
	function exportAll( event, rc, prc ){
		event.paramValue("format", "json");
		// get all prepared content objects
		var data  = authorService.getAllForExport();
		
		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "Users." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=data, type=rc.format, xmlRootName="users")
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#"); 
				break;
			}
			default:{
				event.renderData(data="Invalid export type: #rc.format#");
			}
		}
	}
	
	// import entries
	function importAll( event, rc, prc ){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try{
			if( len( rc.importFile ) and fileExists( rc.importFile ) ){
				var importLog = authorService.importFromFile( importFile=rc.importFile, override=rc.overrideContent );
				getPlugin("MessageBox").info( "Users imported sucessfully!" );
				flash.put( "importLog", importLog );
			}
			else{
				getPlugin("MessageBox").error( "The import file is invalid: #rc.importFile# cannot continue with import" );
			}
		}
		catch(any e){
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			getPlugin("MessageBox").error( errorMessage );
		}
		setNextEvent( prc.xehAuthors );
	}
}
