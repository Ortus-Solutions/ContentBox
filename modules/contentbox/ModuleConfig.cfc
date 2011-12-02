/**
* ContentBox main module configuration
*/
component {
	
	// Module Properties
	this.title 				= "ContentBox Core";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "An enterprise modular content platform";
	this.version			= "1.0";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	this.entryPoint			= "cbcore";
	
	function configure(){
		// contentbox settings
		settings = {};
				
		// interceptors
		interceptors = [
			// CB RSS Cache Cleanup Ghost
			{class="contentbox.model.rss.RSSCacheCleanup",name="RSSCacheCleanup@cb" }
		];
		
		// Security/System
		binder.map("securityService@cb").to("contentbox.model.security.SecurityService");
		binder.map("settingService@cb").to("contentbox.model.system.SettingService");
		binder.map("authorService@cb").to("contentbox.model.security.AuthorService");
		// Entry services
		binder.map("entryService@cb").to("contentbox.model.content.EntryService");
		binder.map("categoryService@cb").to("contentbox.model.content.CategoryService");
		// Page services
		binder.map("pageService@cb").to("contentbox.model.content.PageService");
		// Commenting services
		binder.map("commentService@cb").to("contentbox.model.comments.CommentService");
		// RSS services
		binder.map("rssService@cb").to("contentbox.model.rss.RSSService");	
		// UI services
		binder.map("widgetService@cb").to("contentbox.model.ui.WidgetService");	
		binder.map("layoutService@cb").to("contentbox.model.ui.LayoutService");
		binder.map("customHTMLService@cb").to("contentbox.model.ui.CustomHTMLService");
		binder.map("CBHelper@cb").toDSL("coldbox:myplugin:CBHelper@contentbox");
		// utils
		binder.map("zipUtil@cb").to("coldbox.system.core.util.Zip");
		binder.map("HQLHelper@cb").to("contentbox.model.util.HQLHelper");
		binder.map("Validator@cb").to("coldbox.system.core.util.Validator");
		// importers
		binder.map("mangoImporter@cb").to("contentbox.model.importers.MangoImporter");
		binder.map("wordpressImporter@cb").to("contentbox.model.importers.WordpressImporter");
		
		// Load AOP listener if not loaded
		loadAOPListener(binder);
		// Load Hibernate Transactions if not loaded
		loadHibernateTransactions(binder);
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
	
	/************************************** PRIVATE *********************************************/
	
	/**
	* load hibernatate transactions via AOP
	*/
	private function loadHibernateTransactions(binder){
		var mappings = binder.getMappings();
		
		for(var key in mappings){
			if( mappings[key].isAspect() AND findNoCase("coldbox.system.aop.aspects.HibernateTransaction", mappings[key].getPath()) ){
				return;
			}
		}
		// map the hibernate transaction manually.
		binder.mapAspect(aspect="CBHibernateTransaction",autoBinding=false)
			.to("coldbox.system.aop.aspects.HibernateTransaction");	
			
		// bind the aspect
		binder.bindAspect(classes=binder.match().regex("contentbox\."),
									methods=binder.match().annotatedWith("transactional"),
									aspects="CBHibernateTransaction");
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
