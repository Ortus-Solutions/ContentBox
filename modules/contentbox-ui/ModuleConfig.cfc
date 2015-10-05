/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License" );
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
	this.version			= "3.0.0-beta+@build.number@";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;

	// YOUR SES URL ENTRY POINT FOR CONTENTBOX, IF EMPTY IT WILL TAKE OVER THE ENTIRE APPLICATION
	// IF YOU WANT TO SECTION OFF CONTENTBOX THEN FILL OUT AN SES ENTRY POINT LIKE /site OR /content
	// BY DEFAULT IT TAKES OVER THE ENTIRE APPLICATION
	this.entryPoint	= "";

	function configure(){

		// PARENT APPLICATION ROUTING IF IN TAKE OVER MODE. YOU CAN CUSTOMIZE THIS IF YOU LIKE.
		// THIS MEANS THAT IF YOU WANT TO EXECUTE PARENT EVENTS YOU NEED TO PREFIX THEM WITH '/parent'
		parentSESPrefix = "/parent";

		// CB UI SES Routing
		routes = [
			/************************************** COMMAND ROUTES *********************************************/
			// search filter
			{pattern="/__search/:q?/:page-numeric?", handler="page", action="search" },
			// layout preview
			{pattern="/__preview", handler="content", action="previewSite" },
			// entry preview
			{pattern="/__entry_preview", handler="blog", action="preview" },
			// page preview
			{pattern="/__page_preview", handler="page", action="preview" },
			// media delivery
			{pattern="/__media", handler="media", action="index"},
			// captcha delivery
			{pattern="/__captcha", handler="media", action="captcha"},
			// subscribe link
			{pattern="/__subscribe", handler="subscription", action="subscribe"},
			// manage subscriptions
			{pattern="/__subscriptions/:subscribertoken", handler="subscription", action="getSubscriptions"},
			// remove subscriptions
			{pattern="/__removesubscriptions/", handler="subscription", action="removeSubscriptions"},
			// unsubscribe link for single subscription
			{pattern="/__unsubscribe/:subscriptionToken", handler="subscription", action="unsubscribe" },

			/************************************** RSS ROUTES *********************************************/

			// Global Page RSS feeds with filtering
			{pattern="/__rss/pages/category/:category?", handler="rss", action="pages" },
			{pattern="/__rss/pages/comments/:slug?", handler="rss", action="pages", commentRSS=true },
			{pattern="/__rss/pages/", handler="rss", action="pages"},
			// Site Global RSS feeds Filtered by Categories
			{pattern="/__rss/category/:category", handler="rss", action="index" },
			// Global Site RSS Comments Feed With an extra content slug
			{pattern="/__rss/comments", handler="rss", action="index", commentRSS=true},
			// Global Site RSS Content Feed
			{pattern="/__rss", handler="rss", action="index" },

			/************************************** CATCH ALL PAGE ROUTE *********************************************/
	
			// page permalink, discovery of nested pages is done here, the aboved slugs are reserved.
			{pattern="/__pageCommentPost", handler="page", action="commentPost"},
			// Catch All Page Routing
			{pattern="/:pageSlug", handler="page", action="index"},
			// Home Pattern
			{pattern="/", handler="blog", action="index" }
		];
		
		/************************************** BLOG ROUTES NAMESPACE *********************************************/
		
		blogRoutes = [
			// Blog Archives
			{pattern="/archives/:year-numeric{4}?/:month-numeric{1,2}?/:day-numeric{1,2}?", handler="blog", action="archives", namespace="blog"},
			// Blog RSS feeds
			{pattern="/rss/category/:category", handler="blog", action="rss" , namespace="blog"},
			{pattern="/rss/comments/:entrySlug?", handler="blog", action="rss", commentRSS=true, namespace="blog"},
			{pattern="/rss/", handler="blog", action="rss" , namespace="blog"},
			// category filter
			{pattern="/category/:category/:page-numeric?", handler="blog", action="index" , namespace="blog"},
			// search filter
			{pattern="/search/:q?/:page-numeric?", handler="blog", action="index" , namespace="blog"},
			// Blog comment post
			{pattern="/:entrySlug/commentPost", handler="blog", action="commentPost" , namespace="blog"},
			// blog permalink
			{pattern="/:entrySlug", handler="blog", action="entry", namespace="blog"},
			// Blog reserved route
			{pattern="/", handler="blog", action="index", namespace="blog"}
		];

		// CB UI Event driven programming extensions
		interceptorSettings = {
			// ContentBox UI Custom Events, you can add your own if you like to!
			customInterceptionPoints = arrayToList([
				// Layout HTML points: A layout must announce them via cb.event( "cbui_footer",{renderer=this} ) make sure you pass in the renderer
				"cbui_beforeHeadEnd","cbui_afterBodyStart","cbui_beforeBodyEnd","cbui_footer","cbui_beforeContent","cbui_afterContent","cbui_beforeSideBar","cbui_afterSideBar",
				// Code Interception points
				"cbui_onPageNotFound","cbui_onEntryNotFound","cbui_onError","cbui_preRequest","cbui_postRequest","cbui_onRendererDecoration","cbui_onContentSearch",
				// Fixed Handler Points
				"cbui_onIndex","cbui_onArchives","cbui_onEntry","cbui_onPage","cbui_preCommentPost","cbui_onCommentPost","cbui_onCommentModerationRules",
				// Fixed HTML Points
				"cbui_preEntryDisplay","cbui_postEntryDisplay","cbui_preIndexDisplay","cbui_postIndexDisplay","cbui_preCommentForm","cbui_postCommentForm",
				"cbui_prePageDisplay","cbui_postPageDisplay","cbui_preArchivesDisplay","cbui_postArchivesDisplay",
				// Media Services
				"cbui_onInvalidMedia", "cbui_onMediaRequest"
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
		// Startup the ContentBox theme service and activate the current layout
		controller.getWireBox().getInstance( "themeService@cb" ).startupActiveTheme();
		// Get ses handle
		var ses = controller.getInterceptorService().getInterceptor('SES',true);
		
		// Add Dynamic Blog Namespace
		registerBlogNamespace();
		
		// Treat the blog as the Main Application?
		if( !len(this.entryPoint) ){
			
			// get parent routes so we can re-mix them later
			var parentRoutes 		= ses.getRoutes();
			var newRoutes			= [];

			// iterate and only keep module routing
			for(var x=1; x lte arrayLen(parentRoutes); x++){
				if( parentRoutes[ x ].pattern NEQ ":handler/" AND
				    parentRoutes[ x ].pattern NEQ ":handler/:action/" ){
					arrayAppend(newRoutes, parentRoutes[ x ]);
				}
			}
			// override new cleaned routes
			ses.setRoutes( newRoutes );

			// Add parent routing
			ses.addRoute(pattern="#variables.parentSESPrefix#/:handler/:action?" );
			
			// Add routes manually to take over parent routes
			for(var x=1; x LTE arrayLen( variables.routes ); x++){
				// append module location to it so the route is now system wide
				var args = duplicate( variables.routes[ x ] );
				// Check if handler defined
				if( structKeyExists(args,"handler" ) ){
					args.handler = "contentbox-ui:#args.handler#";
				}
				// add it as main application route.
				ses.addRoute(argumentCollection=args);
			}
			// change the default event of the entire app
			controller.setSetting( "DefaultEvent","contentbox-ui:blog" );
		}		
	}
	
	/**
	* Register blog namespace routes
	*/
	private function registerBlogNamespace(){
		// Get ses handle
		var ses = controller.getInterceptorService().getInterceptor('SES',true);
		// Get setting service
		var settingService = controller.getWireBox().getInstance( "settingService@cb" );
		// Get blog entry point from DB
		var blogEntryPoint = settingService.findWhere( {name="cb_site_blog_entrypoint"} );
		if( !isNull( blogEntryPoint ) ){
			ses.addNamespace(pattern="#this.entryPoint#/#blogEntryPoint.getValue()#", namespace="blog", append=false);
		}
		else{
			ses.addNamespace(pattern="#this.entryPoint#/blog", namespace="blog", append=false);
		}
		
		// Register namespace routes
		for(var x=1; x LTE arrayLen( variables.blogRoutes ); x++){
			var args = duplicate( variables.blogRoutes[ x ] );
			// Check if handler defined
			if( structKeyExists(args,"handler" ) ){
				args.handler = "contentbox-ui:#args.handler#";
			}
			// Add the namespace routes
			ses.addRoute(argumentCollection=args);
		}
	}

}