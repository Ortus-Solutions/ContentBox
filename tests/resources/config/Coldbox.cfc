/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ColdBox Configuration
*/
component{

	// Configure ColdBox Application
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
			modulesExternalLocation		= [ "/modules_app" ],
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
			development = "local,127\.0\.0\.1"
		};

		// Module Directives
		modules = {
			//Turn to false in production
			autoReload = false,
			// An array of modules names to load, empty means all of them
			include = [],
			// An array of modules names to NOT load, empty means none
			exclude = []
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

		//Layout Settings
		layoutSettings = {
			defaultLayout = "",
			defaultView   = ""
		};

		//Interceptor Settings
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

		// ContentBox Runtime Overrides
		contentbox = {
			// Runtime Settings Override by site slug
		  	settings = {
		  		// Default site
		  		default = {
		  			//"cb_media_directoryRoot" 	= "/docker/mount"
		  		}
		  	}
		}

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
				filename = "ContentBox", filePath="logs", async=true
			}
		};

		// Mail settings for writing to log files instead of sending mail on dev.
		mailsettings.protocol = {
			class = "cbmailservices.models.protocols.FileProtocol",
			properties = {
				filePath = "logs"
			}
		};
		//logbox.debug 	= ["coldbox.system.interceptors.Security"];
		//logbox.debug 	= [ "coldbox.system.aop" ];
		//logbox.debug 	= [ "root" ];

	}

}
