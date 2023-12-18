/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * ColdBox Configuration
 */
component {

	// Configure Application
	function configure(){
		/**
		 * --------------------------------------------------------------------------
		 * ColdBox Directives
		 * --------------------------------------------------------------------------
		 * Here you can configure ColdBox for operation. Remember tha these directives below
		 * are for PRODUCTION. If you want different settings for other environments make sure
		 * you create the appropriate functions and define the environment in your .env or
		 * in the `environments` struct.
		 */
		coldbox = {
			// Application Setup
			appName                  : getSystemSetting( "APPNAME", "ContentBox Modular CMS" ),
			eventName                : "event",
			// Development Settings
			reinitPassword           : getSystemSetting( "COLDBOX_REINITPASSWORD", "@fwPassword@" ),
			reinitKey                : "fwreinit",
			handlersIndexAutoReload  : false,
			// Implicit Events
			defaultEvent             : "Main.index",
			requestStartHandler      : "",
			requestEndHandler        : "",
			applicationStartHandler  : "",
			applicationEndHandler    : "",
			sessionStartHandler      : "",
			sessionEndHandler        : "",
			missingTemplateHandler   : "",
			// Extension Points
			applicationHelper        : "",
			viewsHelper              : "",
			modulesExternalLocation  : [],
			viewsExternalLocation    : "",
			layoutsExternalLocation  : "",
			handlersExternalLocation : "",
			requestContextDecorator  : "",
			controllerDecorator      : "",
			// Error/Exception Handling
			exceptionHandler         : "",
			invalidEventHandler      : "",
			customErrorTemplate      : "",
			// Application Aspects
			handlerCaching           : true,
			eventCaching             : true,
			viewCaching              : true,
			// Will automatically do a mapDirectory() on your `models` for you.
			autoMapModels            : true,
			// Auto converts a json body payload into the RC
			jsonPayloadToRC          : true
		};

		/**
		 * --------------------------------------------------------------------------
		 * Custom Settings
		 * --------------------------------------------------------------------------
		 */
		settings = {};

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
		environments = { development : "localhost" };

		/**
		 * --------------------------------------------------------------------------
		 * Logging Directives
		 * --------------------------------------------------------------------------
		 */
		logBox = {
			// Define Appenders
			appenders : { coldboxTracer : { class : "coldbox.system.logging.appenders.ConsoleAppender" } },
			// Root Logger
			root      : { levelmax : "INFO", appenders : "*" },
			// Implicit Level Categories
			info      : [ "coldbox.system", "contentbox" ]
		};

		/**
		 * --------------------------------------------------------------------------
		 * Layout Settings
		 * --------------------------------------------------------------------------
		 */
		layoutSettings = { defaultLayout : "", defaultView : "" };

		/**
		 * --------------------------------------------------------------------------
		 * Custom Interception Points
		 * --------------------------------------------------------------------------
		 */
		interceptorSettings = { customInterceptionPoints : [] };

		/**
		 * --------------------------------------------------------------------------
		 * Application Interceptors
		 * --------------------------------------------------------------------------
		 * Remember that the order of declaration is the order they will be registered and fired
		 */
		interceptors = [];

		/**
		 * --------------------------------------------------------------------------
		 * Flash Scope Settings
		 * --------------------------------------------------------------------------
		 * The available scopes are : session, client, cluster, cache, or a full instantiation CFC path
		 */
		flash = {
			scope        : "cache",
			properties   : { cacheName : "template" },
			inflateToRC  : true, // automatically inflate flash data into the RC scope
			inflateToPRC : false, // automatically inflate flash data into the PRC scope
			autoPurge    : true, // automatically purge flash data for you
			autoSave     : true // automatically save flash scopes at end of a request and on relocations.
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
		moduleSettings = {};
	}

	/**
	 * Testing Mode.
	 */
	function testing(){
		development();
	}

	/**
	 * Development environment
	 * ORTUS DEVELOPMENT ENVIRONMENT, REMOVE FOR YOUR APP IF NEEDED
	 */
	function development(){
		coldbox.handlersIndexAutoReload = true;
		coldbox.handlerCaching          = false;
		coldbox.reinitpassword          = "";
		coldbox.customErrorTemplate     = "/coldbox/system/exceptions/Whoops.cfm";

		// No Singletons for easy testing
		wirebox = {
			 // singletonReload : true
		};

		// debugging file
		logbox.appenders.files = {
			class      : "coldbox.system.logging.appenders.RollingFileAppender",
			properties : {
				filename : "contentbox",
				filePath : "/cbapp/config/logs/app"
			}
		};

		// Specific Debugging + Logging
		// logbox.debug 	= [ "cbsecurity" ];
		// logbox.debug 	= [ "coldbox.system.web.services" ];
		// logbox.debug 	= [ "coldbox.system.aop" ];
		// logbox.debug 	= [ "root" ];
	}

}
