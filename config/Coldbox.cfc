/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * ColdBox Configuration
 */
component {

	// Configure Application
	function configure() {
		/**
		 * --------------------------------------------------------------------------
		 * ColdBox Directives
		 * --------------------------------------------------------------------------
		 * Here you can configure ColdBox for operation. Remember tha these directives below
		 * are for PRODUCTION. If you want different settings for other environments make sure
		 * you create the appropriate functions and define the environment in your .env or
		 * in the `environments` struct.
		 */
		variables.coldbox = {
			// Application Setup
			appName                 : getSystemSetting( "APPNAME", "ContentBox Modular CMS" ),
			eventName               : "event",
			// Development Settings
			reinitPassword          : getSystemSetting( "COLDBOX_REINITPASSWORD", "@fwPassword@" ),
			reinitKey               : "fwreinit",
			handlersIndexAutoReload : false,
			// Implicit Events
			defaultEvent            : "Main.index",
			requestStartHandler     : "",
			requestEndHandler       : "",
			applicationStartHandler : "",
			applicationEndHandler   : "",
			sessionStartHandler     : "",
			sessionEndHandler       : "",
			missingTemplateHandler  : "",
			// Extension Points
			applicationHelper       : "",
			viewsHelper             : "",
			modulesExternalLocation : [ "/lib/modules" ],
			viewsExternalLocation   : "",
			layoutsExternalLocation : "",
			handlersExternalLocation: "",
			requestContextDecorator : "",
			controllerDecorator     : "",
			// Error/Exception Handling
			exceptionHandler        : "",
			invalidEventHandler     : "",
			customErrorTemplate     : "",
			// Application Aspects
			handlerCaching          : true,
			eventCaching            : true,
			viewCaching             : true,
			// Will automatically do a mapDirectory() on your `models` for you.
			autoMapModels           : true,
			// Auto converts a json body payload into the RC
			jsonPayloadToRC         : true
		};

		/**
		 * --------------------------------------------------------------------------
		 * Custom Settings
		 * --------------------------------------------------------------------------
		 */
		variables.settings = {};

		/**
		 * --------------------------------------------------------------------------
		 * Environment Detection
		 * --------------------------------------------------------------------------
		 * By default we look in your `.env` file for an `environment` key, if not,
		 * then we look into this structure or if you have a function called `detectEnvironment()`
		 * If you use this setting, then each key is the name of the environment and the value is
		 * the regex patterns to match against cgi.http_host.
		 *
		 * Uncomment to use, but make sure your .env ENVIRONMENT key is also removed.
		 */
		variables.environments = { development: "localhost" };

		/**
		 * --------------------------------------------------------------------------
		 * Logging Directives
		 * --------------------------------------------------------------------------
		 */
		variables.logBox = {
			// Define Appenders
			appenders: { coldboxTracer: { class: "coldbox.system.logging.appenders.ConsoleAppender" } },
			// Root Logger
			root     : { levelmax: "INFO", appenders: "*" },
			// Implicit Level Categories
			info     : [ "coldbox.system", "contentbox"]
		};

		/**
		 * --------------------------------------------------------------------------
		 * Layout Settings
		 * --------------------------------------------------------------------------
		 */
		variables.layoutSettings = { defaultLayout: "", defaultView: "" };

		/**
		 * --------------------------------------------------------------------------
		 * Custom Interception Points
		 * --------------------------------------------------------------------------
		 */
		variables.interceptorSettings = { customInterceptionPoints: [] };

		/**
		 * --------------------------------------------------------------------------
		 * Application Interceptors
		 * --------------------------------------------------------------------------
		 * Remember that the order of declaration is the order they will be registered and fired
		 */
		variables.interceptors = [];

		/**
		 * --------------------------------------------------------------------------
		 * Flash Scope Settings
		 * --------------------------------------------------------------------------
		 * The available scopes are : session, client, cluster, cache, or a full instantiation CFC path
		 */
		variables.flash = {
			scope       : "cache",
			properties  : { cacheName: "template" },
			inflateToRC : true, // automatically inflate flash data into the RC scope
			inflateToPRC: false, // automatically inflate flash data into the PRC scope
			autoPurge   : true, // automatically purge flash data for you
			autoSave    : true // automatically save flash scopes at end of a request and on relocations.
		};

		/**
		 * --------------------------------------------------------------------------
		 * Module Settings
		 * --------------------------------------------------------------------------
		 * Each module has it's own configuration structures, so make sure you follow
		 * the module's instructions on settings.
		 *
		 * Each key is the name of the module:
		 *
		 * myModule = {
		 *
		 * }
		 */
		variables.moduleSettings = {};
	}

	/**
	 * Testing Mode.
	 */
	function testing() {
		development();
	}

	/**
	 * Development environment
	 * ORTUS DEVELOPMENT ENVIRONMENT, REMOVE FOR YOUR APP IF NEEDED
	 */
	function development() {
		variables.coldbox.handlersIndexAutoReload = true;
		variables.coldbox.handlerCaching = false;
		variables.coldbox.debugMode = true;
		variables.coldbox.reinitpassword = "";
		variables.coldbox.customErrorTemplate = "/coldbox/system/exceptions/Whoops.cfm";

		// No Singletons for easy testing
		// variables.wirebox = {// singletonReload : true};

		// debugging file
		variables
			.logbox
			.appenders
			.files = {
			class     : "coldbox.system.logging.appenders.RollingFileAppender",
			properties: {
				filename: "contentbox",
				filePath: "/cbapp/config/logs/app"
			}
		};


		// Specific Debugging + Logging
		// logbox.debug 	= [ "cbsecurity" ];
		// logbox.debug 	= [ "coldbox.system.web.services" ];
		// logbox.debug 	= [ "coldbox.system.aop" ];
		// logbox.debug 	= [ "root" ];
	}

}