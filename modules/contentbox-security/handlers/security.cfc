/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
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
	property name="securityService" inject="id:securityService@cb";
	property name="authorService" 	inject="id:authorService@cb";
	property name="antiSamy"		inject="coldbox:plugin:AntiSamy";
	property name="cb"				inject="cbhelper@cb";
	
	// Method Security
	this.allowedMethods = {
		doLogin = "POST",
		doLostPassword = "POST"
	};
	
	// login screen
	function login(event,rc,prc){
		// exit handlers
		prc.xehDoLogin 			= "#prc.cbAdminEntryPoint#.security.doLogin";
		prc.xehLostPassword 	= "#prc.cbAdminEntryPoint#.security.lostPassword";
		// remember me
		prc.rememberMe = antiSamy.htmlSanitizer( securityService.getRememberMe() );
		// secured URL from security interceptor
		arguments.event.paramValue("_securedURL", "");
		rc._securedURL = antiSamy.htmlSanitizer( rc._securedURL );
		// view
		event.setView(view="security/login");	
	}
	
	// authenticate users
	function doLogin(event,rc,prc){
		// params
		arguments.event.paramValue("rememberMe", false);
		arguments.event.paramValue("_securedURL", "");
		// announce event
		announceInterception("cbadmin_preLogin");
		
		// Sanitize
		rc.username 	= antiSamy.htmlSanitizer( rc.username );
		rc.password 	= antiSamy.htmlSanitizer( rc.password );
		rc.rememberMe 	= antiSamy.htmlSanitizer( rc.rememberMe );
		rc._securedURL 	= antiSamy.htmlSanitizer( rc._securedURL );
		
		// authenticate users
		if( securityService.authenticate( rc.username, rc.password ) ){
			// set remember me
			if( rc.rememberMe ){
				securityService.setRememberMe( rc.username );
			}
			
			// announce event
			announceInterception("cbadmin_onLogin");
		
			// check if securedURL came in?
			if( len( rc._securedURL ) ){
				setNextEvent( uri=rc._securedURL );
			}
			else{
				setNextEvent( "#prc.cbAdminEntryPoint#.dashboard" );
			}
		}
		else{
			// announce event
			announceInterception("cbadmin_onBadLogin");
			// message and redirect
			getPlugin("MessageBox").warn( cb.r( "invalid_credentials@security" ));
			// Relocate
			setNextEvent( "#prc.cbAdminEntryPoint#.security.login" );
		}
	}
	
	// logout users
	function doLogout(event,rc,prc){
		// logout
		securityService.logout();
		// announce event
		announceInterception("cbadmin_onLogout");
		// message redirect	
		getPlugin("MessageBox").info("See you later!");
		// relocate
		setNextEvent("#prc.cbAdminEntryPoint#.security.login");
	}
	
	// lost password screen
	function lostPassword(event,rc,prc){
		prc.xehLogin 			= "#prc.cbAdminEntryPoint#.security.login";
		prc.xehDoLostPassword 	= "#prc.cbAdminEntryPoint#.security.doLostPassword";
		event.setView(view="security/lostPassword");	
	}
	
	// do the lost password goodness
	function doLostPassword(event,rc,prc){
		var errors 	= [];
		var oAuthor = "";
		
		// Param email
		arguments.event.paramValue("email", "");

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
				getPlugin("MessageBox").info( cb.r( resource='messages.lostpassword_check', values="15" ) );
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
			getPlugin("MessageBox").info( cb.r( resource='messages.reminder_sent', values="15" ) );
		}
		else{
			// announce event
			announceInterception( "cbadmin_onInvalidPasswordReminder", { errors = errors, email = rc.email } );
			// messagebox
			getPlugin("MessageBox").error( messageArray=errors );
		}
		// Re Route
		setNextEvent( "#prc.cbAdminEntryPoint#.security.lostPassword" );
	}
	
	// Verify Reset
	function verifyReset(event,rc,prc){
		arguments.event.paramValue("token", "");

		// Validate token
		var results = securityService.resetUserPassword( trim( rc.token ) );
		if( !results.error ){
			// announce event
			announceInterception( "cbadmin_onPasswordReset", { author = results.author } );
			// Messagebox
			getPlugin("MessageBox").info( cb.r( "messages.password_reset@security" ) );
		}
		else{
			// announce event
			announceInterception( "cbadmin_onInvalidPasswordReset", { token = rc.token } );
			// messagebox
			getPlugin("MessageBox").error( cb.r( "messages.invalid_token@security" ) );
		}
		
		// Relcoate to login
		setNextEvent( "#prc.cbAdminEntryPoint#.security.lostPassword" );
	}
	
}