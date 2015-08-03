/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License" );
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
* Manage's the system's media files
*/
component accessors="true" singleton{
	
	// Dependecnies
	property name="moduleSettings"		inject="coldbox:modulesettings:contentbox-ui";
	property name="log"					inject="logbox:logger:{this}";
	property name="settingService"		inject="settingservice@cb";
	
	// properties
	property name="providers";
	
	/**
	* Constructor
	* @wirebox.inject wirebox
	*/
	MediaService function init(required wirebox){
		// The system media providers
		providers = {};
		
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
		return settingService.getSetting( "cb_media_provider" );
	}
	
	/**
	* Get the default system media provider object
	*/
	function getDefaultProvider(){
		return getProvider( getDefaultProviderName() );
	}
	
	/**
	* Get a named provider object
	*/
	function getProvider(required name){
		return providers[ arguments.name ];
	}
	
	/**
	* Register a new media provider in ContentBox
	*/
	MediaService function registerProvider(required contentbox.models.media.IMediaProvider provider){
		providers[ arguments.provider.getName() ] = arguments.provider;	
		return this;
	}
	
	/**
	* UnRegister a provider in ContentBox
	*/
	MediaService function unRegisterProvider(required name){
		structDelete( providers, arguments.name );	
		return this;
	}
	
	/**
	* Get an array of registered providers in alphabetical order
	*/
	array function getRegisteredProviders(){
		return listToArray( listSort( structKeyList( providers ), "textnocase" ) );
	}
	
	/**
	* Get an array of registered provider names in alphabetical order with their display names
	*/
	array function getRegisteredProvidersMap(){
		var aProviders = getRegisteredProviders();
		var result = [];
		for( var thisProvider in aProviders ){
			arrayAppend( result, { name=thisProvider, 
								   displayName=providers[ thisProvider ].getDisplayName(), 
								   description=providers[ thisProvider ].getDescription() } );
		}
		return result;
	}
	
	/**
	* Get the path to the core media root
	* @absolutePath.hint Return the absolute path or relative
	*/
	function getCoreMediaRoot(required boolean absolute=false){
		var mRoot = settingService.getSetting( "cb_media_directoryRoot" );
		return ( arguments.absolute ? expandPath( mRoot ) : mRoot );
	}
	

	
}