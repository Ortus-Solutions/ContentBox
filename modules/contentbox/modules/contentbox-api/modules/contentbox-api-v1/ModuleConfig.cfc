/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * ContentBox API Module: version 1.x
 */
component {

	// Module Properties
	this.title          = "ContentBox API v1.x";
	this.author         = "Ortus Solutions, Corp";
	this.webURL         = "https://www.ortussolutions.com";
	this.version        = "@version.number@+@build.number@";
	this.description    = "ContentBox API v1.x Module";
	// Module Entry Point
	this.entryPoint     = "/cbapi/v1";
	// Inherit entry point from parent, so this will be http://{host}:{port}/cbapi/v1
	this.modelNamespace = "contentbox-api-v1";
	this.cfmapping      = "contentbox-api-v1";
	this.dependencies   = [];

	/**
	 * Configure
	 */
	function configure(){
		// module settings - stored in modules.name.settings
		settings = {
			// Security Configuration for the API Module via cbecurity
			cbsecurity : {
				firewall : {
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
						{
							"match"      : "event",
							"secureList" : "contentbox\-api\-v1\:.*", // Secure all api endpoints
							"whitelist"  : "(auth|echo)" // Except the auth and echo endpoints
						}
					],
					// The validator is an object that will validate rules and annotations and provide feedback on either authentication or authorization issues.
					"validator" : "JwtSecurityValidator@contentbox"
				}
			}
		};

		// Custom Declared Points
		interceptorSettings = { customInterceptionPoints : "" };

		// Custom Declared Interceptors
		interceptors = [];
	}

	/**
	 * Fired when the module is registered and activated.
	 */
	function onLoad(){
	}

	/**
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload(){
	}

}
