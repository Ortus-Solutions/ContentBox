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
* I represent a content value store
*/
component 	persistent="true" 
			entityname="cbContentStore" 
			table="cb_contentStore" 
			batchsize="25" 
			cachename="cbContentStore" 
			cacheuse="read-write" 
			extends="BaseContent" 
			joinColumn="contentID" 
			discriminatorValue="ContentStore"{

	// Properties
	property name="description"				
			 notnull="false" 
			 length="500" 
			 default="";
	
	/************************************** CONSTRUCTOR *********************************************/

	/**
	* constructor
	*/
	function init(){
		super.init();
		
		categories 		= [];
		customFields	= [];
		renderedContent = "";
		allowComments 	= false;
		description		= "";
		createdDate		= now();
		contentType		= "ContentStore";
		
		return this;
	}

	/************************************** PUBLIC *********************************************/
	
	/**
	* Get a flat representation of this contentStore
	* slugCache.hint Cache of slugs to prevent infinite recursions
	*/
	function getMemento( array slugCache=[] ){
		var pList = listToArray( "description" );
		var result = super.getMemento( argumentCollection=arguments );
		
		// Local Memento Properties
		for(var thisProp in pList ){
			if( structKeyExists( variables, thisProp ) ){
				result[ thisProp ] = variables[ thisProp ];	
			}
			else{
				result[ thisProp ] = "";
			}
		}
		
		return result;
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
	BaseContent function prepareForClone(
		required any author, 
		required any original, 
		required any originalService, 
		required boolean publish,
		required any originalSlugRoot,
		required any newSlugRoot
	){
		// description
		setDescription( arguments.original.getDescription() );
		// do core
		return super.prepareForClone(argumentCollection=arguments);
	}

	/*
	* Validate page, returns an array of error or no messages
	*/
	array function validate(){
		var errors = [];

		// limits
		title			= left(title,200);
		slug			= left(slug,200);
		description		= left(description,500);

		// Required
		if( !len(title) ){ arrayAppend(errors, "Title is required" ); }

		return errors;
	}

}