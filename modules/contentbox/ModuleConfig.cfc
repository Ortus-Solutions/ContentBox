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
			codename     : "Psalm 144:1",
			codenameLink : "https://www.bible.com/bible/114/psa.144.1.nkjv",
			// Officially supported languages for modules
			languages    : [ "de_DE", "en_US", "es_SV", "it_IT", "pt_BR" ]
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
			},
			// ContentBox Security Firewall using Default config for ALL modules and global Site
			// Each module can override the settings
			{
				class      : "cbsecurity.interceptors.Security",
				name       : "cbSecurity",
				properties : {
					// The global invalid authentication event or URI or URL to go if an invalid authentication occurs
					"invalidAuthenticationEvent"  : "cbadmin/security/login",
					// Default Auhtentication Action: override or redirect when a user has not logged in
					"defaultAuthenticationAction" : "redirect",
					// The global invalid authorization event or URI or URL to go if an invalid authorization occurs
					"invalidAuthorizationEvent"   : "cbadmin",
					// Default Authorization Action: override or redirect when a user does not have enough permissions to access something
					"defaultAuthorizationAction"  : "redirect",
					// You can define your security rules here or externally via a source
					// specify an array for inline, or a string (db|json|xml|model) for externally
					"rules"                       : "model",
					// If source is model, the wirebox Id to use for retrieving the rules
					"rulesModel"                  : "securityRuleService@cb",
					"rulesModelMethod"            : "getSecurityRules",
					// The validator is an object that will validate rules and annotations and provide feedback on either authentication or authorization issues.
					"validator"                   : "SecurityValidator@cb",
					// The WireBox ID of the authentication service to use in cbSecurity which must adhere to the cbsecurity.interfaces.IAuthService interface.
					"authenticationService"       : "SecurityService@cb",
					// WireBox ID of the user service to use
					"userService"                 : "AuthorService@cb",
					// The name of the variable to use to store an authenticated user in prc scope if using a validator that supports it.
					"prcUserVariable"             : "oCurrentAuthor",
					// Use regex in rules
					"useRegex"                    : true,
					// Use SSL: Determined by Request
					"useSSL"                      : false,
					// Enable annotation security as well
					"handlerAnnotationSecurity"   : true,
					// JWT Settings
					"jwt"                         : {
						// The issuer authority for the tokens, placed in the `iss` claim
						"issuer"              : "contentbox",
						// The jwt secret encoding key to use
						"secretKey"           : getSystemSetting( "JWT_SECRET", "" ),
						// by default it uses the authorization bearer header, but you can also pass a custom one as well or as an rc variable.
						"customAuthHeader"    : "x-auth-token",
						// The expiration in minutes for the jwt tokens
						"expiration"          : 60,
						// If true, enables refresh tokens, longer lived tokens (not implemented yet)
						"enableRefreshTokens" : true,
						// The default expiration for refresh tokens, defaults to 30 days
						"refreshExpiration"   : 43200,
						// encryption algorithm to use, valid algorithms are: HS256, HS384, and HS512
						"algorithm"           : "HS512",
						// Which claims neds to be present on the jwt token or `TokenInvalidException` upon verification and decoding
						"requiredClaims"      : [],
						// The token storage settings
						"tokenStorage"        : {
							// enable or not, default is true
							"enabled"    : true,
							// A cache key prefix to use when storing the tokens
							"keyPrefix"  : "cbjwt_",
							// The driver to use: db, cachebox or a WireBox ID
							"driver"     : "db",
							// Driver specific properties
							"properties" : {
								"table"             : "cb_jwt",
								"autoCreate"        : true,
								"rotationDays"      : 7,
								"rotationFrequency" : 60
							}
						}
					} // end jwt config
				} // end security config
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
