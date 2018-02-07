/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manage ContentBox users
*/
component extends="baseHandler"{

	// Dependencies
	property name="authorService"			inject="id:authorService@cb";
	property name="securityService"			inject="id:securityService@cb";
	property name="entryService"			inject="id:entryService@cb";
	property name="permissionService"		inject="id:permissionService@cb";
	property name="permissionGroupService"	inject="id:permissionGroupService@cb";
	property name="roleService"				inject="id:roleService@cb";
	property name="editorService"			inject="id:editorService@cb";
	property name="paging"					inject="id:paging@cb";
	property name="twoFactorService"		inject="id:twoFactorService@cb";

	/**
	* Pre handler
	*/
	function preHandler( event, rc, prc, action, eventArguments ){
		var protectedActions = [
			"save",
			"editor",
			"savePreferences",
			"passwordChange",
			"doPasswordReset",
			"saveRawPreferences",
			"saveTwoFactor"
		];

		// Specific admin validation actions
		if( arrayFindNoCase( protectedActions, arguments.action ) ){
			// Get incoming author to verify credentials
			arguments.event.paramValue( "authorID", 0 );
			var oAuthor = authorService.get( rc.authorID );
			// Validate credentials only if you are an admin or you are yourself.
			if(
				!prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" )
				AND
				oAuthor.getAuthorID() NEQ prc.oCurrentAuthor.getAuthorID()
			){
				// relocate
				cbMessagebox.error( "You do not have permissions to do this!" );
				setNextEvent( event=prc.xehAuthors );
				return;
			}
		}
	}

	/**
	* List system authors
	* @return html
	*/
	function index( event, rc, prc ){
		// View all tab
		prc.tabUsers_manage = true;

		// exit handlers
		prc.xehAuthorTable	 		= "#prc.cbAdminEntryPoint#.authors.indexTable";
		prc.xehImportAll			= "#prc.cbAdminEntryPoint#.authors.importAll";
		prc.xehExportAll 			= "#prc.cbAdminEntryPoint#.authors.exportAll";
		prc.xehAuthorRemove 		= "#prc.cbAdminEntryPoint#.authors.remove";
		prc.xehAuthorCreate 		= "#prc.cbAdminEntryPoint#.authors.new";
		prc.xehAuthorsearch 		= "#prc.cbAdminEntryPoint#.authors";
		prc.xehGlobalPasswordReset 	= "#prc.cbAdminEntryPoint#.authors.doGlobalPasswordReset";

		// Get Roles
		prc.aRoles 				= roleService.getAll( sortOrder="role" );
		prc.aPermissionGroups 	= permissionGroupService.getAll( sortOrder="name" );
		prc.statusReport 		= authorService.getStatusReport();

		// View
		event.setView( "authors/index" );
	}

	/**
	* Issue a global password reset for all users in the system.
	*/
	function doGlobalPasswordReset( event, rc, prc ){
		// announce event
		announceInterception( "cbadmin_onGlobalPasswordReset" );
		// Get All Authors and reset the heck out of all of them.
		var allAuthors = authorService.getAll();

		for( var thisAuthor in allAuthors ){
			// Issue a password reset for a user
			thisAuthor.setIsPasswordReset( true );
			securityService.sendPasswordReminder(
				author      = thisAuthor,
				adminIssued = true,
				issuer      = prc.oCurrentAuthor
			);
			// announce individual event
			announceInterception( "cbadmin_onPasswordReset", { author = thisAuthor } );
		}

		// Bulk Save
		authorService.saveAll( allAuthors );

		// relocate
		cbMessagebox.info( "Global password reset issued!" );
		setNextEvent( prc.xehAuthors );
	}

	/**
	* Build out system author's table + filters
	* @return html
	*/
	function indexTable( event, rc, prc ){
		// paging
		event.paramValue( "page", 1 )
			.paramValue( "showAll", false )
			.paramValue( "searchAuthors", "" )
			.paramValue( "isFiltering", false, true )
			.paramValue( "fStatus", "true" )
			.paramValue( "f2FactorAuth", "true" )
			.paramValue( "fRole", "any" )
			.paramValue( "fGroups", "any" )
			.paramValue( "sortOrder", "lastname_asc" );

		// prepare paging object
		prc.oPaging 	= variables.paging;
		prc.paging 		= prc.oPaging.getBoundaries();
		prc.pagingLink 	= 'javascript:contentPaginate( @page@ )';

		// exit Handlers
		prc.xehAuthorRemove 	= "#prc.cbAdminEntryPoint#.authors.remove";
		prc.xehExport 			= "#prc.cbAdminEntryPoint#.authors.export";
		prc.xehPasswordReset	= "#prc.cbAdminEntryPoint#.authors.doPasswordReset";

		// is Filtering?
		if( rc.fRole neq "any"
			OR rc.fStatus neq "any"
			OR rc.f2FactorAuth neq "any"
			OR rc.fGroups neq "any"
			OR rc.showAll
		){
			prc.isFiltering = true;
		}

		// Determine Sort Order internally to avoid XSS
		var sortOrder = "lastName";
		switch( rc.sortOrder ){
			case "lastname_asc" 		: { sortOrder = "lastName asc";      break; }
			case "lastLogin_desc"    	: { sortOrder = "lastLogin desc";    break; }
			case "lastLogin_asc"     	: { sortOrder = "lastLogin asc";     break; }
			case "createdDate_desc"  	: { sortOrder = "createdDate desc";  break; }
			case "createdDate_asc"   	: { sortOrder = "createdDate asc";   break; }
			case "modifiedDate_desc" 	: { sortOrder = "modifiedDate desc"; break; }
			case "modifiedDate_asc"  	: { sortOrder = "modifiedDate asc";  break; }
		}

		// Get all authors or search
		var results = authorService.search(
			searchTerm 			= rc.searchAuthors,
			offset    			= ( rc.showAll ? 0 : prc.paging.startRow-1 ),
			max       			= ( rc.showAll ? 0 : prc.cbSettings.cb_paging_maxrows ),
			sortOrder 			= sortOrder,
			isActive  			= rc.fStatus,
			role      			= rc.fRole,
			permissionGroups 	= rc.fGroups,
			twoFactorAuth		= rc.f2FactorAuth
		);
		prc.authors 		= results.authors;
		prc.authorCount 	= results.count;

		// View
		event.setView( view="authors/indexTable", layout="ajax" );
	}

	/**
	* System username checks
	* @return json
	*/
	function usernameCheck( event, rc, prc ){
		var found = true;

		event.paramValue( "username","" );

		// only check if we have a username
		if( len( username ) ){
			found = authorService.usernameFound( rc.username );
		}

		event.renderData( type="json",data=found );
	}

	/**
	* System email checks
	* @return json
	*/
	function emailCheck( event, rc, prc ){
		var found = true;

		event.paramValue( "email","" );

		// only check if we have a email
		if( len( email ) ){
			found = authorService.emailFound( rc.email );
		}

		event.renderData( type="json", data=found );
	}

	/**
	* Issue a password reset for the user
	*/
	function doPasswordReset( event, rc, prc ){
		event.paramValue( "editing", false );

		// get new or persisted author
		var oAuthor  = authorService.get( event.getValue( "authorID", 0 ) );
		// viewlets only if editing a user
		if( oAuthor.isLoaded() ){
			// Issue a password reset for a user
			oAuthor.setIsPasswordReset( true );
			authorService.saveAuthor( oAuthor );
			securityService.sendPasswordReminder(
				author      = oAuthor,
				adminIssued = true,
				issuer      = prc.oCurrentAuthor
			);
			// announce event
			announceInterception( "cbadmin_onPasswordReset", { author = oAuthor } );
			cbMessagebox.info( "Author marked for password reset upon login and email notification sent!" );
		} else {
			cbMessagebox.error( "Invalid Author Sent!" );
		}

		// relocate
		setNextEvent(
			event		= ( rc.editing ? prc.xehAuthorEditor : prc.xehAuthors ),
			queryString	= ( rc.editing ? "authorID=#oAuthor.getAuthorID()#" : "" )
		);
	}

	/**
	* New author wizard
	* You must have the AUTHOR_ADMIN permission to execute
	*/
	function new( event, rc, prc ){
		// exit handlers
		prc.xehAuthorsave 			= "#prc.cbAdminEntryPoint#.authors.doNew";
		prc.xehUsernameCheck	 	= "#prc.cbAdminEntryPoint#.authors.usernameCheck";
		prc.xehEmailCheck	 		= "#prc.cbAdminEntryPoint#.authors.emailCheck";

		// get new author for form
		prc.author  = authorService.new();
		// get all roles
		prc.roles = roleService.list( sortOrder="role", asQuery=false );
		// Get all permission groups
		prc.aPermissionGroups	= permissionGroupService.list( sortOrder="name", asQuery=false );
		// get editors for preferences
		prc.editors = editorService.getRegisteredEditors();
		// Get All registered markups so we can display them
		prc.markups = editorService.getRegisteredMarkups();

		// view
		event.setView( "authors/new" );
	}

	/**
	* Create a new user in the system
	* You must have the AUTHOR_ADMIN permission to execute
	*/
	function doNew( event, rc, prc ){
		// Get new author with defaults
		var oAuthor = authorService.new( {
			isActive 		= true,
			isPasswordReset = true,
			password 		= hash( createUUID() & now() )
		} );

		// get and populate author
		populateModel( model=oAuthor, composeRelationships=true, exclude="preference" );

		// iterate rc keys that start with "preference."
		var allPreferences 	= {};
		for( var key in rc ){
			if( reFindNoCase( "^preference\.", key ) ){
				allPreferences[ listLast( key, "." ) ] = rc[ key ];
			}
		}
		// Store Preferences for saving
		oAuthor.setPreferences( allPreferences );

    	// validate it
    	var vResults = validateModel( target=oAuthor, excludes="password" );
		if( !vResults.hasErrors() ){
			// announce event
			announceInterception( "cbadmin_preNewAuthorSave", { author=oAuthor } );
			// save author
			authorService.createNewAuthor( oAuthor );
			// announce event
			announceInterception( "cbadmin_postNewAuthorSave", { author=oAuthor } );
			// message
			cbMessagebox.setMessage( "info","New Author Created and Notified!" );
			// relocate
			setNextEvent( prc.xehAuthors );
		} else {
			cbMessagebox.warn( messageArray=vResults.getAllErrors() );
			return new( argumentCollection=arguments );
		}
    }

    /**
     * Show the two-factor authentication screen for forced enrollment
     */
    function forceTwoFactorEnrollment( event, rc, prc ) {
		if( flash.exists( "authorData" ) ){
			// Inflate author for requested events
			prc.author = authorService.get( flash.get( "authorData" ).authorID );
		} else {
			prc.author = prc.oCurrentAuthor;
		}
        
        prc.xehEnrollTwoFactor = "#prc.cbAdminEntryPoint#.authors.enrollTwofactor";
        prc.xehUnenrollTwoFactor = "#prc.cbAdminEntryPoint#.authors.unenrollTwoFactor";
        prc.twoFactorProvider = twoFactorService.getDefaultProviderObject();
        flash.putAll( {
            "layout" = "simple",
            "xehInvalidData" = "#prc.cbAdminEntryPoint#.authors.forceTwoFactorEnrollment",
            "xehEnrollmentSuccess" = "/",
            "xehEnrollmentSuccessQueryString" = ""
        } );
        event.setView( view = "twofactor/forceEnrollment", layout = "simple" );
    }

    /**
     * Present the enrollment form for two-factor authentication
     */
    function enrollTwoFactor( event, rc, prc ){
        param rc.authorID = flash.get( "authorID", "" );
        flash.put( "authorID", rc.authorID );
        prc.oAuthor = authorService.get( id=rc.authorID );

        if ( prc.oCurrentAuthor.isLoaded() && prc.oCurrentAuthor.getAuthorID() != prc.oAuthor.getAuthorID() ) {
            cbMessagebox.warn( "You cannot enroll another user in two-factor authentication." );
            flash.keep();
            setNextEvent(
                event		= flash.get( "xehInvalidData", prc.xehAuthorEditor ),
                queryString	= "authorID=#prc.oAuthor.getAuthorID()###twofactor"
            );
            return;
        }

        // iterate rc keys that start with "preference."
        var allPreferences 	= {};
		for( var key in rc ){
			if( reFindNoCase( "^preference\.", key ) ){
				allPreferences[ listLast( key, "." ) ] = rc[ key ];
			}
		}
        prc.oAuthor.setPreferences( allPreferences );
        populateModel( model = prc.oAuthor, exclude = "preference" );
        var vResults = validateModel( target = prc.oAuthor, excludes = "password" );
		if ( vResults.hasErrors() ) {
            cbMessagebox.warn( messageArray=vResults.getAllErrors() );
            flash.keep( );
            setNextEvent(
                event		= flash.get( "xehInvalidData", prc.xehAuthorEditor ),
                queryString	= "authorID=#prc.oAuthor.getAuthorID()###twofactor"
            );
        }

        authorService.saveAuthor( prc.oAuthor );

        prc.xehValidate = "#prc.cbadminEntryPoint#.authors.doTwoFactorEnrollment";
        prc.xehResend 	= "#prc.cbadminEntryPoint#.authors.enrollTwoFactor";
        prc.provider 	= twoFactorService.getDefaultProviderObject();

        // Send challenge
        var twoFactorResults = twoFactorService.sendChallenge( prc.oAuthor );
        // Verify error, if so, log it and setup a messagebox
        if( twoFactorResults.error ){
            log.error( twoFactorResults.messages );
            cbMessagebox.error( $r( "twofactor.error@security" ) );
        } else {
            cbMessagebox.append( $r( "twofactor.codesent@security" ) );
        }
        flash.keep( "layout,xehEnrollmentSuccess,xehEnrollmentSuccessQueryString" );
        event.setView( view = "twofactor/index", module = "contentbox-security", layout = flash.get( "layout", "admin" ) );
    }

    /**
     * Validate the two-factor authentication.
     */
    function doTwoFactorEnrollment( event, rc, prc ){
        event.paramValue( "twofactorCode", "" )
            .paramValue( "trustDevice", false )
            .paramValue( "authorID", flash.get( "authorID", "" ) );

        prc.oAuthor = authorService.get( id=rc.authorID );

        // Verify the challenge code
        var results = twoFactorService.verifyChallenge(
            code   = rc.twofactorcode,
            author = prc.oAuthor
        );

        // Check for errors
        if( results.error ){
            announceInterception( "cbadmin_onInvalidTwoFactor", { author = prc.oAuthor } );
            // message and redirect
            cbMessagebox.error( results.messages & "#chr(10)#" );
            flash.keep( "authorID,layout,xehEnrollmentSuccess,xehEnrollmentSuccessQueryString" );
            setNextEvent( "#prc.cbadminEntryPoint#.authors.enrollTwoFactor" );
        } else {
            var oTwoFactorProvider = twoFactorService.getDefaultProviderObject();
            // Call Provider finalize callback, in case something is needed for teardowns
            oTwoFactorProvider.finalize( rc.twofactorcode, prc.oAuthor );

            // announce events
            announceInterception( "cbadmin_onValidTwoFactor", { author = prc.oAuthor } );

            cbMessagebox.info( "Successfully enrolled" );
            rc.is2FactorAuth = true;
            return saveTwoFactor( event, rc, prc );
        }
    }

    /**
    * Un-enroll the user from two-factor authentication
    */
    function unenrollTwoFactor( event, rc, prc ){
        rc.is2FactorAuth = false;
        return saveTwoFactor( event, rc, prc );
    }

	/**
	* Save Two Factor Authentication details.
	*/
	function saveTwoFactor( event, rc, prc ){
		// Get the persisted user
		var oAuthor = authorService.get( id=rc.authorID );
		oAuthor.setIs2FactorAuth( !!rc.is2FactorAuth );
		// Announce event
		announceInterception( "cbadmin_onAuthorTwoFactorSaveOptions", { author=oAuthor } );
		// save Author
		authorService.saveAuthor( oAuthor );
		// message
		cbMessagebox.setMessage( "info","Two Factor Settings Saved!" );
		if ( !prc.oCurrentAuthor.isLoaded() ){
			// Set in session, validations are now complete
			securityService.setAuthorSession( oAuthor );
		}
		// relocate
		setNextEvent(
			event		= flash.get( "xehEnrollmentSuccess", prc.xehAuthorEditor ),
			queryString	= flash.get( "xehEnrollmentSuccessQueryString", "authorID=#oAuthor.getAuthorID()###twofactor" )
		);
	}

	/**
	* Author editor panel
	* @return html
	*/
	function editor( event, rc, prc ){
        prc.htmlTitle = "Author Editor";
		// exit handlers
		prc.xehAuthorsave 			= "#prc.cbAdminEntryPoint#.authors.save";
		prc.xehAuthorPreferences 	= "#prc.cbAdminEntryPoint#.authors.savePreferences";
		prc.xehAuthorRawPreferences = "#prc.cbAdminEntryPoint#.authors.saveRawPreferences";
		prc.xehAuthorChangePassword = "#prc.cbAdminEntryPoint#.authors.passwordChange";
		prc.xehAuthorPermissions 	= "#prc.cbAdminEntryPoint#.authors.permissions";
		prc.xehUsernameCheck	 	= "#prc.cbAdminEntryPoint#.authors.usernameCheck";
		prc.xehEmailCheck	 		= "#prc.cbAdminEntryPoint#.authors.emailCheck";
		prc.xehEntriesManager  		= "#prc.cbAdminEntryPoint#.entries.index";
		prc.xehPagesManager  		= "#prc.cbAdminEntryPoint#.pages.index";
		prc.xehContentStoreManager  = "#prc.cbAdminEntryPoint#.contentStore.index";
		prc.xehExport 				= "#prc.cbAdminEntryPoint#.authors.export";
        prc.xehPasswordReset		= "#prc.cbAdminEntryPoint#.authors.doPasswordReset";
        prc.xehEnrollTwoFactor 		= "#prc.cbAdminEntryPoint#.authors.enrollTwofactor";
        prc.xehUnenrollTwoFactor 	= "#prc.cbAdminEntryPoint#.authors.unenrollTwoFactor";

		// get new or persisted author
		prc.author  = authorService.get( event.getValue( "authorID", 0 ) );
		// get roles
		prc.roles = roleService.list( sortOrder="role", asQuery=false );
		// get two factor provider
		prc.twoFactorProvider = twoFactorService.getDefaultProviderObject();

		// viewlets only if editing a user
		if( prc.author.isLoaded() ){
			// Preferences Viewlet
			var args = {
				authorID	= rc.authorID,
				sorting		= false,
				max			= 5,
				pagination	= false,
				latest		= true
			};
			prc.preferencesViewlet 	= listPreferences(  event, rc, prc  );

			// Latest Edits
			prc.latestEditsViewlet = runEvent(
				event 			= "contentbox-admin:content.latestContentEdits",
				eventArguments 	= {
					author 		= prc.author,
					showHits 	= true,
					showAuthor 	= false
				}
			);

			// Latest Drafts
			prc.latestDraftsViewlet = runEvent(
				event 			= "contentbox-admin:content.latestContentEdits",
				eventArguments 	= {
					author 				= prc.author,
					isPublished			= false,
					showHits 			= false,
					colorCodings		= false,
					showPublishedStatus	= false,
					showAuthor			= false
				}
			);
		}
		// view
		event.setView( "authors/editor" );
	}

	/**
	* Shortcut to author profile
	* @return html
	*/
	function myprofile( event, rc, prc ){
		rc.authorID = prc.oCurrentAuthor.getAuthorID();
		editor( argumentCollection=arguments );
	}

	/**
	* change user editor preferences
	*/
	function changeEditor( event, rc, prc ){
		var results = { "ERROR" = false, "MESSAGES" = "" };
		try{
			// store the new author preference
			prc.oCurrentAuthor.setPreference(name="editor", value=rc.editor);
			// save Author preference
			authorService.saveAuthor( prc.oCurrentAuthor );
			results[ "MESSAGES" ] = "Editor changed to #rc.editor#";
		}
		catch(Any e){
			log.error( "Error saving preferences.", e);
			results[ "ERROR" ] = true;
			results[ "MESSAGES" ] = e.detail & e.message;
		}
		// return preference saved
		event.renderData(type="json", data=results);
	}

	/**
	* Save user preference async
	*/
	function saveSinglePreference( event, rc, prc ){
		event.paramvalue( "preference", "" )
			.paramValue( "value", "" );
		var results = { "ERROR" = false, "MESSAGES" = "" };

		// Check preference value
		if( len( rc.preference ) ){
			// store the new author preference
			prc.oCurrentAuthor.setPreference( name=rc.preference, value=rc.value );
			// save Author preference
			authorService.saveAuthor( prc.oCurrentAuthor );
			results[ "MESSAGES" ] = "Preference saved";
		} else {
			results[ "ERROR" ] 		= true;
			results[ "MESSAGES" ] 	= "No preference sent!";
		}

		// return preference saved
		event.renderData( type="json", data=results );
	}

	/**
	* Save user preferences
	*/
	function savePreferences( event, rc, prc ){
		var oAuthor 		= authorService.get( id=rc.authorID );
		var allPreferences 	= {};

		// iterate rc keys that start with "preference."
		for( var key in rc ){
			if( reFindNoCase( "^preference\.", key ) ){
				allPreferences[ listLast( key, "." ) ] = rc[ key ];
			}
		}
		// Store Preferences
		oAuthor.setPreferences( allPreferences );
		// announce event
		announceInterception( "cbadmin_preAuthorPreferencesSave", { author=oAuthor, preferences=allPreferences } );
		// save Author
		authorService.saveAuthor( oAuthor );
		// announce event
		announceInterception( "cbadmin_postAuthorPreferencesSave", { author=oAuthor, preferences=allPreferences } );
		// message
		cbMessagebox.setMessage( "info","Author Preferences Saved!" );
		// relocate
		setNextEvent(
			event		= prc.xehAuthorEditor,
			queryString	= "authorID=#oAuthor.getAuthorID()###preferences"
		);
	}

	/**
	* Save raw preferences
	*/
	function saveRawPreferences( event, rc, prc ){
		var oAuthor = authorService.get(id=rc.authorID);
		// Validate raw preferences
		var vResult = validateModel(target=rc, constraints={ preferences = {required=true, type="json" } } );
		if( !vResult.hasErrors() ){
			// store preferences
			oAuthor.setPreferences( rc.preferences );
			// announce event
			announceInterception( "cbadmin_preAuthorPreferencesSave",{author=oAuthor, preferences=rc.preferences} );
			// save Author
			authorService.saveAuthor( oAuthor );
			// announce event
			announceInterception( "cbadmin_postAuthorPreferencesSave",{author=oAuthor, preferences=rc.preferences} );
			// message
			cbMessagebox.setMessage( "info","Author Preferences Saved!" );
			// relocate
			setNextEvent(event=prc.xehAuthorEditor,queryString="authorID=#oAuthor.getAuthorID()###preferences" );
		}
		else{
			// message
			cbMessagebox.error(messageArray=vResult.getAllErrors());
			// relocate
			setNextEvent(event=prc.xehAuthorEditor,queryString="authorID=#oAuthor.getAuthorID()###preferences" );
		}
	}

	/**
	* Save user
	*/
	function save( event, rc, prc ){
		// Get new or persisted user
		var oAuthor = authorService.get(id=rc.authorID);
		// get and populate author
		populateModel( oAuthor );
		// Tag new or updated user
		var newAuthor = (NOT oAuthor.isLoaded());

    	// role assignment if permission allows it
    	if( prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" ) ){
    		oAuthor.setRole( roleService.get( rc.roleID ) );
    	}

    	// validate it
    	var vResults = validateModel(target=oAuthor, excludes=( structKeyExists(rc, "password" ) ? "" : "password" ));
		if( !vResults.hasErrors() ){
			// announce event
			announceInterception( "cbadmin_preAuthorSave",{author=oAuthor,authorID=rc.authorID,isNew=newAuthor} );
			// save Author
			authorService.saveAuthor( oAuthor );
			// announce event
			announceInterception( "cbadmin_postAuthorSave",{author=oAuthor,isNew=newAuthor} );
			// message
			cbMessagebox.setMessage( "info","Author saved!" );
			// relocate
			setNextEvent(prc.xehAuthors);
		}
		else{
			cbMessagebox.warn(messageArray=vResults.getAllErrors());
			setNextEvent(event=prc.xehAuthorEditor,queryString="authorID=#oAuthor.getAuthorID()#" );
		}
	}

	/**
	* Change user password
	*/
	function passwordChange( event, rc, prc ){
		if( prc.oCurrentAuthor.getAuthorID() != rc.authorID ){
			cbMessagebox.error( "You cannot change passwords for other users. Please start a password reset instead." );
			return setNextEvent( event=prc.xehAuthorEditor, queryString="authorID=#rc.authorID#" );
		}
		var oAuthor = authorService.get( id=rc.authorID );

		// validate passwords
		if( compareNoCase( rc.password, rc.password_confirm ) EQ 0){
			// set new password
			oAuthor.setPassword( rc.password );
			authorService.saveAuthor( author=oAuthor, passwordChange=true );
			// announce event
			announceInterception( "cbadmin_onAuthorPasswordChange", { author=oAuthor, password=rc.password } );
			// message
			cbMessagebox.info( "Password Updated!" );
		}
		else{
			// message
			cbMessagebox.error( "Passwords do not match, please try again!" );
		}

		// relocate
		setNextEvent( event=prc.xehAuthorEditor, queryString="authorID=#rc.authorID#" );
	}

	/**
	* Remove a user
	*/
	function remove( event, rc, prc ){
		event.paramValue( "targetAuthorID", 0 );

		var oAuthor	= authorService.get( rc.targetAuthorID );

		if( isNull( oAuthor ) ){
			cbMessagebox.setMessage( "warning","Invalid Author!" );
			setNextEvent( prc.xehAuthors );
		}
		// announce event
		announceInterception( "cbadmin_preAuthorRemove", { author=oAuthor,authorID = rc.targetAuthorID } );
		// remove
		authorService.deleteAuthor( oAuthor );
		// announce event
		announceInterception( "cbadmin_postAuthorRemove", { authorID = rc.targetAuthorID } );
		// message
		cbMessagebox.setMessage( "info","Author Removed!" );
		// redirect
		setNextEvent(prc.xehAuthors);
	}

	/**
	* Display permissions tab
	*/
	function permissions( event, rc, prc ){
		// exit Handlers
		prc.xehPermissionRemove = "#prc.cbAdminEntryPoint#.authors.removePermission";
		prc.xehPermissionSave 	= "#prc.cbAdminEntryPoint#.authors.savePermission";
		prc.xehRolePermissions 	= "#prc.cbAdminEntryPoint#.authors.permissions";
		prc.xehGroupRemove 		= "#prc.cbAdminEntryPoint#.authors.removePermissionGroup";
		prc.xehGroupSave 		= "#prc.cbAdminEntryPoint#.authors.savePermissionGroup";

		// Get all permissions
		prc.aPermissions 		= permissionService.list( sortOrder="permission", asQuery=false );
		prc.aPermissionGroups	= permissionGroupService.list( sortOrder="name", asQuery=false );

		// Get author
		prc.author = authorService.get( rc.authorID );

		// view
		event.setView( view="authors/permissions", layout="ajax" );
	}

	/**
	* Save permission to the author and gracefully end.
	*/
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
		event.renderData(data="true",type="json" );
	}

	/**
	* Remove permission to a author and gracefully end.
	*/
	function removePermission( event, rc, prc ){
		var oAuthor 	= authorService.get( rc.authorID );
		var oPermission = permissionService.get( rc.permissionID );

		// Remove it
		oAuthor.removePermission( oPermission );
		// Save it
		authorService.saveAuthor( oAuthor );
		// Saved
		event.renderData(data="true",type="json" );
	}

	/**
	* Save permission groups to the author and gracefully end.
	*/
	function savePermissionGroup( event, rc, prc ){
		var oAuthor = authorService.get( rc.authorID );
		var oGroup 	= permissionGroupService.get( rc.permissionGroupID );

		// Assign it
		if( !oAuthor.hasPermissionGroup( oGroup) ){
			oAuthor.addPermissionGroup( oGroup );
			// Save it
			authorService.saveAuthor( oAuthor );
		}
		// Saved
		event.renderData( data="true", type="json" );
	}

	/**
	* Remove permission to a author and gracefully end.
	*/
	function removePermissionGroup( event, rc, prc ){
		var oAuthor = authorService.get( rc.authorID );
		var oGroup 	= permissionGroupService.get( rc.permissionGroupID );

		// Remove it
		oAuthor.removePermissionGroup( oGroup );
		// Save it
		authorService.saveAuthor( oAuthor );
		// Saved
		event.renderData( data="true", type="json" );
	}

	/**
	* Export a user
	*/
	function export( event, rc, prc ){
		event.paramValue( "format", "json" );
		// get user
		prc.user  = authorService.get( event.getValue( "authorID",0) );

		// relocate if not existent
		if( !prc.user.isLoaded() ){
			cbMessagebox.warn( "authorID sent is not valid" );
			setNextEvent( "#prc.cbAdminEntryPoint#.authors" );
		}
		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "#prc.user.getUsername()#." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=prc.user.getMemento(), type=rc.format, xmlRootName="user" )
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#" );
				break;
			}
			default:{
				event.renderData( data="Invalid export type: #rc.format#" );
			}
		}
	}

	/**
	* Export all users
	*/
	function exportAll( event, rc, prc ){
		event.paramValue( "format", "json" );
		// get all prepared content objects
		var data  = authorService.getAllForExport();

		switch( rc.format ){
			case "xml" : case "json" : {
				var filename = "Users." & ( rc.format eq "xml" ? "xml" : "json" );
				event.renderData(data=data, type=rc.format, xmlRootName="users" )
					.setHTTPHeader( name="Content-Disposition", value=" attachment; filename=#fileName#" );
				break;
			}
			default:{
				event.renderData(data="Invalid export type: #rc.format#" );
			}
		}
	}

	/**
	* Import all users
	*/
	function importAll( event, rc, prc ){
		event.paramValue( "importFile", "" );
		event.paramValue( "overrideContent", false );
		try{
			if( len( rc.importFile ) and fileExists( rc.importFile ) ){
				var importLog = authorService.importFromFile( importFile=rc.importFile, override=rc.overrideContent );
				cbMessagebox.info( "Users imported sucessfully!" );
				flash.put( "importLog", importLog );
			}
			else{
				cbMessagebox.error( "The import file is invalid: #rc.importFile# cannot continue with import" );
			}
		}
		catch(any e){
			var errorMessage = "Error importing file: #e.message# #e.detail# #e.stackTrace#";
			log.error( errorMessage, e );
			cbMessagebox.error( errorMessage );
		}
		setNextEvent( prc.xehAuthors );
	}

	/******************************************** PRIVATE ****************************************************/

	/**
	* List author preferences
	* @return view
	*/
	private function listPreferences( event, rc, prc ){
		// get editors for preferences
		prc.editors = editorService.getRegisteredEditors();
		// Get All registered markups so we can display them
		prc.markups = editorService.getRegisteredMarkups();
		// render out view
		return renderView( view="authors/listPreferences", module="contentbox-admin" );
	}
}
