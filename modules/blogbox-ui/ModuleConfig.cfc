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
	// YOUR SES URL ENTRY POINT /blog is a perfect example
	this.entryPoint			= "blog";
	
	function configure(){
		
		// BB UI Module Conventions
		conventions = {
			layoutsLocation = "layouts",
			viewsLocation 	= "layouts"
		};

		// BLOGBOX MODULE LOCATION: CHANGE IF DIFFERENT FROM CONVENTIONS
		var BB_PATH = controller.getSetting("modules").blogbox.invocationPath;
		
		// BB UI SES Routing
		routes = [
			// home
			{pattern="/", handler="blog", action="index" },
			// paging
			{pattern="/p/:page-numeric", handler="blog", action="index" },
			// category filter
			{pattern="/category/:category/:page-numeric?", handler="blog", action="index" },
			// search filter
			{pattern="/search/:q?/:page-numeric?", handler="blog", action="index" },
			// blog permalink
			{pattern="/:slug", handler="blog", action="entry" }
			
		];		
		
		// BB UI Event driven programming extensions
		interceptorSettings = {
			// BlogBox UI Custom Events, you can add your own if you like to!
			customInterceptionPoints = arrayToList([
				// Layout HTML points: A layout must announce them via bb.event("bbui_footer",{renderer=this}) make sure you pass in the renderer
				"bbui_beforeHeadEnd","bbui_afterBodyStart","bbui_beforeBodyEnd","bbui_footer","bbui_beforeContent","bbui_afterContent","bbui_beforeSideBar","bbui_afterSideBar"
			])
		};
		
		// BB UI Interceptors
		interceptors = [
			// BB UI Request Interceptor
			{class="#moduleMapping#.interceptors.BBRequest", properties={ entryPoint=this.entryPoint }, name="BBRequest@bbUI" }
		];
		
	}
	
	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// TODO: Register currently selected layout's interception points
	}
	
	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		// TODO: UnRegister currently selected layout's interception points
	}
	
}