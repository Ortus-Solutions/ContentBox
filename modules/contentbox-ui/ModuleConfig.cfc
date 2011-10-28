/**
* ContentBox UI module configuration
*/
component {
	
	// Module Properties
	this.title 				= "contentbox-ui";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "ContentBox UI Module";
	this.version			= "1.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// YOUR SES URL ENTRY POINT blog is a perfect example or empty if the Blog will be the main application
	this.entryPoint			= "";
	
	function configure(){
		
		// CB UI SES Routing
		routes = [
			// Blog Archives
			{pattern="/blog/archives/:year-numeric{4}?/:month-numeric{1,2}?/:day-numeric{1,2}?", handler="blog", action="archives"},
			// Blog RSS feeds
			{pattern="/blog/rss/category/:category", handler="blog", action="rss" },
			{pattern="/blog/rss/comments/:entrySlug?", handler="blog", action="rss", commentRSS=true},
			{pattern="/blog/rss/", handler="blog", action="rss" },
			// category filter
			{pattern="/blog/category/:category/:page-numeric?", handler="blog", action="index" },
			// search filter
			{pattern="/blog/search/:q?/:page-numeric?", handler="blog", action="index" },
			// Blog comment post
			{pattern="/blog/:entrySlug/commentPost", handler="blog", action="commentPost" },
			// blog permalink
			{pattern="/blog/:entrySlug", handler="blog", action="entry"},
			// Blog reserved route
			{pattern="/blog", handler="blog", action="index" },
			// preview
			{pattern="/__preview", handler="blog", action="preview" },
			// page permalink, discovery of nested pages is done here, the aboved slugs are reserved.
			{pattern="/__pageCommentPost", handler="page", action="commentPost"},
			{pattern="/:pageSlug", handler="page", action="index"},
			// Home Pattern  xc
			{pattern="/", handler="blog", action="index" }
		];	
		
		// CB UI Module Conventions
		conventions = {
			layoutsLocation = "layouts",
			viewsLocation 	= "layouts"
		};
		
		// CB UI Event driven programming extensions
		interceptorSettings = {
			// ContentBox UI Custom Events, you can add your own if you like to!
			customInterceptionPoints = arrayToList([
				// Layout HTML points: A layout must announce them via cb.event("cbui_footer",{renderer=this}) make sure you pass in the renderer
				"cbui_beforeHeadEnd","cbui_afterBodyStart","cbui_beforeBodyEnd","cbui_footer","cbui_beforeContent","cbui_afterContent","cbui_beforeSideBar","cbui_afterSideBar",
				// Code Interception points
				"cbui_onPageNotFound","cbui_onEntryNotFound","cbui_onError","cbui_preRequest","cbui_postRequest","cbui_onRendererDecoration",
				// Fixed Handler Points
				"cbui_onIndex","cbui_onArchives","cbui_onEntry","cbui_onPage","cbui_preCommentPost","cbui_onCommentPost",
				// Fixed HTML Points
				"cbui_preEntryDisplay","cbui_postEntryDisplay","cbui_preIndexDisplay","cbui_postIndexDisplay","cbui_preCommentForm","cbui_postCommentForm",
				"cbui_prePageDisplay","cbui_postPageDisplay","cbui_preArchivesDisplay","cbui_postArchivesDisplay"
			])
		};
		
		// CB UI Interceptors
		interceptors = [
			// CB UI Request Interceptor
			{class="#moduleMapping#.interceptors.CBRequest", properties={ entryPoint=this.entryPoint }, name="CBRequest@cbUI" },
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
			var parentRoutes 		= ses.getRoutes();
			var parentModuleRoutes = [];
			
			// iterate and only keep module routing
			for(var x=1; x lte arrayLen(parentRoutes); x++){
				if( len( parentRoutes[x].moduleRouting ) ){
					arrayAppend( parentModuleRoutes, parentRoutes[x] );
				}
			}
			
			// clean routes
			ses.setRoutes( parentModuleRoutes );			
			
			// Add routes manually to take over parent routes
			for(var x=1; x LTE arrayLen(variables.routes); x++){
				// append module location to it so the route is now system wide
				var args = duplicate(variables.routes[x]);
				// Check if handler defined
				if( structKeyExists(args,"handler") ){
					args.handler = "contentbox-ui:#args.handler#";
				}
				// add it as main application route.
				ses.addRoute(argumentCollection=args);
			}
			// Load back the parent routes at the end now.
			ses.getRoutes().addAll( parentRoutes );
			
			// change the default event
			controller.setSetting("DefaultEvent","contentbox-ui:blog");
		}
	}
		
}