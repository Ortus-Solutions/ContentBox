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
		moduleSettings = {

			/**
			 * --------------------------------------------------------------------------
			 * ContentBox Runtime Config
			 * --------------------------------------------------------------------------
			 */
			contentbox : {
				// Array of mixins (eg: /includes/contentHelpers.cfm) to inject into all content objects
				"contentHelpers" = [],
				// Setting Overrides
				"settings" : {
					// Global settings
					"global" : {
					},
					// Site specific settings according to site slug
					"sites" : {
						// siteSlug : { ... }
					}
				}
			},

			/**
			 * --------------------------------------------------------------------------
			 * ColdBox Storages
			 * --------------------------------------------------------------------------
			 * ContentBox relies on the Cache Storage for tracking sessions, which delegates to a Cache provider
			 */
			cbStorages : {
				// Cache Storage Settings
				cacheStorage : {
					// The CacheBox registered cache to store data in
					cachename : "sessions",
					// The default timeout of the session bucket, defaults to 60 minutes
					timeout   : getSystemSetting( "COLDBOX_SESSION_TIMEOUT", 60 ),
					// The identifierProvider is a closure/udf that will return a unique identifier according to your rules
					// If you do not provide one, then we will search in session, cookie and url for the ColdFusion identifier.
					// identifierProvider : function(){}
					identifierProvider : "" // If it's a simple value, we ignore it.
				},
				// Cookie Storage settings
				cookieStorage : {
					// If browser does not support Secure Sockets Layer (SSL) security, the cookie is not sent.
					// To use the cookie, the page must be accessed using the https protocol.
					secure 				: false,
					// If yes, sets cookie as httponly so that it cannot be accessed using JavaScripts
					httpOnly			: true,
					// Domain in which cookie is valid and to which cookie content can be sent from the user's system. By default, the cookie
					// is only available to the server that set it. Use this attribute to make the cookie available to other servers
					domain 				: "",
					// Use encryption of values
					useEncryption 		: false,
					// The unique seeding key to use: keep it secret, keep it safe
					encryptionSeed 		: "",
					// The algorithm to use: https://cfdocs.org/encrypt
					encryptionAlgorithm : "BLOWFISH",
					// The encryption encoding to use
					encryptionEncoding 	: "HEX"
				}
			},

			/**
			 * ColdBox cborm configurations https://forgebox.io/view/cborm
			 */
			cborm : {
				injection : {
					// enable entity injection via WireBox
					enabled : true,
					// Which entities to include in DI ONLY, if empty include all entities
					include : "",
					// Which entities to exclude from DI, if empty, none are excluded
					exclude : ""
				},
				resources : {
					// Enable the ORM Resource Event Loader
					eventLoader     : true,
					// Prefix to use on all the registered pre/post{Entity}{Action} events
					eventPrefix 	: "cb_",
					// Pagination max rows
					maxRows         : 25,
					// Pagination max row limit: 0 = no limit
					maxRowsLimit     : 500
				}
			},

			/**
			 * Mementifier settings: https://forgebox.io/view/mementifier
			 */
			mementifier : {
				// Turn on to use the ISO8601 date/time formatting on all processed date/time properites, else use the masks
				iso8601Format = true,
				// The default date mask to use for date properties
				dateMask      = "yyyy-MM-dd",
				// The default time mask to use for date properties
				timeMask      = "HH:mm: ss",
				// Enable orm auto default includes: If true and an object doesn't have any `memento` struct defined
				// this module will create it with all properties and relationships it can find for the target entity
				// leveraging the cborm module.
				ormAutoIncludes = true,
				// The default value for relationships/getters which return null
				nullDefaultValue = '',
				// Don't check for getters before invoking them
				trustedGetters = false,
				// If not empty, convert all date/times to the specific timezone
				convertToTimezone = "UTC"
			},

			/**
			 * ColdBox Security Module Global Settings
			 */
			cbSecurity : {
				// The global invalid authentication event or URI or URL to go if an invalid authentication occurs
				"invalidAuthenticationEvent"  : "",
				// Default Auhtentication Action: override or redirect when a user has not logged in
				"defaultAuthenticationAction" : "redirect",
				// The global invalid authorization event or URI or URL to go if an invalid authorization occurs
				"invalidAuthorizationEvent"   : "",
				// Default Authorization Action: override or redirect when a user does not have enough permissions to access something
				"defaultAuthorizationAction"  : "redirect",
				// You can define your security rules here or externally via a source
				// specify an array for inline, or a string (db|json|xml|model) for externally
				"rules"                       : [],
				// The validator is an object that will validate rules and annotations and provide feedback on either authentication or authorization issues.
				"validator"                   : "SecurityValidator@contentbox",
				// The WireBox ID of the authentication service to use in cbSecurity which must adhere to the cbsecurity.interfaces.IAuthService interface.
				"authenticationService"       : "SecurityService@contentbox",
				// WireBox ID of the user service to use
				"userService"                 : "AuthorService@contentbox",
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
					// The default expiration for refresh tokens, defaults to 7 days
					"refreshExpiration"   : 10080,
					// The custom header to inspect for refresh tokens
   	 				"customRefreshHeader"    : "x-refresh-token",
					// If enabled, the JWT validator will inspect the request for refresh tokens and expired access tokens
					// It will then automatically refresh them for you and return them back as
					// response headers in the same request according to the `customRefreshHeader` and `customAuthHeader`
					"enableAutoRefreshValidator" : true,
					// Enable the POST > /cbsecurity/refreshtoken API endpoint
					"enableRefreshEndpoint" : false,
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
			}, // end security config

			/**
			 * cbSwagger Documentation for Headless CMS
			 */
			cbSwagger : {
				// The route prefix to search.  Routes beginning with this prefix will be determined to be api routes
				"routes"        : [ "cbapi" ],
				// Routes to exclude from the generated spec
				"excludeRoutes" : [ "cbapi/v1/:anything/" ],
				// The default output format, either json or yml
				"defaultFormat" : "json",
				// A convention route, relative to your app root, where request/response samples are stored ( e.g. resources/apidocs/responses/[module].[handler].[action].[HTTP Status Code].json )
				"samplesPath"   : "resources/apidocs",
				// Information about your API
				// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#infoObject
				"info"          : {
					// REQUIRED A title for your API
					"title"          : "ContentBox CMS API",
					// A short description of the application. CommonMark syntax MAY be used for rich text representation.
					"description"    : "The ContentBox Headless CMS API",
					// A URL to the Terms of Service for the API. MUST be in the format of a URL.
					"termsOfService" : "",
					// Contact information for the exposed API.
					"contact"        : {
						// The identifying name of the contact person/organization.
						"name"  : "Ortus Solutions",
						// The URL pointing to the contact information. MUST be in the format of a URL.
						"url"   : "https://www.ortussolutions.com",
						// The email address of the contact person/organization. MUST be in the format of an email address.
						"email" : "info@ortussolutions.com"
					},
					// License information for the exposed API.
					"license" : {
						// The license name used for the API.
						"name" : "Apache2",
						// A URL to the license used for the API. MUST be in the format of a URL.
						"url"  : "https://www.apache.org/licenses/LICENSE-2.0.html"
					},
					// REQUIRED. The version of the OpenAPI document (which is distinct from the OpenAPI Specification version or the API implementation version).
					"version" : "@version.number@"
				},
				// An array of Server Objects, which provide connectivity information to a target server. If the servers property is not provided, or is an empty array, the default value would be a Server Object with a url value of /.
				// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#serverObject
				"servers"      : [
					{
						"url" : "http://127.0.0.1:8589",
						"description" : "Development Server"
					}
				],
				// An element to hold various schemas for the specification.
				// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#componentsObject
				"components"   : {
					// Define your security schemes here
					// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#securitySchemeObject
					"securitySchemes" : {
						"ApiKeyAuth" : {
							"type"        : "apiKey",
							"description" : "User your JWT as an Api Key for security",
							"name"        : "x-auth-token",
							"in"          : "header"
						},
						"ApiKeyQueryAuth" : {
							"type"        : "apiKey",
							"description" : "User your JWT as an Api Key for security",
							"name"        : "x-auth-token",
							"in"          : "query"
						},
						"BearerAuth" : {
							"type"         : "http",
							"description" : "User your JWT in the bearer Authorization header",
							"scheme"       : "bearer",
							"bearerFormat" : "JWT"
						}
					}
				},
				// A declaration of which security mechanisms can be used across the API.
				// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#securityRequirementObject
				"security"     : [
					{ "ApiKeyAuth" : [] },
					{ "ApiKeyQueryAuth" : [] },
					{ "BearerAuth" : [] }
				],
				// A list of tags used by the specification with additional metadata.
				// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#tagObject
				"tags"         : [
					{ "name" : "Authors", "description" : "Author operations" },
					{ "name" : "Authentication", "description" : "Authentication operations" },
					{ "name" : "Categories", "description" : "Category operations" },
					{ "name" : "Comments", "description" : "Comment operations" },
					{ "name" : "ContentStore", "description" : "Content store operations" },
					{ "name" : "Entries", "description" : "Blog entry operations" },
					{ "name" : "Menus", "description" : "Menu operations" },
					{ "name" : "Pages", "description" : "Pages operations" },
					{ "name" : "Sites", "description" : "Site operations" },
					{ "name" : "Settings", "description" : "Global setting operations" },
					{ "name" : "Versions", "description" : "Content versions operations" }
				],
				// Additional external documentation.
				// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#externalDocumentationObject
				"externalDocs" : { "description" : "Find more info here", "url" : "https://contentbox.ortusbooks.com" }
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
			enabled   : getSystemSetting( "CBDEBUGGER_ENABLED", false ),
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
			modules  : { enabled : true, expanded : false },
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
				logParams : false
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
