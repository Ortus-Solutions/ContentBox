/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manages Two Factor Authenticators
 */
component accessors="true" threadSafe singleton {

	// DI
	property name="settingService" inject="settingService@contentbox";
	property name="securityService" inject="securityService@contentbox";
	property name="authorService" inject="authorService@contentbox";
	property name="cookieStorage" inject="cookieStorage@cbStorages";
	property name="log" inject="logbox:logger:{this}";

	/**
	 * Providers registry
	 */
	property name="providers" type="struct";

	// Static Properties

	variables.TRUSTED_DEVICE_COOKIE = "contentbox_2factor_device";

	/**
	 * Constructor
	 *
	 * @wirebox.inject wirebox
	 */
	TwoFactorService function init( required wirebox ){
		// init providers
		variables.providers = {};

		// store factory
		variables.wirebox = arguments.wirebox;

		return this;
	}

	/**
	 * Are we forcing global two factor authentication
	 */
	boolean function isForceTwoFactorAuth(){
		// Doing !! to force a boolean
		return !!settingService.getSetting( "cb_security_2factorAuth_force" );
	}

	/**
	 * Get the default system provider name
	 */
	string function getDefaultProvider(){
		return settingService.getSetting( "cb_security_2factorAuth_provider" );
	}

	/**
	 * Get the default system provider object
	 */
	contentbox.models.security.twofactor.ITwoFactorProvider function getDefaultProviderObject(){
		return getProvider( getDefaultProvider() );
	}

	/**
	 * Get the default system trusted device timespan
	 */
	numeric function getTrustedDeviceTimespan(){
		return settingService.getSetting( "cb_security_2factorAuth_trusted_days" );
	}

	/**
	 * Register a new two factor authenticator in ContentBox
	 *
	 * @provider The provider instance to register
	 */
	TwoFactorService function registerProvider(
		required contentbox.models.security.twofactor.ITwoFactorProvider provider
	){
		variables.providers[ arguments.provider.getName() ] = arguments.provider;
		return this;
	}

	/**
	 * UnRegister a provider in ContentBox
	 *
	 * @name The name of the provider to unregister
	 */
	TwoFactorService function unRegisterProvider( required name ){
		structDelete( variables.providers, arguments.name );
		return this;
	}

	/**
	 * Get an array of registered provider names in alphabetical order
	 */
	array function getRegisteredProviders(){
		return listToArray( listSort( structKeyList( variables.providers ), "textnocase" ) );
	}

	/**
	 * Get an array of registered provider names in alphabetical order with their display names
	 */
	array function getRegisteredProvidersMap(){
		var aProviders = getRegisteredProviders();
		var result     = [];
		for ( var thisProvider in aProviders ) {
			arrayAppend(
				result,
				{
					name        : thisProvider,
					displayName : variables.providers[ thisProvider ].getDisplayName()
				}
			);
		}
		return result;
	}

	/**
	 * Get a registered provider instance
	 *
	 * @name The name of the provider
	 */
	contentbox.models.security.twofactor.ITwoFactorProvider function getProvider( required name ){
		return variables.providers[ arguments.name ];
	}

	/**
	 * Check if an provider exists or not
	 *
	 * @name The name of the provider
	 */
	boolean function hasProvider( required name ){
		return structKeyExists( variables.providers, arguments.name );
	}

	/**
	 * Set a trusted device cookie for a user, usually called if the two factor authentication was valid.
	 *
	 * @trustedID The trusted ID to track in the tracking cookie
	 */
	TwoFactorService function setTrustedDevice( required trustedID ){
		cookieStorage.set(
			name    = variables.TRUSTED_DEVICE_COOKIE,
			value   = securityService.encryptIt( arguments.trustedID ),
			expires = getTrustedDeviceTimespan()
		);
		return this;
	}

	/**
	 * Verify if the incoming trusted ID is valid
	 *
	 * @trustedID The trusted ID to verify
	 */
	boolean function isTrustedDevice( required trustedID ){
		var cookieValue = cookieStorage.get( name = variables.TRUSTED_DEVICE_COOKIE, defaultValue = "" );

		try {
			// decrypt the target id
			var targetTrustedID = securityService.decryptIt( cookieValue );
			// Verify they are the same
			if ( targetTrustedID neq arguments.trustedID ) {
				cookieStorage.delete( variables.TRUSTED_DEVICE_COOKIE );
				return false;
			}
			return true;
		} catch ( Any e ) {
			// Errors on decryption
			log.error( "Error decrypting trusted id cookie: #e.message# #e.detail#", cookieValue );
			cookieStorage.delete( variables.TRUSTED_DEVICE_COOKIE );
			return false;
		}
	}

	/**
	 * Can we challenge this author for two factor authentication
	 *
	 * @author The author to challenge or not
	 */
	boolean function canChallenge( required author ){
		var oProvider = getProvider( getDefaultProvider() );
		var results   = false;
		if (
			// Verify if global force is enabled
			isForceTwoFactorAuth()
			OR
			// Verify if user has two factor auth enabled
			arguments.author.getIs2FactorAuth()
		) {
			// Verify if using trusted device options and if device is trusted
			if ( oProvider.allowTrustedDevice() AND isTrustedDevice( arguments.author.getAuthorID() ) ) {
				results = false;
			} else {
				results = true;
			}
		}

		// If we got here, we can't challenge, allow them to continue.
		return results;
	}

	/**
	 * Leverage the default provider to send a challenge to the specific user.
	 * The return is a structure containing an error flag and a messages string.
	 *
	 * @author The author to challenge
	 *
	 * @return struct:{ error:boolean, messages:string }
	 */
	struct function sendChallenge( required author ){
		return getProvider( getDefaultProvider() ).sendChallenge( arguments.author );
	}

	/**
	 * Leverage the default provider to verify a challenge for the specific user.
	 * The return is a structure containing an error flag and a messages string.
	 *
	 * @code   The verification code
	 * @author The author to verify challenge
	 *
	 * @return struct:{ error:boolean, messages:string }
	 */
	struct function verifyChallenge( required string code, required author ){
		return getProvider( getDefaultProvider() ).verifyChallenge( arguments.code, arguments.author );
	}

}
