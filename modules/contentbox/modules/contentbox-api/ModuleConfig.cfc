/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * ContentBox API Module
 */
component {

	// Module Properties
	this.title          = "ContentBox API";
	this.author         = "Ortus Solutions, Corp";
	this.webURL         = "https://www.ortussolutions.com";
	this.version        = "@version.number@+@build.number@";
	this.description    = "ContentBox API Module";
	// The main entry point for the ContentBox API: http://{host}:{port}/cbapi
	this.entryPoint     = "cbapi";
	this.modelNamespace = "contentbox-api";
	this.cfmapping      = "contentbox-api";
	this.dependencies   = [];

	/**
	 * Configure Module
	 */
	function configure(){
		// Module Settings
		settings = {
			// Security Configuration for the API Module via cbecurity
			cbsecurity : {
				// The global invalid authentication event or URI or URL to go if an invalid authentication occurs
				"invalidAuthenticationEvent"  : "contentbox-api-v1:auth.onAuthenticationFailure",
				// Default Auhtentication Action: override or redirect when a user has not logged in
				"defaultAuthenticationAction" : "override",
				// The global invalid authorization event or URI or URL to go if an invalid authorization occurs
				"invalidAuthorizationEvent"   : "contentbox-api-v1:auth.onAuthorizationFailure",
				// Default Authorization Action: override or redirect when a user does not have enough permissions to access something
				"defaultAuthorizationAction"  : "override",
				// Global Security Rules
				"rules"                       : [
					 // {
					//	"match"      : "event",
					//	"secureList" : "contentbox\-api\-v1\:.*", // Secure all api endpoints
					//	"whitelist"  : "(auth|echo)" // Except the auth and echo endpoints
					// }
				],
				// The validator is an object that will validate rules and annotations and provide feedback on either authentication or authorization issues.
				"validator" : "JWTService@cbsecurity"
			}
		};


		// Custom Declared Points
		interceptorSettings = {
			// CB Admin Custom Events
			customInterceptionPoints : []
		};

		// Custom Declared Interceptors
		interceptors = [];
	}

	/*
	 * On Module Load
	 */
	function onLoad(){
	}

}
