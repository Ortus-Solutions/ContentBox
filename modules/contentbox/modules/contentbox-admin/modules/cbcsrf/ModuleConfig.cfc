/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 */
component {

	// Module Properties
	this.title              = "ColdBox CSRF";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL             = "https://www.ortussolutions.com";
	this.description        = "Provides anti-Cross Site Request Forgery tokens that also work on older versions of CF.";
	this.version            = "@version.number@+38";
	// Module Entry Point
	this.entryPoint         = "cbcsrf";
	// Model Namespace
	this.modelNamespace     = "cbcsrf";
	// CF Mapping
	this.cfmapping			= "cbcsrf";
	// Auto Map Models Directory
	this.autoMapModels      = true;
	// Helpers
	this.applicationHelper 	= [ "helpers/Mixins.cfm" ];
	// Dependencies
	this.dependencies 		= [ "cbStorages" ];

	/**
	 * Configure the module
	 */
	function configure(){
		settings = {
			// By default we load up an interceptor that verifies all non-GET incoming requests against the token validations
			enableAutoVerifier : false,
			// A list of events to exclude from csrf verification, regex allowed: e.g. stripe\..*
			verifyExcludes : [
			],
			// By default, all csrf tokens have a life-span of 30 minutes. After 30 minutes, they expire and we aut-generate new ones.
			// If you do not want expiring tokens, then set this value to 0
			rotationTimeout : 30,
			// Enable the /cbcsrf/generate endpoint to generate cbcsrf tokens for secured users.
			enableEndpoint : false
		};

		// Generate token key for users
		router.GET( "/generate/:key?", "main.index" );
	}

	/**
	 * Fires upon load
	 */
	function onLoad(){
		// Auto load verifier?
		if( settings.enableAutoVerifier ){
			controller.getInterceptorService()
				.registerInterceptor(
					interceptorClass = "cbcsrf.interceptors.VerifyCsrf",
					interceptorName = "VerifyCsfr@cbcsrf"
				);
		}
	}

	/**
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload(){
	}

	/**
	 * Listen to cbauth events to auto-rotate tokens upon login
	 */
	function postAuthentication( event, interceptData, rc, prc ){
		wirebox.getInstance( "@cbcsrf" ).rotate();
	}

	/**
	 * Listen to cbauth events to auto-rotate tokens upon logout
	 */
	function postLogout( event, interceptData, rc, prc ){
		wirebox.getInstance( "@cbcsrf" ).rotate();
	}

}
