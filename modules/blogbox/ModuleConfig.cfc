component {
	
	// Module Properties
	this.title 				= "BlogBox Core";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "A cool blogging engine";
	this.version			= "1.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point: The SES entry point for blogbox: http://myapp/blog
	this.entryPoint			= "";
	
	function configure(){
	
		// module settings - stored in modules.name.settings
		settings = {};

		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = ""
		};
		
		// Custom Declared Interceptors
		interceptors = [
			// BB RSS Cache Cleanup Ghost
			{class="#moduleMapping#.model.rss.RSSCacheCleanup",name="RSSCacheCleanup@bb" }
		];
		
		// WireBox bindings
		binder.map("securityService@bb").to("#moduleMapping#.model.security.SecurityService");
		binder.map("settingService@bb").to("#moduleMapping#.model.system.SettingService");
		binder.map("authorService@bb").to("#moduleMapping#.model.entries.AuthorService");
		binder.map("entryService@bb").to("#moduleMapping#.model.entries.EntryService");
		binder.map("commentService@bb").to("#moduleMapping#.model.comments.CommentService");
		binder.map("categoryService@bb").to("#moduleMapping#.model.entries.CategoryService");
		binder.map("rssService@bb").to("#moduleMapping#.model.rss.RSSService");	
		binder.map("widgetService@bb").to("#moduleMapping#.model.ui.widgetService");	
		binder.map("layoutService@bb").to("#moduleMapping#.model.ui.LayoutService");
		binder.map("zipUtil@bb").to("coldbox.system.core.util.Zip");
		
		// Load AOP listener if not loaded
		loadAOPListener(binder);
		// Load Hibernate Transactions if not loaded
		loadHibernateTransactions(binder);
	}
	
	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// Startup the blogbox layout service and get the currently active layout
		var layoutService = controller.getWireBox().getInstance("layoutService@bb");
		var qActiveLayout = layoutService.getActiveLayout();
		// Register the active layouts's custom points at startup
		controller.getInterceptorService().appendInterceptionPoints(qActiveLayout.customInterceptionPoints);
	}
	
	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		
	}
	
	private function loadHibernateTransactions(binder){
		var mappings = arguments.binder.getMappings();
		
		for(var key in mappings){
			if( mappings[key].isAspect() AND findNoCase("coldbox.system.aop.aspects.HibernateTransaction", mappings[key].getPath()) ){
				return;
			}
		}
		
		arguments.binder.mapAspect("HibernateTransaction").to("coldbox.system.aop.aspects.HibernateTransaction");	
	}
	
	private function loadAOPListener(binder){
		var b = arguments.binder;
		var l = b.getListeners();
		
		for(var x=1; x lte arrayLen(l); x++){
			if( findnocase("coldbox.system.aop.Mixer", l[x].class) ){
				return;
			}
		}
		
		// load AOP listener
		binder.listener(class="coldbox.system.aop.Mixer");
	}
	
}