/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manage's the system's media files
*/
component accessors="true" singleton{
	
	// Dependecnies
	property name="moduleSettings"		inject="coldbox:modulesettings:contentbox-ui";
	property name="log"					inject="logbox:logger:{this}";
	property name="settingService"		inject="settingservice@cb";
	
	/**
	 * ContentBox Providers Map
	 */
	property name="providers" type="struct";

	// Static default media root, just in case it is not loaded.
	variables.DEFAULT_MEDIA_ROOT = "/contentbox-custom/_content";
	
	/**
	* Constructor
	* @wirebox.inject wirebox
	*/
	MediaService function init( required wirebox ){
		// The registered system media providers
		variables.providers = {};
		
		// store factory
		variables.wirebox = arguments.wirebox;
		
		// Register Core Media Providers
		registerProvider( arguments.wirebox.getInstance( "CFContentMediaProvider@cb" ) );
		registerProvider( arguments.wirebox.getInstance( "RelocationMediaProvider@cb" ) );
		registerProvider( arguments.wirebox.getInstance( "ForwardMediaProvider@cb" ) );
		
		return this;
	}
	
	/**
	* Get the default system media provider name
	*/
	function getDefaultProviderName(){
		return variables.settingService.getSetting( "cb_media_provider" );
	}
	
	/**
	* Get the default system media provider object
	*/
	function getDefaultProvider(){
		return getProvider( getDefaultProviderName() );
	}
	
	/**
	* Get a named provider object
	* @name The provider to get,that must be registered
	*/
	function getProvider( required name ){
		return variables.providers[ arguments.name ];
	}
	
	/**
	* Register a new media provider in ContentBox
	* @provider The provider object to register
	*/
	MediaService function registerProvider( required contentbox.models.media.IMediaProvider provider ){
		variables.providers[ arguments.provider.getName() ] = arguments.provider;
		return this;
	}
	
	/**
	* UnRegister a provider in ContentBox
	* @name The name of the provider to unregister
	*/
	MediaService function unRegisterProvider( required name ){
		structDelete( variables.providers, arguments.name );	
		return this;
	}
	
	/**
	* Get an array of registered providers in alphabetical order
	*/
	array function getRegisteredProviders(){
		return listToArray( listSort( structKeyList( variables.providers ), "textnocase" ) );
	}
	
	/**
	* Get an array of registered provider names in alphabetical order with their display names
	*/
	array function getRegisteredProvidersMap(){
		var aProviders 	= getRegisteredProviders();
		var result 		= [];

		for( var thisProvider in aProviders ){
			arrayAppend( 
				result, 
				{ 
					name 		= thisProvider, 
					displayName = variables.providers[ thisProvider ].getDisplayName(), 
					description = variables.providers[ thisProvider ].getDescription() 
				} 
			);
		}

		return result;
	}
	
	/**
	* Get the path to the core media root
	* @absolute Return the absolute path or relative, if absolute then it expands the path.
	*/
	function getCoreMediaRoot( required boolean absolute=false ){
		var mRoot = settingService.getSetting( "cb_media_directoryRoot", variables.DEFAULT_MEDIA_ROOT );
		return ( arguments.absolute ? expandPath( mRoot ) : mRoot );
	}
	
}
