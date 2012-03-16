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
* I am a blog entry entity that is amazing
*/
component persistent="true" entityname="cbEntry" table="cb_entry" batchsize="25" cachename="cbEntry" cacheuse="read-write" extends="BaseContent" joinColumn="contentID" discriminatorValue="Entry"{

	// Properties
	property name="excerpt" notnull="false" ormtype="text" default="" length="8000";

	/************************************** CONSTRUCTOR *********************************************/

	/**
	* constructor
	*/
	function init(){
		categories 		= [];
		customFields	= [];
		renderedContent = "";
		createdDate		= now();
	}

	/************************************** PUBLIC *********************************************/

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
		return getExcerpt();
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
		if( !len(title) ){ arrayAppend(errors, "Title is required"); }
		if( !len(slug) ){ arrayAppend(errors, "Slug is required"); }

		return errors;
	}

}