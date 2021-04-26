/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * ContentBox Core module configuration
 */
component {

	// Module Properties
	this.title              = "ContentBox Core";
	this.author             = "Ortus Solutions, Corp";
	this.webURL             = "https://www.ortussolutions.com";
	this.version            = "@version.number@+@build.number@";
	this.description        = "This is the core module used to power the admin, RESTful and UI modules";
	this.viewParentLookup   = true;
	this.layoutParentLookup = true;
	this.entryPoint         = "cbcore";
	this.modelNamespace     = "cb";
	this.cfmapping          = "contentbox";
	// Load ContentBox Dependencies First.
	this.dependencies       = [ "contentbox-deps" ];

	/**
	 * Configure Module
	 */
	function configure(){
		// Verify custom module, this is needed for registration and loading.
		verifyCustomModule();

		// contentbox settings
		settings = {
			codename          : "Psalm 144:1",
			codenameLink      : "https://www.bible.com/bible/114/psa.144.1.nkjv",
			// Officially supported languages for modules
			languages         : [ "de_DE", "en_US", "es_SV", "it_IT", "pt_BR" ]
		};

		// i18n
		cbi18n = { resourceBundles : { "cbcore" : "#moduleMapping#/i18n/cbcore" } };

		// CB Module Conventions
		conventions = { layoutsLocation : "themes", viewsLocation : "themes" };

		// Parent Affected Settings
		parentSettings = {
			// File Browser module name override
			filebrowser_module_name : "contentbox-filebrowser"
		};

		// interceptor settings
		interceptorSettings = {
			// ContentBox Custom Events
			customInterceptionPoints : arrayToList( [
				// Code Rendering
				"cb_onContentRendering",
				"cb_onContentStoreRendering"
			] )
		};

		// Async Executors for ContentBox Core
		executors = { "contentbox-tasks" : { type : "scheduled", threads : 20 } };

		// interceptors
		interceptors = [
			// Rate Limiter
			{
				class : "contentbox.models.security.RateLimiter",
				name  : "RateLimiter@cb"
			},
			// CB RSS Cache Cleanup Ghost
			{
				class : "contentbox.models.rss.RSSCacheCleanup",
				name  : "RSSCacheCleanup@cb"
			},
			// CB Content Cache Cleanup Ghost
			{
				class : "contentbox.models.content.util.ContentCacheCleanup",
				name  : "ContentCacheCleanup@cb"
			},
			// Content Subscriptions
			{
				class : "contentbox.models.subscriptions.SubscriptionListener",
				name  : "SubscriptionListener@cb"
			},
			// Content Renderers, remember order is important.
			{
				class : "contentbox.models.content.renderers.LinkRenderer",
				name  : "LinkRenderer@cb"
			},
			{
				class : "contentbox.models.content.renderers.WidgetRenderer",
				name  : "WidgetRenderer@cb"
			},
			{
				class : "contentbox.models.content.renderers.SettingRenderer",
				name  : "SettingRenderer@cb"
			},
			{
				class : "contentbox.models.content.renderers.MarkdownRenderer",
				name  : "MarkdownRenderer@cb"
			}
		];

		// Manual Mappings
		binder.map( "customFieldService@cb" ).toDSL( "entityService:cbCustomField" );

		// ColdBox Integrations
		binder.map( "SystemUtil@cb" ).to( "coldbox.system.core.util.Util" );
	}

	/**
	 * Development tier
	 */
	function development(){
	}

	/**
	 * Fired when the module is registered and activated.
	 */
	function onLoad(){
		var settingService = wirebox.getInstance( "settingService@cb" );
		// Pre-flight check settings
		settingService.preFlightCheck();
		// Loadup Config Overrides
		settingService.loadConfigOverrides();
		// Load Environment Overrides Now, they take precedence
		settingService.loadEnvironmentOverrides();
		// Startup the ContentBox modules, if any
		wirebox.getInstance( "moduleService@cb" ).startup();
	}

	/**
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload(){
	}

	/************************************** APP LISTENERS *********************************************/

	/**
	 * Listen to when application and all modules are fully loaded.
	 * We use this interception to startup some services and discoveries.
	 */
	function afterConfigurationLoad( event, data, rc, prc ){
		// Discover all widgets
		wirebox.getInstance( "widgetservice@cb" ).getWidgets();
	}


	/************************************** PRIVATE *********************************************/

	/**
	 * Verify the custom module exists. If not, we will auto-generate one to avoid conflicts
	 * and issues with new custom approaches.
	 */
	private function verifyCustomModule(){
		var appPath           = controller.getSetting( "ApplicationPath" );
		var customModulesPath = appPath & "modules_app/contentbox-custom";

		// Verify modules_app: just in case
		if ( !directoryExists( appPath & "modules_app" ) ) {
			directoryCreate( appPath & "modules_app" );
		}

		// Build out the module
		if ( !directoryExists( customModulesPath ) ) {
			directoryCreate( customModulesPath );
			directoryCreate( customModulesPath & "/_content" );
			directoryCreate( customModulesPath & "/_modules" );
			directoryCreate( customModulesPath & "/_themes" );
			directoryCreate( customModulesPath & "/_widgets" );
			fileCopy(
				modulePath & "/models/modules/custom/ModuleConfigBase.cfc",
				customModulesPath & "/ModuleConfig.cfc"
			);
		}
	}

}
