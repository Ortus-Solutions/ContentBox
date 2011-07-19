/**
* BlogBox Admin module configuration
* Icon Themes: woothemesiconset, duesseldorf
*/
component {
	
	// Module Properties
	this.title 				= "BlogBox-Admin";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "A cool blogging engine administrator";
	this.version			= "1.0";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	// Module Entry Point: The SES entry point for blogbox: http://myapp/bbadmin
	this.entryPoint			= "bbadmin";
	
	function configure(){
	
		// BLOGBOX MODULE LOCATION: CHANGE IF DIFFERENT FROM CONVENTIONS
		var BB_PATH = controller.getSetting("modules").blogbox.invocationPath;
		
		// Layout Settings
		layoutSettings = { defaultLayout = "admin.cfm" };
		
		// SES Routes
		routes = [
			// Generic module route
			{pattern="/", handler="dashboard", action="index" },
			{pattern="/dashboard/reload/:targetModule", handler="dashboard", action="reload" },
			{pattern="/authors/page/:page",handler="authors"},
			{pattern="/entries/page/:page",handler="entries"},
			{pattern="/entries/pager/page/:page",handler="entries",action="pager"},
			{pattern="/:handler/:action?"}
		];		
		
		// Custom Declared Points
		interceptorSettings = {
			// BB Admin Custom Events
			customInterceptionPoints = arrayToList([
				"bbadmin_beforeHeadEnd","bbadmin_afterBodyStart","bbadmin_beforeBodyEnd","bbadmin_footer","bbadmin_beforeContent","bbadmin_afterContent", // Admin Layout HTML points
				"bbadmin_beforeLoginHeadEnd","bbadmin_afterLoginBodyStart","bbadmin_beforeLoginBodyEnd","bbadmin_loginFooter","bbadmin_beforeLoginContent","bbadmin_afterLoginContent", // Login Layout HTML points
				"bbadmin_beforeMainNav","bbadmin_afterMainNav", // Main Navigation
				"bbadmin_dashboardTab","bbadmin_entriesTab","bbadmin_authorsTab","bbadmin_systemTab" // Main Tabs
			])
		};
		
		// Custom Declared Interceptors
		interceptors = [
			// BB Admin Request Interceptor
			{class="#moduleMapping#.interceptors.BBRequest", properties={ entryPoint=this.entryPoint }, name="BBRequest@bbAdmin" },
			// BB Admin security
			{class="coldbox.system.interceptors.Security",properties={rulesSource="xml",rulesFile="#moduleMapping#/config/security.xml.cfm", validatorModel="securityService@bb"} }
		];
		
		// WireBox bindings
		
	}
	
	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		
	}
	
	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		
	}
	
}