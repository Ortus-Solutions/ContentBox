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
			reinitPassword           : "@fwPassword@",
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
		environments = { development : "localhost,^127" };

		/**
		 * --------------------------------------------------------------------------
		 * Logging Directives
		 * --------------------------------------------------------------------------
		 */
		logBox = {
			// Define Appenders
			appenders : {
				coldboxTracer : { class : "coldbox.system.logging.appenders.ConsoleAppender" }
			},
			// Root Logger
			root : { levelmax : "INFO", appenders : "*" },
			// Implicit Level Categories
			info : [ "coldbox.system", "contentbox" ]
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
		 * ColdBox Storages
		 * --------------------------------------------------------------------------
		 * ContentBox relies on the Cache Storage for tracking sessions, which delegates to a Cache provider
		 */
		storages = {
			// Cache Storage Settings
			cacheStorage : {
				cachename : "sessions",
				timeout   : 60 // The default timeout of the session bucket, defaults to 60 minutes
			}
		};

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
		 * ContentBox Runtime Overrides
		 * --------------------------------------------------------------------------
		 * You can override any ContentBox site setting by entering them below according
		 * to site name or top level for global
		 */
		"contentbox" = {
			"settings" : {
				// Global settings
				"global" : {},
				// Site specific settings according to site slug
				"sites" : {
					// siteSlug : { ... }
				}
			}
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
		moduleSettings = {
			/**
			 * ColdBox cbORM
			 */
			cborm : {
				injection : {
					// enable entity injection via WireBox
					enabled : true,
					// Which entities to include in DI ONLY, if empty include all entities
					include : "",
					// Which entities to exclude from DI, if empty, none are excluded
					exclude : ""
				}
			},
			/**
			 * ColdBox Security
			 * Customize as you see fit.
			 */
			cbSecurity : {
				// Do not load global firewall
				autoLoadFirewall : false
			}
		};
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
			//singletonReload : true
		};

		// debugging file
		logbox.appenders.files = {
			class      : "coldbox.system.logging.appenders.RollingFileAppender",
			properties : { filename : "contentbox", filePath : "/cbapp/config/logs/app" }
		};

		// Mail settings for writing to log files instead of sending mail on dev.
		mailsettings.protocol = {
			class      : "cbmailservices.models.protocols.FileProtocol",
			properties : { filePath : "/cbapp/config/logs/mail" }
		};

		// Debugger Settings
		variables.modulesettings.cbdebugger = {
			// This flag enables/disables the tracking of request data to our storage facilities
			// To disable all tracking, turn this master key off
			enabled   : true,
			// This setting controls if you will activate the debugger for visualizations ONLY
			// The debugger will still track requests even in non debug mode.
			debugMode : true,
			// The URL password to use to activate it on demand
			debugPassword  : "cb",
			// Request Tracker Options
			requestTracker : {
				storage                      : "cachebox",
				cacheName                    : "template",
				trackDebuggerEvents : false,
				// Expand by default the tracker panel or not
				expanded                     : false,
				// Slow request threshold in milliseconds, if execution time is above it, we mark those transactions as red
				slowExecutionThreshold       : 1000,
				// How many tracking profilers to keep in stack: Default is to monitor the last 20 requests
				maxProfilers                 : 50,
				// If enabled, the debugger will monitor the creation time of CFC objects via WireBox
				profileWireBoxObjectCreation : false,
				// Profile model objects annotated with the `profile` annotation
				profileObjects               : true,
				// If enabled, will trace the results of any methods that are being profiled
				traceObjectResults           : false,
				// Profile Custom or Core interception points
				profileInterceptions         : false,
				// By default all interception events are excluded, you must include what you want to profile
				includedInterceptions        : [],
				// Control the execution timers
				executionTimers              : {
					expanded           : true,
					// Slow transaction timers in milliseconds, if execution time of the timer is above it, we mark it
					slowTimerThreshold : 250
				},
				// Control the coldbox info reporting
				coldboxInfo : { expanded : false },
				// Control the http request reporting
				httpRequest : {
					expanded        : false,
					// If enabled, we will profile HTTP Body content, disabled by default as it contains lots of data
					profileHTTPBody : false
				}
			},
			// ColdBox Tracer Appender Messages
			tracers     : { enabled : true, expanded : false },
			// Request Collections Reporting
			collections : {
				// Enable tracking
				enabled      : false,
				// Expanded panel or not
				expanded     : false,
				// How many rows to dump for object collections
				maxQueryRows : 50,
				// How many levels to output on dumps for objects
				maxDumpTop   : 5
			},
			// CacheBox Reporting
			cachebox : { enabled : true, expanded : false },
			// Modules Reporting
			modules  : { enabled : false, expanded : false },
			// Quick and QB Reporting
			qb       : {
				enabled   : false,
				expanded  : false,
				// Log the binding parameters
				logParams : true
			},
			// cborm Reporting
			cborm : {
				enabled   : true,
				expanded  : false,
				// Log the binding parameters
				logParams : true
			},
			async : {
				enabled : true,
				expanded : false
			}
		};

		// Specific Debugging + Logging
		// logbox.debug 	= [ "cbsecurity" ];
		// logbox.debug 	= [ "coldbox.system.web.services" ];
		// logbox.debug 	= [ "coldbox.system.aop" ];
		// logbox.debug 	= [ "root" ];
	}

}
