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
		settings = {
			codename = "John 12:44",
			codenameLink = "http://www.youversion.com/bible/nkjv/matt/18/11"
		};
		
		// Parent Affected Settings
		parentSettings = {
			messagebox_style_override	= true,
			// File Browser module name override
			filebrowser_module_name		= "contentbox-filebrowser"
		};
		
		// interceptor settings
		interceptorSettings = {
			// ContentBox Custom Events
			customInterceptionPoints = arrayToList([
				// Code Rendering
				"cb_onContentRendering","cb_onCustomHTMLRendering"
			])
		};
				
		// interceptors
		interceptors = [
			// ContentBox security
			{class="coldbox.system.interceptors.Security",
			 name="security@cb",
			 properties={
			 	 rulesSource 	= "model",
			 	 rulesModel		= "securityRuleService@cb",
			 	 rulesModelMethod = "getSecurityRules",
			 	 validatorModel = "securityService@cb"} 
			},
			// CB RSS Cache Cleanup Ghost
			{class="contentbox.model.rss.RSSCacheCleanup",name="RSSCacheCleanup@cb" },
			// CB Content Cache Cleanup Ghost
			{class="contentbox.model.content.util.ContentCacheCleanup",name="ContentCacheCleanup@cb" },
			// Notification service interceptor
			{class="contentbox.model.system.NotificationService",name="NotificationService@cb" },
			// Content Renderers, remember order is important.
			{class="contentbox.model.content.renderers.WidgetRenderer"}
		];
		
		// Security/System
		binder.map("settingService@cb").to("contentbox.model.system.SettingService");
		binder.map("emailtemplateService@cb").to("contentbox.model.system.EmailTemplateService");
		binder.map("securityService@cb").to("contentbox.model.security.SecurityService");
		binder.map("authorService@cb").to("contentbox.model.security.AuthorService");
		binder.map("permissionService@cb").to("contentbox.model.security.PermissionService");
		binder.map("roleService@cb").to("contentbox.model.security.RoleService");
		binder.map("securityRuleService@cb").to("contentbox.model.security.SecurityRuleService");
		binder.map("securityInterceptor@cb").toDSL("coldbox:interceptor:security@cb");
		// Entry services
		binder.map("entryService@cb").to("contentbox.model.content.EntryService");
		binder.map("categoryService@cb").to("contentbox.model.content.CategoryService");
		// Page services
		binder.map("pageService@cb").to("contentbox.model.content.PageService");
		// Content
		binder.map("customHTMLService@cb").to("contentbox.model.content.CustomHTMLService");
		binder.map("contentVersionService@cb").to("contentbox.model.content.ContentVersionService");
		binder.map("contentService@cb").to("contentbox.model.content.ContentService");
		// Commenting services
		binder.map("commentService@cb").to("contentbox.model.comments.CommentService");
		// RSS services
		binder.map("rssService@cb").to("contentbox.model.rss.RSSService");	
		// UI
		binder.map("customFieldService@cb").toDSL("entityService:cbCustomField");	
		binder.map("widgetService@cb").to("contentbox.model.ui.WidgetService");	
		binder.map("layoutService@cb").to("contentbox.model.ui.LayoutService");
		binder.map("CBHelper@cb").toDSL("coldbox:myplugin:CBHelper@contentbox");
		binder.map("Widget@cb").to("contentbox.model.ui.Widget");
		// utils
		binder.map("zipUtil@cb").to("coldbox.system.core.util.Zip");
		binder.map("HQLHelper@cb").to("contentbox.model.util.HQLHelper");
		binder.map("Validator@cb").to("coldbox.system.core.util.Validator");
		// importers
		binder.map("mangoImporter@cb").to("contentbox.model.importers.MangoImporter");
		binder.map("wordpressImporter@cb").to("contentbox.model.importers.WordpressImporter");
		
		// Load Hibernate Transactions for ContentBox
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
		// map the hibernate transaction for contentbox
		binder.mapAspect(aspect="CBHibernateTransaction",autoBinding=false)
			.to("coldbox.system.aop.aspects.HibernateTransaction");	
			
		// bind the aspect
		binder.bindAspect(classes=binder.match().regex("contentbox.*"),
									methods=binder.match().annotatedWith("transactional"),
									aspects="CBHibernateTransaction");
	}
	
}
