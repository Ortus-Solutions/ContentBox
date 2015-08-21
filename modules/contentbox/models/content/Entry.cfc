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
* I am a blog entry entity that is amazing
*/
component persistent="true" entityname="cbEntry" table="cb_entry" batchsize="25" cachename="cbEntry" cacheuse="read-write" extends="BaseContent" joinColumn="contentID" discriminatorValue="Entry"{

	// Properties
	property name="excerpt" notnull="false" ormtype="text" default="" length="8000";
	
	// Non-Persistable Properties
	property name="renderedExcerpt" persistent="false";

	/************************************** CONSTRUCTOR *********************************************/

	/**
	* constructor
	*/
	function init(){
		super.init();

		categories 		= [];
		customFields	= [];
		renderedContent = "";
		renderedExcerpt	= "";
		createdDate		= now();
		contentType		= "Entry";
		
		return this;
	}

	/************************************** PUBLIC *********************************************/
	
	/**
	* Get a flat representation of this entry
	* slugCache.hint Cache of slugs to prevent infinite recursions
	*/
	function getMemento( array slugCache=[] ){
		var result = super.getMemento( argumentCollection=arguments );
		
		// Local Memento Properties
		result[ "excerpt" ] = variables.excerpt;
		
		return result;
	}

	/**
	* has excerpt
	*/
	boolean function hasExcerpt(){
		return len( getExcerpt() ) GT 0;
	}

	/**
	* Render excerpt
	*/
	any function renderExcerpt(){
		
		// Check if we need to translate
		if( NOT len( renderedExcerpt ) ){
			lock name="contentbox.excerptrendering.#getContentID()#" type="exclusive" throwontimeout="true" timeout="10"{
				if( NOT len( renderedExcerpt ) ){
					// render excerpt out, prepare builder
					var b = createObject( "java","java.lang.StringBuilder" ).init( getExcerpt() );
					// announce renderings with data, so content renderers can process them
					var iData = {
						builder = b,
						content	= this
					};
					interceptorService.processState( "cb_onContentRendering", iData);
					// store processed content
					renderedExcerpt = b.toString();
				}
			}
		}
		
		return renderedExcerpt;
	}

	/*
	* Validate entry, returns an array of error or no messages
	*/
	array function validate(){
		var errors = [];

		// limits
		HTMLKeyWords 		= left(HTMLKeywords,160);
		HTMLDescription 	= left(HTMLDescription,160);
		passwordProtection 	= left(passwordProtection,100);
		title				= left(title,200);
		slug				= left(slug,200);

		// Required
		if( !len(title) ){ arrayAppend(errors, "Title is required" ); }
		if( !len(slug) ){ arrayAppend(errors, "Slug is required" ); }

		return errors;
	}
	
	/**
	* Wipe primary key, and descendant keys, and prepare for cloning of entire hierarchies
	* @author.hint The author doing the cloning
	* @original.hint The original content object that will be cloned into this content object
	* @originalService.hint The ContentBox content service object
	* @publish.hint Publish pages or leave as drafts
	* @originalSlugRoot.hint The original slug that will be replaced in all cloned content
	* @newSlugRoot.hint The new slug root that will be replaced in all cloned content
	*/
	BaseContent function prepareForClone(required any author, 
										 required any original, 
										 required any originalService, 
										 required boolean publish,
										 required any originalSlugRoot,
										 required any newSlugRoot){
		if( arguments.original.hasExcerpt() ){
			setExcerpt( arguments.original.getExcerpt() );
		}
		return super.prepareForClone(argumentCollection=arguments);
	}

}