/**
* ContentBOx security
*/
component{

	// DI
	property name="securityService" inject="id:securityService@cb";
	property name="authorService" 	inject="id:authorService@cb";
	property name="antiSamy"		inject="coldbox:plugin:AntiSamy";
	
	// login screen
	function login(event,rc,prc){
		// exit handlers
		prc.xehDoLogin 		= "#prc.cbAdminEntryPoint#.security.doLogin";
		prc.xehLostPassword 	= "#prc.cbAdminEntryPoint#.security.lostPassword";
		// remember me
		prc.rememberMe = antiSamy.htmlSanitizer( securityService.getRememberMe() );
		// secured URL from security interceptor
		arguments.event.paramValue("_securedURL", "");
		rc._securedURL = antiSamy.htmlSanitizer( rc._securedURL );
		// view
		event.setView(view="security/login",layout="simple");	
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
			getPlugin("MessageBox").warn("Invalid Credentials, try it again!");
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
		event.setView(view="security/lostPassword",layout="simple");	
	}
	
	// do the lost password goodness
	function doLostPassword(event,rc,prc){
		var errors 	= [];
		var oAuthor = "";
		
		// Param email
		arguments.event.paramValue("email", "");

		rc.email 	= antiSamy.htmlSanitizer( rc.email );
		
		// Validate email
		if( NOT trim( rc.email ).length() ){
			arrayAppend( errors, "Please enter an email address<br />" );	
		}
		else{
			// Try To get the Author
			oAuthor = authorService.findWhere( { email = rc.email } );
			if( isNull( oAuthor ) OR NOT oAuthor.isLoaded() ){
				arrayAppend( errors, "The email address is invalid!<br />" );
			}
		}			
		
		// Check if Errors
		if( NOT arrayLen( errors ) ){
			// Send Reminder
			securityService.sendPasswordReminder( oAuthor );
			// announce event
			announceInterception( "cbadmin_onPasswordReminder", { author = oAuthor } );
			// messagebox
			getPlugin("MessageBox").info( "Password reminder sent! Please check your inbox for our reset email that must be used within the next 15 minutes" );
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
			getPlugin("MessageBox").info( "Wohoo! Your password has been reset and you will receive an email with your new security password." );
		}
		else{
			// announce event
			announceInterception( "cbadmin_onInvalidPasswordReset", { token = rc.token } );
			// messagebox
			getPlugin("MessageBox").error( "The security reset token passed is invalid or has expired." );
		}
		
		// Relcoate to login
		setNextEvent( "#prc.cbAdminEntryPoint#.security.lostPassword" );
	}
	
}