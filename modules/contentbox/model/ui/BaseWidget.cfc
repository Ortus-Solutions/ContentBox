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
* This is the base class for contentbox widgets
*/
component extends="coldbox.system.Plugin" accessors="true"{
	
	// Shared DI all widgets receive
	property name="categoryService"			inject="id:categoryService@cb";
	property name="entryService"			inject="id:entryService@cb";
	property name="pageService"				inject="id:pageService@cb";
	property name="contentService"			inject="id:contentService@cb";
	property name="contentVersionService"	inject="id:contentVersionService@cb";
	property name="authorService"			inject="id:authorService@cb";
	property name="commentService"			inject="id:commentService@cb";
	property name="contentStoreService"		inject="id:contentStoreService@cb";
	property name="menuService"				inject="id:menuService@cb";
	property name="cb"						inject="id:CBHelper@cb";
	property name="securityService" 		inject="id:securityService@cb";
	property name="html"					inject="coldbox:plugin:HTMLHelper";
	
	// Local Properties
	property name="forgeBoxSlug" type="string" default="";
	property name="category" type="string" default="";
	property name="icon" type="string" default="";

	/**
	* This is the main renderit method you will need to implement in concrete widgets
	*/
	any function renderIt(){
		throw(message="This is a base method that you must implement",type="ContentBox.BaseWidget.BaseClassException");
	}
	
	/*
     * Get this widget's public methods'
     * return array
     */
	array function getPublicMethods() {
		var publicMethods = [];
		var meta = getMetadata( this );
		var method = "";
		for( var i=1; i <= arrayLen( meta.functions ); i++ ){
			method = meta.functions[ i ];
			// ignores?
			if( structKeyExists( method, "cbignore" ) ){
				continue;
			}
			// Add conditions
			if( !listContains( "init,onMissingMethod", method.name ) ) {
				if( !structKeyExists( method, "access" ) || ( structKeyExists( method, "access" ) && !listContains( "private,package", method.access ) ) ) {
					arrayAppend( publicMethods, method );
				}
			}
		}
		return publicMethods;
	}
}