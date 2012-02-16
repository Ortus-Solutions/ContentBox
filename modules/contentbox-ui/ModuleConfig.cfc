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
* ContentBox UI module configuration
*/
component {
	
	// Module Properties
	this.title 				= "contentbox-ui";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "ContentBox UI Module";
	this.version			= "1.0";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	
	// YOUR SES URL ENTRY POINT FOR CONTENTBOX, IF EMPTY IT WILL TAKE OVER THE ENTIRE APPLICATION
	// IF YOU WANT TO SECTION OFF CONTENTBOX THEN FILL OUT AN SES ENTRY POINT LIKE /site OR /content
	// BY DEFAULT IT TAKES OVER THE ENTIRE APPLICATION
	this.entryPoint			= "";
	
	function configure(){
		
		// PARENT APPLICATION ROUTING IF IN TAKE OVER MODE. YOU CAN CUSTOMIZE THIS IF YOU LIKE.
		// THIS MEANS THAT IF YOU WANT TO EXECUTE PARENT EVENTS YOU NEED TO PREFIX THEM WITH '/parent'
		parentSESPrefix = "/parent";
		
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
			// search filter
			{pattern="/__search/:q?/:page-numeric?", handler="page", action="search" },
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
				"cbui_onPageNotFound","cbui_onEntryNotFound","cbui_onError","cbui_preRequest","cbui_postRequest","cbui_onRendererDecoration","cbui_onContentSearch",
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
			// Simple Security For pages and blog entries
			{class="#moduleMapping#.interceptors.SimpleSecurity",name="SimpleSecurity@cb"},
			// Global HTML interceptor for rendering HTML Points
			{class="#moduleMapping#.interceptors.GlobalHTML",name="GlobalHTML@cb"}
		];
		
	}
	
	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// Startup the ContentBox layout service and activate the current layout
		controller.getWireBox().getInstance("layoutService@cb").startupActiveLayout();
		
		// Treat the blog as the Main Application?
		if( !len(this.entryPoint) ){
			// generate the ses entry point
			var ses 		 = controller.getInterceptorService().getInterceptor('SES',true);
			
			// get parent routes so we can re-mix them later
			var parentRoutes 		= ses.getRoutes();
			var newRoutes			= [];
			
			// iterate and only keep module routing
			for(var x=1; x lte arrayLen(parentRoutes); x++){
				if( parentRoutes[x].pattern NEQ ":handler/" AND
				    parentRoutes[x].pattern NEQ ":handler/:action/" ){
					arrayAppend(newRoutes, parentRoutes[x]);
				}
			}
			// override new cleaned routes
			ses.setRoutes( newRoutes );			
			
			// Add parent routing
			ses.addRoute(pattern="#variables.parentSESPrefix#/:handler/:action?");
			
			// Add routes manually to take over parent routes
			for(var x=1; x LTE arrayLen( variables.routes ); x++){
				// append module location to it so the route is now system wide
				var args = duplicate( variables.routes[x] );
				// Check if handler defined
				if( structKeyExists(args,"handler") ){
					args.handler = "contentbox-ui:#args.handler#";
				}
				// add it as main application route.
				ses.addRoute(argumentCollection=args);
			}
			
			// change the default event
			controller.setSetting("DefaultEvent","contentbox-ui:blog");
		}
	}
		
}