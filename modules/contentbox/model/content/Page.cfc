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
	}

	/************************************** PUBLIC *********************************************/

	/**
	* Get the layout or if empty the default convention of "pages"
	*/
	function getLayoutWithDefault(){
		if( len(getLayout()) ){ return getLayout(); }
		return "pages";
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