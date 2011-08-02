/**
* BlogBox security
*/
component{

	// DI
	property name="securityService" inject="id:securityService@bb";
	property name="authorService" 	inject="id:authorService@bb";
	
	// login screen
	function login(event,rc,prc){
		rc.xehDoLogin 		= "#prc.bbEntryPoint#.security.doLogin";
		rc.xehLostPassword 	= "#prc.bbEntryPoint#.security.lostPassword";
		event.setView(view="security/login",layout="login");	
	}
	
	// authenticate users
	function doLogin(event,rc,prc){
		// announce event
		announceInterception("bbadmin_preLogin");
		
		// authenticate users
		if( securityService.authenticate(rc.username,rc.password) ){
			// announce event
			announceInterception("bbadmin_onLogin");
		
			// check if securedURL came in?
			if( len(event.getValue("_securedURL","")) ){
				setNextEvent(uri=rc["_securedURL"]);
			}
			else{
				setNextEvent("#prc.bbEntryPoint#.dashboard");
			}
		}
		else{
			// announce event
			announceInterception("bbadmin_onBadLogin");
			// message and redirect
			getPlugin("MessageBox").warn("Invalid Credentials, try it again!");
			setNextEvent("#prc.bbEntryPoint#.security.login");
		}
	}
	
	// logout users
	function doLogout(event,rc,prc){
		// logout
		securityService.logout();
		// announce event
		announceInterception("bbadmin_onLogout");
		// message redirect	
		getPlugin("MessageBox").info("See you later!");
		setNextEvent("#prc.bbEntryPoint#.security.login");
	}
	
	// lost password screen
	function lostPassword(event,rc,prc){
		rc.xehLogin 			= "#prc.bbEntryPoint#.security.login";
		rc.xehDoLostPassword 	= "#prc.bbEntryPoint#.security.doLostPassword";
		event.setView(view="security/lostPassword",layout="login");	
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
			announceInterception("bbadmin_onPasswordReminder",{author=oAuthor});
			// messagebox
			getPlugin("MessageBox").info("Password reminder sent!");
		}
		else{
			// announce event
			announceInterception("bbadmin_onInvalidPasswordReminder",{errors=errors,author=oAuthor});
			// messagebox
			getPlugin("MessageBox").error(messageArray=errors);
		}
		// Re Route
		setNextEvent("#prc.bbEntryPoint#.security.lostPassword");
	}
	
}