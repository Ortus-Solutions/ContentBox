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
* I am a cms page entity that totally rocks
*/
component persistent="true" entityname="cbPage" table="cb_page" batchsize="25" cachename="cbPage" cacheuse="read-write" extends="BaseContent" joinColumn="contentID" discriminatorValue="Page"{

	// Properties
	property name="layout"			notnull="false" length="200" default="";
	property name="order"			notnull="false" ormtype="integer" default="0" dbdefault="0";
	property name="showInMenu" 		notnull="true"  ormtype="boolean" default="true" dbdefault="1" index="idx_showInMenu";

	/************************************** CONSTRUCTOR *********************************************/

	/**
	* constructor
	*/
	function init(){
		customFields	= [];
		renderedContent = "";
		allowComments 	= false;
		createdDate		= now();
		layout 			= "pages";
		contentType		= "Page";
		
		// INHERITANCE LAYOUT STATIC
		LAYOUT_INHERITANCE_KEY = "-inherit-";
	}

	/************************************** PUBLIC *********************************************/

	/**
	* Get the layout or if empty the default convention of "pages"
	*/
	function getLayoutWithDefault(){
		if( len(getLayout()) ){ return getLayout(); }
		return "pages";
	}
	
	/**
	* Get layout with layout inheritance, if none found return convention of "pages"
	*/
	function getLayoutWithInheritance(){
		var thisLayout = getLayout();
		// check for inheritance and parent?
		if( thisLayout eq LAYOUT_INHERITANCE_KEY AND hasParent() ){
			return getParent().getLayoutWithInheritance();
		}
		// Else return the layout
		return thisLayout;
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
		setLayout( original.getLayout() );
		return super.prepareForClone(argumentCollection=arguments);
	}

	/*
	* Validate page, returns an array of error or no messages
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
		if( !len(title) ){ arrayAppend(errors, "Title is required"); }
		if( !len(layout) ){ arrayAppend(errors, "Layout is required"); }

		return errors;
	}

}