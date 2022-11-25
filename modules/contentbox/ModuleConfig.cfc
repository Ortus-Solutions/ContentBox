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
	this.modelNamespace     = "contentbox";
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
			// Code name
			"codename"     : "Psalm 144:1",
			"codenameLink" : "https://www.bible.com/bible/114/psa.144.1.nkjv",
			// Officially supported languages for modules
			"languages"    : [ "de_DE", "en_US", "es_SV", "it_IT", "pt_BR" ],
			// cbSecurity settings
			"cbSecurity"   : {
				// Load the security rules for ContentBox from our db model
				"firewall" : {
					"rules" : {
						"provider" : {
							"source" : "model",
							"properties" : {
								"model" : "securityRuleService@contentbox",
								"method" : "getSecurityRules"
							}
						}
					}
				}
			},
			// Array of mixins to inject into all content objects
			"contentHelpers" : [],
			// Setting Overrides
			"settings"       : {
				// Global settings
				"global" : {},
				// Site specific settings according to site slug
				"sites"  : {
					 // siteSlug : { ... }
				}
			}
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

		// ContentBox Core Custom Events
		interceptorSettings = {
			customInterceptionPoints : [
				"cb_onContentRendering",
				"cb_onContentStoreRendering"
			]
		};

		// Async Executors for ContentBox Core
		// executors = { "contentbox-tasks" : { type : "scheduled", threads : 20 } };

		// interceptors
		interceptors = [
			// Rate Limiter
			{
				class : "contentbox.models.security.RateLimiter",
				name  : "RateLimiter@contentbox"
			},
			// CB RSS Cache Cleanup Ghost
			{
				class : "contentbox.models.rss.RSSCacheCleanup",
				name  : "RSSCacheCleanup@contentbox"
			},
			// CB Content Cache Cleanup Ghost
			{
				class : "contentbox.models.content.util.ContentCacheCleanup",
				name  : "ContentCacheCleanup@contentbox"
			},
			// Content Subscriptions
			{
				class : "contentbox.models.subscriptions.SubscriptionListener",
				name  : "SubscriptionListener@contentbox"
			},
			// Content Renderers, remember order is important.
			{
				class : "contentbox.models.content.renderers.LinkRenderer",
				name  : "LinkRenderer@contentbox"
			},
			{
				class : "contentbox.models.content.renderers.WidgetRenderer",
				name  : "WidgetRenderer@contentbox"
			},
			{
				class : "contentbox.models.content.renderers.SettingRenderer",
				name  : "SettingRenderer@contentbox"
			},
			{
				class : "contentbox.models.content.renderers.MarkdownRenderer",
				name  : "MarkdownRenderer@contentbox"
			}
		];

		// Manual Mappings
		binder.map( "customFieldService@contentbox" ).toDSL( "entityService:cbCustomField" );
		binder.map( "SystemUtil@contentbox" ).to( "coldbox.system.core.util.Util" );
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
		// Create `cb` alias : REMOVE BY CONTENTBOX NEXT MAJOR VERSION
		binder.mapDirectory( packagePath = "contentbox.models", namespace = "@cb" );
		var settingService = wirebox.getInstance( "settingService@contentbox" );
		// Pre-flight check settings
		settingService.preFlightCheck();
		// Loadup Config Overrides
		settingService.loadConfigOverrides();
		// Load Environment Overrides Now, they take precedence
		settingService.loadEnvironmentOverrides();

		var diskService = getInstance( "cbfs" );

		if( !diskService.has( "contentbox" ) ){
			diskService.register(
				"contentbox",
				"Local",
				{ path : expandPath( settingService.getSetting( "cb_media_directoryRoot" ) ) }
			);
		}

		// Startup the ContentBox modules, if any
		wirebox.getInstance( "moduleService@contentbox" ).startup();
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
		wirebox.getInstance( "widgetservice@contentbox" ).getWidgets();
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
