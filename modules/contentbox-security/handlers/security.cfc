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
* ContentBox security handler
*/
component{

	// DI
	property name="securityService" inject="securityService@cb";
	property name="authorService" 	inject="authorService@cb";
	property name="antiSamy"		inject="coldbox:plugin:AntiSamy";
	property name="cb"				inject="cbhelper@cb";
	property name="messagebox"		inject="coldbox:plugin:MessageBox";

	// Method Security
	this.allowedMethods = {
		doLogin = "POST",
		doLostPassword = "POST"
	};

	function preHandler( event, currentAction, rc, prc ){
		prc.langs 		= getModuleSettings( "contentbox" ).settings.languages;
		prc.entryPoint 	= getModuleSettings( "contentbox-security" ).entryPoint;
		prc.xehLang 	= event.buildLink( "#prc.entryPoint#/language" );
	}

	function changeLang( event, rc, prc ){
		event.paramValue( "lang", "en_US" );
		setFWLocale( rc.lang );
		setNextEvent( prc.entryPoint );
	}

	function login( event, rc, prc ){
		// exit handlers
		prc.xehDoLogin 			= "#prc.cbAdminEntryPoint#.security.doLogin";
		prc.xehLostPassword 	= "#prc.cbAdminEntryPoint#.security.lostPassword";
		// remember me
		prc.rememberMe = antiSamy.htmlSanitizer( securityService.getRememberMe() );
		// secured URL from security interceptor
		arguments.event.paramValue( "_securedURL", "" );
		rc._securedURL = antiSamy.htmlSanitizer( rc._securedURL );
		// view
		event.setView( view="security/login" );
	}

	function doLogin( event, rc, prc ){
		// params
		event.paramValue( "rememberMe", 0 )
			.paramValue( "_securedURL", "" );

		// Sanitize
		rc.username 	= antiSamy.htmlSanitizer( rc.username );
		rc.password 	= antiSamy.htmlSanitizer( rc.password );
		rc.rememberMe 	= antiSamy.htmlSanitizer( rc.rememberMe );
		rc._securedURL 	= antiSamy.htmlSanitizer( rc._securedURL );

		// announce event
		announceInterception( "cbadmin_preLogin" );

		// authenticate users
		if( securityService.authenticate( rc.username, rc.password ) ){
			// set remember me
			securityService.setRememberMe( rc.username, val( rc.rememberMe ) );
			// announce event
			announceInterception( "cbadmin_onLogin" );
			// check if securedURL came in?
			if( len( rc._securedURL ) ){
				setNextEvent( uri=rc._securedURL );
			} else {
				setNextEvent( "#prc.cbAdminEntryPoint#.dashboard" );
			}
		} else {
			// announce event
			announceInterception( "cbadmin_onBadLogin" );
			// message and redirect
			messagebox.warn( cb.r( "messages.invalid_credentials@security" ));
			// Relocate
			setNextEvent( "#prc.cbAdminEntryPoint#.security.login" );
		}
	}

	function doLogout( event, rc, prc ){
		// logout
		securityService.logout();
		// announce event
		announceInterception( "cbadmin_onLogout" );
		// message redirect
		messagebox.info( cb.r( "messages.seeyou@security" ) );
		// relocate
		setNextEvent( "#prc.cbAdminEntryPoint#.security.login" );
	}

	function lostPassword( event, rc, prc ){
		prc.xehLogin 			= "#prc.cbAdminEntryPoint#.security.login";
		prc.xehDoLostPassword 	= "#prc.cbAdminEntryPoint#.security.doLostPassword";

		event.setView( view="security/lostPassword" );
	}

	function doLostPassword( event, rc, prc ){
		var errors 	= [];
		var oAuthor = "";

		// Param email
		event.paramValue( "email", "" );

		rc.email = antiSamy.htmlSanitizer( rc.email );

		// Validate email
		if( NOT trim( rc.email ).length() ){
			arrayAppend( errors, "#cb.r( 'validation.need_email@security' )#<br />" );
		}
		else{
			// Try To get the Author
			oAuthor = authorService.findWhere( { email = rc.email } );
			if( isNull( oAuthor ) OR NOT oAuthor.isLoaded() ){
				// Don't give away that the email did not exist.
				messagebox.info( cb.r( resource='messages.lostpassword_check@security', values="5" ) );
				setNextEvent( "#prc.cbAdminEntryPoint#.security.lostPassword" );
			}
		}

		// Check if Errors
		if( NOT arrayLen( errors ) ){
			// Send Reminder
			securityService.sendPasswordReminder( oAuthor );
			// announce event
			announceInterception( "cbadmin_onPasswordReminder", { author = oAuthor } );
			// messagebox
			messagebox.info( cb.r( resource='messages.reminder_sent@security', values="15" ) );
		}
		else{
			// announce event
			announceInterception( "cbadmin_onInvalidPasswordReminder", { errors = errors, email = rc.email } );
			// messagebox
			messagebox.error( messageArray=errors );
		}
		// Re Route
		setNextEvent( "#prc.cbAdminEntryPoint#.security.lostPassword" );
	}

	function verifyReset( event, rc, prc ){
		arguments.event.paramValue("token", "");

		// Validate token
		var results = securityService.resetUserPassword( trim( rc.token ) );
		if( !results.error ){
			// announce event
			announceInterception( "cbadmin_onPasswordReset", { author = results.author } );
			// Messagebox
			messagebox.info( cb.r( "messages.password_reset@security" ) );
		}
		else{
			// announce event
			announceInterception( "cbadmin_onInvalidPasswordReset", { token = rc.token } );
			// messagebox
			messagebox.error( cb.r( "messages.invalid_token@security" ) );
		}

		// Relcoate to login
		setNextEvent( "#prc.cbAdminEntryPoint#.security.lostPassword" );
	}

}