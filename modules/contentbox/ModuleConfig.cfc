component {
	
	// Module Properties
	this.title 				= "ContentBox Core";
	this.author 			= "Luis Majano";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "A cool blogging engine";
	this.version			= "1.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point: The SES entry point for ContentBox: http://myapp/blog
	this.entryPoint			= "";
	
	function configure(){
	
		// module settings - stored in modules.name.settings
		settings = {};
				
		// Custom Declared Interceptors
		interceptors = [
			// CB RSS Cache Cleanup Ghost
			{class="#moduleMapping#.model.rss.RSSCacheCleanup",name="RSSCacheCleanup@cb" }
		];
		
		// Security/System
		binder.map("securityService@cb").to("#moduleMapping#.model.security.SecurityService");
		binder.map("settingService@cb").to("#moduleMapping#.model.system.SettingService");
		binder.map("authorService@cb").to("#moduleMapping#.model.security.AuthorService");
		// Entry services
		binder.map("entryService@cb").to("#moduleMapping#.model.content.EntryService");
		binder.map("categoryService@cb").to("#moduleMapping#.model.content.CategoryService");
		// Page services
		binder.map("pageService@cb").to("#moduleMapping#.model.content.PageService");
		// Commenting services
		binder.map("commentService@cb").to("#moduleMapping#.model.comments.CommentService");
		// RSS services
		binder.map("rssService@cb").to("#moduleMapping#.model.rss.RSSService");	
		// UI services
		binder.map("widgetService@cb").to("#moduleMapping#.model.ui.WidgetService");	
		binder.map("layoutService@cb").to("#moduleMapping#.model.ui.LayoutService");
		binder.map("customHTMLService@cb").to("#moduleMapping#.model.ui.CustomHTMLService");
		binder.map("CBHelper@cb").toDSL("coldbox:myplugin:CBHelper@contentbox");
		// utils
		binder.map("zipUtil@cb").to("coldbox.system.core.util.Zip");
		binder.map("HQLHelper@cb").to("#moduleMapping#.model.util.HQLHelper");
		// importers
		binder.map("mangoImporter@cb").to("#moduleMapping#.model.importers.MangoImporter");
		binder.map("wordpressImporter@cb").to("#moduleMapping#.model.importers.WordpressImporter");
		
		// Load AOP listener if not loaded
		loadAOPListener(binder);
		// Load Hibernate Transactions if not loaded
		loadHibernateTransactions(binder);
	}
	
	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// Startup the ContentBox layout service and activate the layout
		controller.getWireBox().getInstance("layoutService@cb").startupActiveLayout();
	}
	
	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		
	}
	
	/************************************** PRIVATE *********************************************/
	
	/**
	* load hibernatate transactions via AOP
	*/
	private function loadHibernateTransactions(binder){
		var mappings = arguments.binder.getMappings();
		
		for(var key in mappings){
			if( mappings[key].isAspect() AND findNoCase("coldbox.system.aop.aspects.HibernateTransaction", mappings[key].getPath()) ){
				return;
			}
		}
		
		arguments.binder.mapAspect("HibernateTransaction").to("coldbox.system.aop.aspects.HibernateTransaction");	
	}
	
	/**
	* load AOP listener
	*/
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
