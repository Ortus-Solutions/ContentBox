/**
* Copyright Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* This storage the cookie scope and can do complex values as json
*/
component
	accessors="true"
	serializable="false"
	extends="AbstractStorage"
	threadsafe
	singleton
{

	/**
	 * The cookie encryption algorithm
	 */
	property name="encryptionAlgorithm";

	/**
	 * The cookie encryption seed
	 */
	property name="encryptionSeed";

	/**
	 * Are we using encryption
	 */
	property name="encryption" type="boolean" default="false";

	/**
	 * The encryption encoding
	 */
	property name="encryptionEncoding";

	/**
	 * Use secure cookies or not
	 */
	property name="secure" type="boolean";

	/**
	 * The cookie global domain setting
	 */
	property name="domain";

	/**
	 * If yes, sets cookie as httponly so that it cannot be accessed using JavaScript
	 */
	property name="httpOnly" type="boolean";

	/**
	* Settings
	*/
	property name="settings";

	/**
	 * Constructor
	 *
	 * @settings The storage settings struct
	 * @settings.inject coldbox:moduleSettings:cbStorages
	 */
	function init( required settings ){
		// Store settings
		variables.settings 				= arguments.settings;

		// Set settings
		variables.encryptionAlgorithm 	= arguments.settings.cookieStorage.encryptionAlgorithm;
		variables.encryptionSeed 		= arguments.settings.cookieStorage.encryptionSeed;
		variables.encryption 			= arguments.settings.cookieStorage.useEncryption;
		variables.encryptionEncoding 	= arguments.settings.cookieStorage.encryptionEncoding;
		variables.secure 				= arguments.settings.cookieStorage.secure;
		variables.httpOnly				= arguments.settings.cookieStorage.httpOnly;
		variables.domain				= arguments.settings.cookieStorage.domain;


		// Cookie Prefix: used for better filtering and cleanups
		variables.PREFIX = "CBSTORAGE_";

		return this;
	}

	/**
	 * Set a new variable in storage
	 *
	 * @name The name of the data key
	 * @value The value of the data to store
	 * @expires Cookie expiration
	 * @secure If browser does not support Secure Sockets Layer (SSL) security, the cookie is not sent. To use the cookie, the page must be accessed using the https protocol.
	 * @path URL, within a domain, to which the cookie applies; typically a directory. Only pages in this path can use the cookie. By default, all pages on the server that set the cookie can access the cookie.
	 * @domain Domain in which cookie is valid and to which cookie content can be sent from the user's system.
	 * @httpOnly Apply the httpOnly or use the storage default
	 * @sameSite Tells browsers when and how to fire cookies in first-or third-party situations. SameSite is used to identify whether or not to allow a cookie to be accessed. Defaults not set. Available options are strict, lax, or none
	 *
	 * @return cbstorages.models.IStorage
	 */
	CookieStorage function set(
		required name,
		required value,
		any expires,
		boolean secure=variables.secure,
		string path="",
		string domain=variables.domain,
		boolean httpOnly=variables.httpOnly,
        string samesite
	){
		// Serialize Values
		var tmpValue = serializeJSON( arguments.value );

		// Build out key
		arguments.name = buildName( arguments.name );

		// encryption?
		if( variables.encryption ){
			tmpValue = encryptIt( tmpValue );
		}

		// Store cookie with expiration info
		var args = {
			"name" 		: arguments.name,
			"value"		: tmpValue,
			"secure"	: arguments.secure,
			"httpOnly"	: arguments.httpOnly
		};
		// only add expires if existing in arguments to mimic default cookie behaviour
		if ( !isNull( arguments.expires ) ) {
			args[ "expires" ] = arguments.expires;
		}
		// only add samesite if existing in arguments to mimic default cookie behaviour
		if ( !isNull( arguments.samesite ) ) {
			args[ "samesite" ] = arguments.samesite;
		}

		// Domain + path info
		if( len( arguments.path ) && !len( arguments.domain ) ){
			throw(
				type 	= "CookieStorage.MissingDomainArgument",
				message = "If you specify path, you must also specify domain."
			);
		} else if( len( arguments.path ) && len( arguments.domain ) ){
			args[ "path" ] 		= arguments.path;
			args[ "domain" ] 	= arguments.domain;
		} else if( len( arguments.domain ) ){
			args[ "domain" ] = arguments.domain;
		}

		cookie[ arguments.name ] = tmpValue;
		cfcookie( attributeCollection=args );

		return this;
	}


	/**
	 * Get a new variable in storage if it exists, else return default value, else will return null.
	 *
	 * @name The name of the data key
	 * @defaultValue The default value to return if not found in storage
	 */
	any function get( required name, defaultValue ){

		// Check existence
		if( !exists( arguments.name ) ){
			// check default value
			if( !isNull( arguments.defaultValue ) ){
				return arguments.defaultValue;
			}
			// return null
			return;
		}

		// Build out key
		arguments.name = buildName( arguments.name );

		// Get value
		var thisValue = cookie[ arguments.name ];

		// encryption?
		if( variables.encryption ){
			thisValue = decryptIt( thisValue );
		}

		// Deserialize?
		if( isJson( thisValue ) ){
			thisValue = deserializeJSON( thisValue );
		}

		return thisValue;
	}

	/**
	 * Delete a variable in the storage
	 *
	 * @name The name of the data key
	 * @path URL, within a domain, to which the cookie applies; typically a directory. Only pages in this path can use the cookie. By default, all pages on the server that set the cookie can access the cookie.
	 * @domain Domain in which cookie is valid and to which cookie content can be sent from the user's system.
	 *
	 */
	boolean function delete(
		required name,
		string path="",
		string domain=variables.domain,
		boolean secure=variables.secure
	){

		if( exists( arguments.name ) ){
			// Build out key
			arguments.name = buildName( arguments.name );
			// Prepare cookie keys
			var args = {
				"name"		: arguments.name,
				"expires"	: "NOW",
				"value"		: "",
				"secure"	: arguments.secure
			};

			// Domain + path info
			if( len( arguments.path ) && !len( arguments.domain ) ){
				throw(
					type 	= "CookieStorage.MissingDomainArgument",
					message = "If you specify path, you must also specify domain."
				);
			} else if( len( arguments.path ) && len( arguments.domain ) ){
				args[ "path" ] 		= arguments.path;
				args[ "domain" ] 	= arguments.domain;
			} else if( len( arguments.domain ) ){
				args[ "domain" ] = arguments.domain;
			}

			cfcookie( attributeCollection=args );
			structDelete( cookie, arguments.name );

			return true;
		}

		return false;
	}

	/**
	 * Verifies if the named storage key exists
	 *
	 * @name The name of the data key
	 */
	boolean function exists( required name ){
		// Build out key
		arguments.name = buildName( arguments.name );
		// Check it
		return super.exists( arguments.name );
	}

	/**
	 * Clear the entire storage
	 *
	 * @return cbstorages.models.IStorage
	 */
	CookieStorage function clearAll(){
		for( var thisCookie in cookie ){
			if( findNoCase( variables.PREFIX, thisCookie, 1 ) ){
				structDelete( cookie, thisCookie );
			}
		}
		return this;
	}

	/**
	 * Get the entire storage scope from cache. If it does not exist, then create the default bucket
	 */
	struct function getStorage(){
		return cookie.filter( function( key, value ){
			return findNoCase( variables.PREFIX, key, 1 );
		} );
	}

	/**
	 * Remove the storage completely, different from clear, this detaches the entire storage
	 *
	 * @return cbstorages.models.IStorage
	 */
	CookieStorage function removeStorage(){
		return clearAll();
	}

	/**
	 * Check if storage exists
	 */
	boolean function storageExists(){
		return isDefined( "cookie" );
	}

	/**
	 * Create the storage.
	 * This initializes an empty session in the cache.
	 *
	 * @return cbstorages.models.IStorage
	 */
	CookieStorage function createStorage(){
		return this;
	}

	/************************ PRIVATE ************************/

	/**
	 * Encrypt the value
	 *
	 * @target The target to encrypt
	 */
	private function encryptIt( required target ){
		return encrypt(
			arguments.target,
			getEncryptionSeed(),
			getEncryptionAlgorithm(),
			getEncryptionEncoding()
		);
	}

	/**
	 * Decrypt the incoming target
	 *
	 * @target
	 */
	private function decryptIt( required target ){
		return decrypt(
			arguments.target,
			getEncryptionSeed(),
			getEncryptionAlgorithm(),
			getEncryptionEncoding()
		);
	}

	/**
	 * Build out the cookie name
	 */
	private function buildName( required name ){
		return variables.PREFIX & ucase( arguments.name );
	}

}
