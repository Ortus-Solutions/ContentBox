/**
* ContentBOx security
*/
component{

	// DI
	property name="securityService" inject="id:securityService@cb";
	property name="authorService" 	inject="id:authorService@cb";
	
	// login screen
	function login(event,rc,prc){
		// exit handlers
		rc.xehDoLogin 		= "#prc.cbAdminEntryPoint#.security.doLogin";
		rc.xehLostPassword 	= "#prc.cbAdminEntryPoint#.security.lostPassword";
		// remember me
		prc.rememberMe = securityService.getRememberMe();
		// view
		event.setView(view="security/login",layout="simple");	
	}
	
	// authenticate users
	function doLogin(event,rc,prc){
		// params
		event.paramValue("rememberMe",false);
		// announce event
		announceInterception("cbadmin_preLogin");
		
		// authenticate users
		if( securityService.authenticate(rc.username,rc.password) ){
			// set remember me
			if( rc.rememberMe ){
				securityService.setRememberMe( rc.username );
			}
			
			// announce event
			announceInterception("cbadmin_onLogin");
		
			// check if securedURL came in?
			if( len(event.getValue("_securedURL","")) ){
				setNextEvent(uri=rc["_securedURL"]);
			}
			else{
				setNextEvent("#prc.cbAdminEntryPoint#.dashboard");
			}
		}
		else{
			// announce event
			announceInterception("cbadmin_onBadLogin");
			// message and redirect
			getPlugin("MessageBox").warn("Invalid Credentials, try it again!");
			setNextEvent("#prc.cbAdminEntryPoint#.security.login");
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
		setNextEvent("#prc.cbAdminEntryPoint#.security.login");
	}
	
	// lost password screen
	function lostPassword(event,rc,prc){
		prc.xehLogin 			= "#prc.cbAdminEntryPoint#.security.login";
		rc.xehDoLostPassword 	= "#prc.cbAdminEntryPoint#.security.doLostPassword";
		event.setView(view="security/lostPassword",layout="simple");	
	}
	
	// do the lost password goodness
	function doLostPassword(event,rc,prc){
		var errors 	= [];
		var oAuthor = "";
		
		// Param email
		event.paramValue("email","");
		
		// Validate email
		if( NOT trim(rc.email).length() ){
			arrayAppend(errors,"Please enter an email address<br />");	
		}
		else{
			// Try To get the Author
			oAuthor = authorService.findWhere({email=rc.email});
			if( isNull(oAuthor) OR NOT oAuthor.isLoaded() ){
				arrayAppend(errors,"The email address is invalid!<br />");
			}
		}			
		
		// Check if Errors
		if( NOT arrayLen(errors) ){
			// Send Reminder
			securityService.sendPasswordReminder( oAuthor );
			// announce event
			announceInterception("cbadmin_onPasswordReminder",{author=oAuthor});
			// messagebox
			getPlugin("MessageBox").info("Password reminder sent! Please try to log in with your new password.");
		}
		else{
			// announce event
			announceInterception("cbadmin_onInvalidPasswordReminder",{errors=errors,author=oAuthor});
			// messagebox
			getPlugin("MessageBox").error(messageArray=errors);
		}
		// Re Route
		setNextEvent("#prc.cbAdminEntryPoint#.security.login");
	}
	
}