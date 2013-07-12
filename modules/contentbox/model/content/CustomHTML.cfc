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
	property name="populator" 			inject="wirebox:populator"			persistent="false";
	property name="settingService"		inject="id:settingService@cb" 		persistent="false";
	property name="interceptorService"	inject="coldbox:interceptorService" persistent="false";

	// PROPERTIES
	property name="contentID" 				fieldtype="id" generator="native" setter="false";
	property name="title"					notnull="true"  length="200" default="";
	property name="slug"					notnull="true"  length="200" unique="true" index="idx_customHTML_slug" default="";
	property name="description"				notnull="false" length="500" default="";
	property name="content" 				notnull="true"  ormtype="text" length="8000" default="";
	property name="createdDate" 			notnull="true"  ormtype="timestamp" update="false" index="idx_createdDate";
	property name="cache"					notnull="true"  ormtype="boolean" default="true" dbdefault="1" index="idx_cache";
	property name="cacheTimeout"			notnull="false" ormtype="integer" default="0" dbdefault="0" index="idx_cachetimeout";
	property name="cacheLastAccessTimeout"	notnull="false" ormtype="integer" default="0" dbdefault="0" index="idx_cachelastaccesstimeout";
	property name="markup"					notnull="true" length="100" default="html" dbdefault="'HTML'";
	property name="isPublished" 			notnull="true"  ormtype="boolean" default="true" dbdefault="1" index="idx_published,idx_search";
	property name="publishedDate"			notnull="false" ormtype="timestamp" index="idx_published,idx_publishedDate";
	property name="expireDate"				notnull="false" ormtype="timestamp" default="" index="idx_expireDate";
	
	// M20 -> creator loaded as a proxy and fetched immediately
	property name="creator" notnull="false" cfc="contentbox.model.security.Author" fieldtype="many-to-one" fkcolumn="FK_authorID" lazy="true" fetch="join";
	
	// Non-Persistable
	property name="renderedContent" persistent="false";

	/* ----------------------------------------- ORM EVENTS -----------------------------------------  */

	public void function preInsert(){
		setCreatedDate( now() );
	}

	/* ----------------------------------------- PUBLIC -----------------------------------------  */

	/**
	* constructor
	*/
	function init(){
		createdDate		= now();
		publishedDate	= "";
		expireDate		= "";
		renderedContent = "";
		
		return this;
	}
	
	/**
	* Get memento representation
	*/
	function getMemento(){
		var pList = listToArray( "contentID,title,slug,description,content,createdDate,cache,cacheTimeout,cacheLastAccessTimeout,markup,isPublished,publishedDate,expireDate" );
		var result = {};
		
		for(var thisProp in pList ){
			if( structKeyExists( variables, thisProp ) ){
				result[ thisProp ] = variables[ thisProp ];	
			}
			else{
				result[ thisProp ] = "";
			}
		}
		
		// Do Author Relationship
		if( hasCreator() ){
			result[ "creator" ] = {
				creatorID = getCreator().getAuthorID(),
				firstname = getCreator().getFirstname(),
				lastName = getCreator().getLastName(),
				email = getCreator().getEmail(),
				username = getCreator().getUsername(),
				role = getCreator().getRole().getRole()
			};
		}
		else{
			result[ "creator" ] = {};
		}
		
		return result;
	}

	/**
	* is Loaded
	*/
	boolean function isLoaded(){
		return len( getContentID() ) GT 0;
	}
	
	/**
	* Bit that denotes if the content has expired or not, in order to be expired the content must have been published as well
	*/
	boolean function isExpired(){
		return ( isContentPublished() AND !isNull(expireDate) AND expireDate lte now() ) ? true : false;
	}

	/**
	* Bit that denotes if the content has been published or not
	*/
	boolean function isContentPublished(){
		return ( getIsPublished() AND !isNull( publishedDate ) AND getPublishedDate() LTE now() ) ? true : false;
	}

	/**
	* Bit that denotes if the content has been published or not in the future
	*/
	boolean function isPublishedInFuture(){
		return ( getIsPublished() AND getPublishedDate() GT now() ) ? true : false;
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
	* Get display publishedDate
	*/
	string function getDisplayPublishedDate(){
		var publishedDate = getPublishedDate();
		return dateFormat( publishedDate, "mm/dd/yyyy" ) & " " & timeFormat(publishedDate, "hh:mm:ss tt");
	}
	
	/**
	* Get display publishedDate
	*/
	string function getPublishedDateForEditor(boolean showTime=false){
		var pDate = getPublishedDate();
		if( isNull(pDate) ){ pDate = now(); }
		// get formatted date
		var fDate = dateFormat( pDate, "yyyy-mm-dd" );
		if( arguments.showTime ){
			fDate &=" " & timeFormat(pDate, "hh:mm:ss tt");
		}
		return fDate;
	}

	/**
	* Get display expireDate
	*/
	string function getExpireDateForEditor(boolean showTime=false){
		var pDate = getExpireDate();
		if( isNull(pDate) ){ pDate = ""; }
		// get formatted date
		var fDate = dateFormat( pDate, "yyyy-mm-dd" );
		if( arguments.showTime ){
			fDate &=" " & timeFormat(pDate, "hh:mm:ss tt");
		}
		return fDate;
	}
	
	/**
	* add published timestamp to property
	*/
	any function addPublishedTime(required hour, required minute){
		if( !isDate( getPublishedDate() ) ){ return this; }
		var time = timeformat("#arguments.hour#:#arguments.minute#", "hh:MM:SS tt");
		setPublishedDate( getPublishedDate() & " " & time);
		return this;
	}

	/**
	* add expired timestamp to property
	*/
	any function addExpiredTime(required hour, required minute){
		if( !isDate( getExpireDate() ) ){ return this; }
		var time = timeformat("#arguments.hour#:#arguments.minute#", "hh:MM:SS tt");
		setExpireDate( getExpireDate() & " " & time);
		return this;
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
					// save content
					renderedContent = renderContentSilent();
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
	
	/**
	* Renders the content silently so no caching, or extra fluff is done, just content translation rendering.
	* @content.hint The content markup to translate, by default it uses the active content version's content
	*/
	any function renderContentSilent(any content=getContent()){
		// render content out, prepare builder
		var b = createObject("java","java.lang.StringBuilder").init( arguments.content );

		// announce renderings with data, so content renderers can process them
		var iData = {
			builder = b,
			customHTML = this
		};
		interceptorService.processState("cb_onCustomHTMLRendering", iData);

		// return processed content
		return b.toString();
	}

	/**
	* Shorthand Creator name
	*/
	string function getCreatorName(){
		if( hasCreator() ){
			return getCreator().getName();
		}
		return '';
	}

	/**
	* Shorthand Creator email
	*/
	string function getCreatorEmail(){
		if( hasCreator() ){
			return getCreator().getEmail();
		}
		return '';
	}
	
	/**
	* Wipe primary key, and descendant keys, and prepare for cloning of entire hierarchies
	* @author.hint The author doing the cloning
	* @original.hint The original content object that will be cloned into this content object
	* @originalService.hint The ContentBox content service object used
	* @publish.hint Publish pages or leave as drafts
	*/
	CustomHTML function prepareForClone(required any author,
										 required any original,
										 required any originalService,
										 required boolean publish){
		// set not published
		setIsPublished( arguments.publish );
		// reset creation date
		setCreatedDate( now() );
		setPublishedDate( now() );
		// Update from original
		setCreator( arguments.author );
		populator.populateFromStruct( target=this, 
									  memento=arguments.original.getMemento(), 
									  exclude="contentID,creator,title,slug,createdDate,isPublished,publishedDate", 
									  composeRelationships=false, 
									  nullEmptyInclude="expireDate" );
				
		// evict original entity, just in case
		arguments.originalService.evictEntity( arguments.original );

		return this;
	}

}