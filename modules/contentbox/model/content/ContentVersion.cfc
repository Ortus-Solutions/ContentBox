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
* I am a versioned piece of content
*/
component persistent="true" entityname="cbContentVersion" table="cb_contentVersion" batchsize="25" cachename="cbContentVersion" cacheuse="read-write"{

	// DI Injections
	property name="interceptorService"		inject="coldbox:interceptorService" persistent="false";

	// PROPERTIES
	property name="contentVersionID" fieldtype="id" generator="native" setter="false";
	property name="content"    		notnull="true"  ormtype="text" length="8000" default="";
	property name="changelog"  		notnull="false" ormtype="text" length="8000" default="";
	property name="version"			notnull="true"  ormtype="integer"	default="1" dbdefalt="1" index="idx_version";
	property name="createdDate" 	notnull="true"  ormtype="timestamp"	update="false" default="" index="idx_createdDate";
	property name="isActive" 		notnull="true"  ormtype="boolean"   	default="true" dbdefault="0" index="idx_active,idx_contentVersions";

	// M20 -> Author loaded as a proxy and fetched immediately
	property name="author" notnull="true" cfc="contentbox.model.security.Author" fieldtype="many-to-one" fkcolumn="FK_authorID" lazy="true" fetch="join";

	// M20 -> relatedContent
	property name="relatedContent" notnull="true" cfc="contentbox.model.content.BaseContent" fieldtype="many-to-one" fkcolumn="FK_contentID" lazy="true" fetch="join" index="idx_contentVersions";

	// Non-Persistable Properties
	property name="renderedContent" persistent="false";

	/************************************** CONSTRUCTOR *********************************************/

	/**
	* constructor
	*/
	function init(){
		setCreatedDate( now() );
		setIsActive( false );
		setVersion( 1 );
		setContent( '' );
		setChangelog( '' );
		setRenderedContent( '' );
	}

	/************************************** PUBLIC *********************************************/

	/**
	* Shorthand Author name
	*/
	string function getAuthorName(){
		return getAuthor().getName();
	}

	/**
	* Shorthand Author email
	*/
	string function getAuthorEmail(){
		return getAuthor().getEmail();
	}

	/**
	* Get formatted createdDate
	*/
	string function getDisplayCreatedDate(){
		var createdDate = getCreatedDate();
		return dateFormat( createdDate, "mm/dd/yyy" ) & " " & timeFormat(createdDate, "hh:mm:ss tt");
	}

	/**
	* Get parent slug from the related content it belongs to
	*/
	function getParentSlug(){
		if( hasRelatedContent() ){ return getRelatedContent().getSlug(); }
		return "";
	}

	/**
	* Get parent title from the related content it belongs to
	*/
	function getParentTitle(){
		if( hasRelatedContent() ){ return getRelatedContent().getTitle(); }
		return "";
	}

	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getContentVersionID() );
	}

	/**
	* Render version content out
	*/
	any function renderContent(){

		// Check if we need to translate
		if( NOT len(renderedContent) ){
			lock name="contentbox.versionrendering.#getContentVersionID()#" type="exclusive" throwontimeout="true" timeout="10"{
				if( NOT len(renderedContent) ){
					// else render content out, prepare builder
					var b = createObject("java","java.lang.StringBuilder").init( content );

					// announce renderings with data, so content renderers can process them
					var iData = {
						builder = b,
						content	= this
					};
					interceptorService.processState("cb_onContentRendering", iData);

					// save content
					renderedContent = b.toString();
				}
			}
		}

		// renturn translated content
		return renderedContent;
	}

}