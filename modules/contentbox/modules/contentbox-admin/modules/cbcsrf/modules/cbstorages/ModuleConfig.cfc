/**
 * Copyright Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * Module Configuration
 */
component {

	// Module Properties
	this.title 				= "ColdBox Storages";
	this.author 			= "Ortus Solutions";
	this.webURL 			= "https://www.ortussolutions.com";
	this.description 		= "Provides a collection of facade storages for ColdFusion and distributed caching";
	this.version			= "2.5.0+73";
	this.cfmapping			= "cbstorages";

	/**
	 * Configure
	 */
	function configure(){
		settings = {
			// Cache Storage Settings
			cacheStorage : {
				cachename   : "template", // The CacheBox registered cache to store data in
				timeout     : 60 // The default timeout of the session bucket, defaults to 60
			},

			// Cookie Storage settings
			cookieStorage : {
				// Matches the secure attribute of cfcookie, ssl only
				secure 				: false,
				// If yes, sets cookie as httponly so that it cannot be accessed using JavaScripts
				httpOnly			: true,
				// Applicable global cookie domain
				domain 				: "",
				// Use encryption of values
				useEncryption 		: false,
				// The unique seeding key to use: keep it secret, keep it safe
				encryptionSeed 		: "CBStorages",
				// The algorithm to use: https://cfdocs.org/encrypt
				encryptionAlgorithm : "CFMX_COMPAT",
				// The encryption encoding to use
				encryptionEncoding 	: "Base64"
			}
		};
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