/**
* BlogBox UI module configuration
*/
component {
	
	// Module Properties
	this.title 				= "blogbox-ui";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "BlogBox UI Module";
	this.version			= "1.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// YOUR SES URL ENTRY POINT
	this.entryPoint			= "/blog";
	
	function configure(){
		
		// Module Conventions
		conventions = {
			layoutsLocation = "layouts",
			viewsLocation 	= "layouts"
		};

		// BLOGBOX MODULE LOCATION: CHANGE IF DIFFERENT FROM CONVENTIONS
		var BB_PATH = controller.getSetting("modules").blogbox.invocationPath;
		
		// SES Routes
		routes = [
			{pattern="/", handler="blog", action="index" }
		];		
		
		// Custom Declared Points
		interceptorSettings = {
			// BB Admin Custom Events
			customInterceptionPoints = arrayToList([
				"bbui_beforeHeadEnd","bbui_afterBodyStart","bbui_beforeBodyEnd","bbui_footer","bbui_beforeContent","bbui_afterContent" // Layout HTML points
			])
		};
		
		// Custom Declared Interceptors
		interceptors = [
			// BB UI Request Interceptor
			{class="#moduleMapping#.interceptors.BBRequest", properties={ entryPoint=this.entryPoint }, name="BBRequest@bbUI" }
		];
		
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