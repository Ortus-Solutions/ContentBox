/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ColdBox Configuration
*/
component{

	// Configure Application
	function configure(){

		// coldbox directives
		coldbox = {
			//Application Setup
			appName 					= "ContentBox Modular CMS",

			//Development Settings
			reinitPassword				= "@fwPassword@",
			handlersIndexAutoReload 	= false,

			//Implicit Events
			defaultEvent				= "Main.index",
			requestStartHandler			= "",
			requestEndHandler			= "",
			applicationStartHandler 	= "",
			applicationEndHandler		= "",
			sessionStartHandler 		= "",
			sessionEndHandler			= "",
			missingTemplateHandler		= "",

			//Extension Points
			applicationHelper 			= "",
			viewsHelper					= "",
			modulesExternalLocation		= [],
			viewsExternalLocation		= "",
			layoutsExternalLocation 	= "",
			handlersExternalLocation  	= "",
			requestContextDecorator 	= "",
			controllerDecorator			= "",

			//Error/Exception Handling
			exceptionHandler			= "",
			onInvalidEvent				= "",
			customErrorTemplate			= "",

			//Application Aspects
			handlerCaching 				= true,
			eventCaching				= true,
			viewCaching 				= true
		};

		// custom settings
		settings = {

		};

		// environment settings, create a detectEnvironment() method to detect it yourself.
		// create a function with the name of the environment so it can be executed if that environment is detected
		// the value of the environment is a list of regex patterns to match the cgi.http_host.
		environments = {
			development = "localhost,dev"
		};

		//LogBox DSL
		logBox = {
			// Define Appenders
			appenders = {
				console = { class="coldbox.system.logging.appenders.ConsoleAppender" }
			},
			// Root Logger
			root = { levelmax="INFO", appenders="*" }
		};

		// Layout Settings
		layoutSettings = {
			defaultLayout = "",
			defaultView   = ""
		};

		// Interceptor Settings
		interceptorSettings = {
			throwOnInvalidStates = false,
			customInterceptionPoints = ""
		};

		// ORM Module Configuration
		orm = {
			// Enable Injection
			injection = {
				enabled = true
			}
		};

		//Register interceptors as an array, we need order
		interceptors = [
			//SES
			{ class="coldbox.system.interceptors.SES" }
		];

		// ContentBox relies on the Cache Storage for tracking sessions, which delegates to a Cache provider
		storages = {
		    // Cache Storage Settings
		    cacheStorage = {
		        cachename   = "sessions",
		        timeout     = 60 // The default timeout of the session bucket, defaults to 60
		    }
		};

		// ContentBox Runtime Overrides
		"contentbox" = {
			// Runtime Settings Override by site slug
		  	"settings" = {
		  		// Default site
		  		"default" = {
		  			//"cb_media_directoryRoot" 	= "/docker/mount"
		  		}
		  	}
		};

	}

	// ORTUS DEVELOPMENT ENVIRONMENT, REMOVE FOR YOUR APP IF NEEDED
	function development(){
		//coldbox.debugmode=true;
		coldbox.handlersIndexAutoReload = true;
		coldbox.handlerCaching 			= false;
		coldbox.reinitpassword			= "";
		coldbox.customErrorTemplate 	= "/coldbox/system/includes/BugReport.cfm";

		// debugging file
		logbox.appenders.files = {
			class="coldbox.system.logging.appenders.RollingFileAppender",
			properties = {
				filename = "contentbox", filePath="/logs", async=false
			}
		};

		// Mail settings for writing to log files instead of sending mail on dev.
		mailsettings.protocol = {
			class = "cbmailservices.models.protocols.FileProtocol",
			properties = {
				filePath = "/logs"
			}
		};
		//logbox.debug 	= ["coldbox.system.interceptors.Security"];
		//logbox.debug 	= [ "coldbox.system.aop" ];
		//logbox.debug 	= [ "root" ];

	}

}
