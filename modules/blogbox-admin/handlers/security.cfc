/**
* BlogBox security
*/
component{

	// DI
	property name="securityService" inject="id:securityService@bb";
	
	function login(event,rc){
		rc.xehDoLogin 		= "#rc.bbEntryPoint#.security.doLogin";
		rc.xehLostPassword 	= "#rc.bbEntryPoint#.security.lostPassword";
		event.setView(view="security/login",layout="login");	
	}
	
	function doLogin(event,rc){
		if( securityService.authenticate(rc.username,rc.password) ){
			setNextEvent("#rc.bbEntryPoint#.dashboard");
		}
		else{
			getPlugin("MessageBox").warn("Invalid Credentials, try it again!");
			setNextEvent("#rc.bbEntryPoint#.security.login");
		}
	}
	
	function doLogout(event,rc){
		securityService.logout();
		getPlugin("MessageBox").info("See you later!");
		setNextEvent("#rc.bbEntryPoint#.security.login");
	}
	
	function lostPassword(event,rc){
		rc.xehLogin 			= "#rc.bbEntryPoint#.security.login";
		rc.xehDoLostPassword 	= "#rc.bbEntryPoint#.security.doLostPassword";
		event.setView(view="security/lostPassword",layout="login");	
	}
	
	function doLostPassword(event,rc){
		
	}
	
}