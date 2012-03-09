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
* I model a custom HTML content piece
*/
component persistent="true" entityname="cbCustomHTML" table="cb_customHTML" cachename="cbCustomHTML" cacheuse="read-write"{

	// DI Injections
	property name="cachebox" 			inject="cachebox" 					persistent="false";
	property name="settingService"		inject="id:settingService@cb" 		persistent="false";
	property name="interceptorService"	inject="coldbox:interceptorService" persistent="false";

	// PROPERTIES
	property name="contentID" 	fieldtype="id" generator="native" setter="false";
	property name="title"					notnull="true"  length="200";
	property name="slug"					notnull="true"  length="200" unique="true" index="idx_customHTML_slug";
	property name="description"				notnull="false" length="500" default="";
	property name="content" 				notnull="true"  ormtype="text" length="8000";
	property name="createdDate" 			notnull="true"  ormtype="timestamp" update="false";
	property name="cache"					notnull="true"  ormtype="boolean" default="true" dbdefault="1" index="idx_cache";
	property name="cacheTimeout"			notnull="false" ormtype="integer" default="0" dbdefault="0" index="idx_cachetimeout";
	property name="cacheLastAccessTimeout"	notnull="false" ormtype="integer" default="0" dbdefault="0" index="idx_cachelastaccesstimeout";

	// Non-Persistable
	property name="renderedContent" persistent="false";

	/* ----------------------------------------- ORM EVENTS -----------------------------------------  */

	/*
	* In built event handler method, which is called if you set ormsettings.eventhandler = true in Application.cfc
	*/
	public void function preInsert(){
		setCreatedDate( now() );
	}

	/* ----------------------------------------- PUBLIC -----------------------------------------  */

	/**
	* constructor
	*/
	function init(){
		renderedContent = "";
	}

	/**
	* is Loaded
	*/
	boolean function isLoaded(){
		return len( getContentID() ) GT 0;
	}

	/*
	* Validate entry, returns an array of error or no messages
	*/
	array function validate(){
		var errors = [];

		// limits
		title				= left(title,200);
		slug				= left(slug,200);
		description			= left(description,500);

		// Required
		if( !len(title) ){ arrayAppend(errors, "Title is required"); }
		if( !len(slug) ){ arrayAppend(errors, "Slug is required"); }
		if( !len(content) ){ arrayAppend(errors, "Content is required"); }

		return errors;
	}

	/**
	* Get formatted createdDate
	*/
	string function getDisplayCreatedDate(){
		var createdDate = getCreatedDate();
		return dateFormat( createdDate, "mm/dd/yyy" ) & " " & timeFormat(createdDate, "hh:mm:ss tt");
	}

	/**
	* Build content cache keys according to sent content object
	*/
	string function buildContentCacheKey(){
		return "cb-content-customHTML-#getContentID()#";
	}

	/**
	* Verify we can do content caching on this content object using global and local rules
	*/
	boolean function canCacheContent(){
		var settings = settingService.getAllSettings(asStruct=true);

		// check global caching first
		if( settings.cb_customHTML_caching ){
			// check override?
			return ( getCache() ? true : false );
		}
		return false;
	}

	/**
	* Render content out
	*/
	any function renderContent(){
		var settings = settingService.getAllSettings(asStruct=true);

		// caching enabled?
		if( canCacheContent() ){
			// Build Cache Key
			var cacheKey = buildContentCacheKey();
			// Get appropriate cache provider
			var cache = cacheBox.getCache( settings.cb_content_cacheName );
			// Try to get content?
			var cachedContent = cache.get( cacheKey );
			// Verify it exists, if it does, return it
			if( !isNull( cachedContent ) ){ return cachedContent; }
		}

		// Check if we need to translate
		if( NOT len(renderedContent) ){
			lock name="contentbox.customHTMLRendering.#getContentID()#" type="exclusive" throwontimeout="true" timeout="10"{
				if( NOT len(renderedContent) ){
					// else render content out, prepare builder
					var b = createObject("java","java.lang.StringBuilder").init( content );

					// announce renderings with data, so content renderers can process them
					var iData = {
						builder = b,
						customHTML	= this
					};
					interceptorService.processState("cb_onCustomHTMLRendering", iData);

					// save content
					renderedContent = b.toString();
				}
			}
		}

		// caching enabled?
		if( canCacheContent() ){
			// Store content in cache, of local timeouts are 0 then use global timeouts.
			cache.set(cacheKey,
					  renderedContent,
					  (getCacheTimeout() eq 0 ? settings.cb_content_cachingTimeout : getCacheTimeout()),
					  (getCacheLastAccessTimeout() eq 0 ? settings.cb_content_cachingTimeoutIdle : getCacheLastAccessTimeout()) );
		}

		// renturn translated content
		return renderedContent;
	}


}