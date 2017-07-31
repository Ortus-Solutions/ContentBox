/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manages Two Factor Authenticators
*/
component accessors="true" threadSafe singleton{

	// DI
	property name="settingService" inject="settingService@cb";

	/**
	 * Providers registry
	 */
	property name="providers"	type="struct";
	
	/**
	* Constructor
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
	* Get the default system provider name
	*/
	string function getDefaultProvider(){
		return settingService.getSetting( "cb_security_2factorAuth_provider" );
	}
	
	/**
	* Register a new two factor authenticator in ContentBox
	* @provider The provider instance to register
	*/
	TwoFactorService function registerProvider( required contentbox.models.security.twofactor.ITwoFactorProvider provider ){
		variables.providers[ arguments.provider.getName() ] = arguments.provider;	
		return this;
	}
	
	/**
	* UnRegister a provider in ContentBox
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
		var result = [];
		for( var thisProvider in aProviders ){
			arrayAppend( result, { 
				name        = thisProvider, 
				displayName = variables.providers[ thisProvider ].getDisplayName() 
			} );
		}
		return result;
	}
	
	/**
	* Get a registered provider instance
	* @name The name of the provider
	*/
	contentbox.models.security.twofactor.ITwoFactorProvider function getProvider( required name ){
		return variables.providers[ arguments.name ];
	}

	/**
	* Check if an provider exists or not
	* @name The name of the provider
	*/
	boolean function hasProvider( required name ){
		return structKeyExists( variables.providers, arguments.name );
	}

}