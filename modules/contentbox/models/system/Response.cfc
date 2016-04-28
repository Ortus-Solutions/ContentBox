/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* HTTP Response model, spice up as needed
*/
component accessors="true" {

	property name="format" 			type="string" 		default="json";
	property name="data" 			type="any"			default="";
	property name="error" 			type="boolean"		default="false";
	property name="binary" 			type="boolean"		default="false";
	property name="messages" 		type="array";
	property name="location" 		type="string"		default="";
	property name="jsonCallback" 	type="string"		default="";
	property name="jsonQueryFormat" type="string"		default="query";
	property name="contentType" 	type="string"		default="";
	property name="statusCode" 		type="numeric"		default="200";
	property name="statusText" 		type="string"		default="OK";
	property name="errorCode"		type="numeric"		default="0";
	property name="responsetime"	type="numeric"		default="0";
	property name="cachedResponse" 	type="boolean"		default="false";
	property name="headers" 		type="array";

	/**
	* Constructor
	*/
	Response function init(){
		// Init properties
		variables.format 			= "json";
		variables.data 				= "";
		variables.error 			= false;
		variables.binary 			= false;
		variables.messages 			= [];
		variables.location 			= "";
		variables.jsonCallBack 		= "";
		variables.jsonQueryFormat 	= "query";
		variables.contentType 		= "";
		variables.statusCode 		= 200;
		variables.statusText 		=  "OK";
		variables.errorCode			= 0;
		variables.responsetime		= 0;
		variables.cachedResponse 	= false;
		variables.headers 			= [];

		return this;
	}

	/**
	* Add some messages
	* @message Array or string of message to incorporate
	*/
	function addMessage( required any message ){
		if( isSimpleValue( arguments.message ) ){ arguments.message = [ arguments.message ]; }
		variables.messages.addAll( arguments.message );
		return this;
	}

	/**
	* Add a header
	* @name header name
	* @value header value
	*/
	function addHeader( required string name, required string value ){
		arrayAppend( variables.headers, { name=arguments.name, value=arguments.value } );
		return this;
	}

	/**
	* Returns a standard response formatted data packet
	*/
	function getDataPacket() {
		return {
			"error" 		 = variables.error ? true : false,
			"errorcode"		 = variables.errorCode,
			"messages" 		 = variables.messages,
			"data" 			 = variables.data
		};
	}
}