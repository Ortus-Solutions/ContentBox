/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
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
	property name="html"					inject="HTMLHelper@coldbox";
	
	// Local Properties
	property name="forgeBoxSlug" type="string" default="";
	property name="category" type="string" default="";
	property name="icon" type="string" default="";

	/**
	* This is the main renderit method you will need to implement in concrete widgets
	*/
	any function renderIt(){
		throw(message="This is a base method that you must implement",type="ContentBox.BaseWidget.BaseClassException" );
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