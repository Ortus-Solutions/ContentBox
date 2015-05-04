/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
* Manages ContentBox Admin Themes
*/
component accessors="true" threadSafe singleton{

	// The structure that keeps the registered themes
	property name="themes"		type="struct";
	// Setting Servie
	property name="settingService" inject="settingService@cb";
	
	/**
	* Constructor
	* @wirebox.inject wirebox
	*/
	function init(required wirebox){
		// init themes
		variables.themes = {};
		
		// store factory
		variables.wirebox = arguments.wirebox;
		
		// register core themes
		registerTheme( arguments.wirebox.getInstance("AdminDefaultTheme@cb") );
		
		return this;
	}
	
	/**
	* Get the default admin theme setting
	*/
	string function getDefaultTheme(){
		return settingService.getSetting( "cb_admin_theme" );
	}
	
	/**
	* Get the current theme object
	*/
	contentbox.model.ui.admin.IAdminTheme function getCurrentTheme(){
		return getTheme( getDefaultTheme() );
	}
	
	
	/**
	* Register a new admin theme in ContentBox
	*/
	AdminThemeService function registerTheme(required contentbox.model.ui.admin.IAdminTheme theme){
		variables.themes[ arguments.theme.getName() ] = arguments.theme;	
		return this;
	}
	
	/**
	* UnRegister a theme in ContentBox
	*/
	AdminThemeService function unregisterTheme(required name){
		structDelete( variables.themes, arguments.name );	
		return this;
	}
	
	/**
	* Get an array of registered theme names in alphabetical order
	*/
	array function getRegisteredThemes(){
		return listToArray( listSort( structKeyList( variables.themes ), "textnocase" ) );
	}
	
	/**
	* Get an array of registered theme names in alphabetical order with their display names
	*/
	array function getRegisteredThemesMap(){
		var aThemes = getRegisteredThemes();
		var result = [];
		for( var thisTheme in aThemes ){
			arrayAppend( result, { name=thisTheme, displayName=variables.themes[ thisTheme ].getDisplayName() } );
		}
		return result;
	}
	
	/**
	* Get a registered theme instance
	*/
	contentbox.model.ui.admin.IAdminTheme function getTheme(required name){
		return variables.themes[ arguments.name ];
	}

}
