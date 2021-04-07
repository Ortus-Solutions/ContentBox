/**
 * Copyright since 2016 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * Service that encapsulates token security against cross site request forgery (csrf)
 */
component accessors="true" singleton {

	/* *********************************************************************
	 **						DI
	 ********************************************************************* */

	property name="settings" inject="coldbox:moduleSettings:cbcsrf";
	property name="cacheStorage" inject="cacheStorage@cbstorages";

	/* *********************************************************************
	 **						Properties
	 ********************************************************************* */

	// key to store CSRF tokens in the cache storage
	property name="tokenStorageKey" type="string";

	/**
	 * Constructor
	 */
	function init(){
		variables.tokenStorageKey = "$CSRFTokens";
		return this;
	}

	/**
	 * Wipes the entire token storages for a user
	 */
	CbCsrf function rotate(){
		variables.cacheStorage.delete( getTokenStorageKey() );
		return this;
	}

	/**
	 * Provides a random token and stores it in cbstorages. You can also provide a specific key to store.
	 *
	 * @key A random token is generated for the key provided.
	 * @forceNew If set to true, a new token is generated every time the function is called. If false, in case a token exists for the key, the same key is returned.
	 *
	 * @return The csrf token
	 */
	public string function generate( string key, boolean forceNew = false ){
		// Get our session csrf data
		var csrfData = cacheStorage.get( getTokenStorageKey(), {} );
		
		// Mixins pass an empty key argument so "default" isn't set and verification fails when using the examples given in readme.md
		if ( isNull( arguments.key ) || !arguments.key.len() ){
			arguments.key = "default";
		}

		// Validate data
		if (
			// Are we forcing it?
			arguments.forceNew ||
			// Has the key been stored before
			!csrfData.keyExists( arguments.key ) ||
			// The token has expired or never, we do an equality as it's faster than isDate() which is a hog
			( csrfData[ arguments.key ].expires != "never" && dateCompare( now(), csrfData[ arguments.key ].expires ) == 1 )
		) {
			// Generate the tokens
			csrfData[ arguments.key ] = {
				"token" : generateNewToken( arguments.key ),
				"created" : now(),
				"expires" : ( variables.settings.rotationTimeout == 0 ? "never" : dateAdd( "n", variables.settings.rotationTimeout, now() ) )
			};
			// Store the tokens
			variables.cacheStorage.set( getTokenStorageKey(), csrfData );
		}

		// Return the token for this key now
		return csrfData[ arguments.key ].token;
	}

	/**
	 * Validates the given token against the same stored in the session for a specific key.
	 *
	 * @token Token that to be validated against the token stored in the session.
	 * @key The key against which the token be searched.
	 *
	 * @return If the token validated
	 */
	public boolean function verify( required string token = "", string key ){
		var csrfData = cacheStorage.get( getTokenStorageKey(), {} );
				
		// Mixins pass an empty key argument so "default" isn't set and verification fails when using the examples given in readme.md
		if ( isNull( arguments.key ) || !arguments.key.len() ){
			arguments.key = "default";
		}
		
		// Verify it
		return (
			csrfData.keyExists( arguments.key ) && // Do we have data for the key
			csrfData[ arguments.key ].token == arguments.token && // The tokens are the same
			( csrfData[ arguments.key ].expires == 'never' || dateCompare( now(), csrfData[ arguments.key ].expires ) == -1) // The token has not expired
		) ? true : false;
	}

	// -------------------------------------- Private --------------------------------------

	/**
	 * Generate a new csrf token
	 *
	 * @key A random key to use to base off the token.
	 *
	 * @return A random token
	 */
	private string function generateNewToken( required string key ){
		// Ensure tokenBase is sufficiently random for this user and could never be guessed
		var tokenBase = "#arguments.key##getRealIP()##randRange( 0, 65535, "SHA1PRNG" )##getTickCount()#";

		// Return a 40 character hash as the new token
		return uCase(
			left( hash( tokenBase & variables.cacheStorage.getSessionKey(), "SHA-256" ), 40 )
		);
	}

	/**
	 * Get Real IP, by looking at clustered, proxy headers and locally.
	 */
	private function getRealIP(){
		var headers = getHTTPRequestData().headers;

		// Very balanced headers
		if ( structKeyExists( headers, "x-cluster-client-ip" ) ) {
			return headers[ "x-cluster-client-ip" ];
		}
		if ( structKeyExists( headers, "X-Forwarded-For" ) ) {
			return headers[ "X-Forwarded-For" ];
		}

		return len( CGI.REMOTE_ADDR ) ? CGI.REMOTE_ADDR : "127.0.0.1";
	}

}
