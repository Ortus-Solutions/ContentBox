/**
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