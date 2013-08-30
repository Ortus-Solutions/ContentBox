/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
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
* The ContentBox Core Theme
*/
component implements="contentbox.model.ui.admin.IAdminTheme" singleton{

	property name="log" 			inject="logbox:logger:{this}";
	property name="moduleConfig" 	inject="coldbox:moduleConfig:contentbox-admin";

	function init(){
		//prc.cbRoot = getContextRoot() & event.getModuleRoot( 'contentbox-admin' );
		return this;
	}
	
	/**
	* Get the internal name of the theme
	*/
	
	string function getName(){
		return "contentbox-default";
	}
	
	/**
	* Get the display name of the theme
	*/
	
	string function getDisplayName(){
		return "ContentBox Default";
	}
	
	/**
	* Get the list of CSS/LESS assets that will be loaded for this theme
	*/
	
	string function getCSS(){
		return getContextRoot() & moduleConfig.mapping & "/includes/css/contentbox.css";
	}
	
	/**
	* Get the list of JavaScript assets that will be loaded for this theme
	*/
	
	string function getJS(){
		return "";
	}
	
}