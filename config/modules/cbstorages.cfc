component {

	function configure(){
		/**
		 * --------------------------------------------------------------------------
		 * ColdBox Storages
		 * --------------------------------------------------------------------------
		 * ContentBox relies on the Cache Storage for tracking sessions, which delegates to a Cache provider
		 */
		return {
			// Cache Storage Settings
			cacheStorage : {
				// The CacheBox registered cache to store data in
				cachename          : "sessions",
				// The default timeout of the session bucket, defaults to 60 minutes
				timeout            : getSystemSetting( "COLDBOX_SESSION_TIMEOUT", 60 ),
				// The identifierProvider is a closure/udf that will return a unique identifier according to your rules
				// If you do not provide one, then we will search in session, cookie and url for the ColdFusion identifier.
				// identifierProvider : function(){}
				identifierProvider : "" // If it's a simple value, we ignore it.
			},
			// Cookie Storage settings
			cookieStorage : {
				// If browser does not support Secure Sockets Layer (SSL) security, the cookie is not sent.
				// To use the cookie, the page must be accessed using the https protocol.
				secure              : false,
				// If yes, sets cookie as httponly so that it cannot be accessed using JavaScripts
				httpOnly            : true,
				// Domain in which cookie is valid and to which cookie content can be sent from the user's system. By default, the cookie
				// is only available to the server that set it. Use this attribute to make the cookie available to other servers
				domain              : "",
				// Use encryption of values
				useEncryption       : false,
				// The unique seeding key to use: keep it secret, keep it safe
				encryptionSeed      : "",
				// The algorithm to use: https://cfdocs.org/encrypt
				encryptionAlgorithm : "BLOWFISH",
				// The encryption encoding to use
				encryptionEncoding  : "HEX"
			}
		};
	}

}
