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
	// YOUR SES URL ENTRY POINT blog is a perfect example or empty if the Blog will be the main application
	this.entryPoint			= "";
	
	function configure(){
		
		// BB UI Module Conventions
		conventions = {
			layoutsLocation = "layouts",
			viewsLocation 	= "layouts"
		};
		
		// BB UI SES Routing
		routes = [
			// home
			{pattern="/", handler="blog", action="index" },
			// Blog reserved route
			{pattern="/blog", handler="blog", action="index" },
			// Blog Archives
			{pattern="/archives/:year-numeric{4}?/:month-numeric{1,2}?/:day-numeric{1,2}?", handler="blog", action="archives"},
			// preview
			{pattern="/__preview", handler="blog", action="preview" },
			// RSS feeds
			{pattern="/rss/category/:category", handler="blog", action="rss" },
			{pattern="/rss/comments/:entrySlug?", handler="blog", action="rss", commentRSS=true},
			{pattern="/rss/", handler="blog", action="rss" },
			// Comment post
			{pattern="/commentPost", handler="blog", action="commentPost" },
			// category filter
			{pattern="/category/:category/:page-numeric?", handler="blog", action="index" },
			// search filter
			{pattern="/search/:q?/:page-numeric?", handler="blog", action="index" },
			// blog permalink
			{pattern="/entry/:entrySlug", handler="blog", action="entry"},
			// page permalink, discovery of nested pages is done here, the aboved slugs are reserved.
			{pattern="/:pageSlug", handler="blog", action="page"}
		];		
		
		// BB UI Event driven programming extensions
		interceptorSettings = {
			// BlogBox UI Custom Events, you can add your own if you like to!
			customInterceptionPoints = arrayToList([
				// Layout HTML points: A layout must announce them via bb.event("bbui_footer",{renderer=this}) make sure you pass in the renderer
				"bbui_beforeHeadEnd","bbui_afterBodyStart","bbui_beforeBodyEnd","bbui_footer","bbui_beforeContent","bbui_afterContent","bbui_beforeSideBar","bbui_afterSideBar",
				// Code Interception points
				"bbui_onPageNotFound","bbui_onEntryNotFound","bbui_onError","bbui_preRequest","bbui_postRequest","bbui_onRendererDecoration",
				// Fixed Handler Points
				"bbui_onIndex","bbui_onArchives","bbui_onEntry","bbui_onPage","bbui_preCommentPost","bbui_onCommentPost",
				// Fixed HTML Points
				"bbui_preEntryDisplay","bbui_postEntryDisplay","bbui_preIndexDisplay","bbui_postIndexDisplay","bbui_preCommentForm","bbui_postCommentForm",
				"bbui_prePageDisplay","bbui_postPageDisplay","bbui_preArchivesDisplay","bbui_postArchivesDisplay"
			])
		};
		
		// BB UI Interceptors
		interceptors = [
			// BB UI Request Interceptor
			{class="#moduleMapping#.interceptors.BBRequest", properties={ entryPoint=this.entryPoint }, name="BBRequest@bbUI" },
			// Simple Security
			{class="#moduleMapping#.interceptors.SimpleSecurity"}
		];
		
	}
	
	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// Treat the blog as the Main Application?
		if( !len(this.entryPoint) ){
			// generate the ses entry point
			var ses 		 = controller.getInterceptorService().getInterceptor('SES',true);
			// get parent routes so we can re-mix them later
			var parentRoutes = ses.getRoutes();
			
			// clean routes
			ses.setRoutes( [] );			
			
			// Add routes manually to take over parent routes
			for(var x=1; x LTE arrayLen(variables.routes); x++){
				// append module location to it so the route is now system wide
				var args = duplicate(variables.routes[x]);
				// Check if handler defined
				if( structKeyExists(args,"handler") ){
					args.handler = "blogbox-ui:#args.handler#";
				}
				// add it as main application route.
				ses.addRoute(argumentCollection=args);
			}
			// Load back the parent routes at the end now.
			ses.getRoutes().addAll( parentRoutes );
			
			// change the default event
			controller.setSetting("DefaultEvent","blogbox-ui:blog");
		}
	}
		
}