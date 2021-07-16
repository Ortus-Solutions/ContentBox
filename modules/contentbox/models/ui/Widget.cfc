/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * I represent a new widget to be created in the ContentBox System
 */
component accessors="true" {

	property name="name";
	property name="version";
	property name="description";
	property name="author";
	property name="authorURL";
	property name="category";
	property name="icon";

	Widget function init(){
		variables.name        = "";
		variables.version     = "";
		variables.description = "";
		variables.author      = "";
		variables.authorURL   = "";
		variables.category    = "";
		variables.icon        = "";
		return this;
	}

	/*
	 * Validate entry, returns an array of error or no messages
	 */
	array function validate(){
		var errors    = [];
		var aRequired = listToArray( "name,version,description,author,authorURL" );

		// Required
		for ( var field in aRequired ) {
			if ( !len( variables[ field ] ) ) {
				arrayAppend( errors, "#field# is required" );
			}
		}

		return errors;
	}

}
