/**
* ********************************************************************************
* Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ********************************************************************************
* Base RESTFul handler spice up as needed.
* This handler will create a Response model and prepare it for your actions to use
* to produce RESTFul responses.
*/
component extends="coldbox.system.EventHandler"{

	// Global Used DI
	property name="settingService"	inject="settingService@cb";
	property name="cbMessagebox" 	inject="messagebox@cbmessagebox";

	// Pseudo "constants" used in API Response/Method parsing
	property name="METHODS";
	property name="STATUS";

	// Verb aliases - in case we are dealing with legacy browsers or servers ( e.g. IIS7 default )
	METHODS = {
		"HEAD" 		: "HEAD",
		"GET" 		: "GET",
		"POST" 		: "POST",
		"PATCH" 	: "PATCH",
		"PUT" 		: "PUT",
		"DELETE" 	: "DELETE"
	};

	// HTTP STATUS CODES
	STATUS = {
		"CREATED" 				: 201,
		"ACCEPTED" 				: 202,
		"SUCCESS" 				: 200,
		"NO_CONTENT" 			: 204,
		"RESET" 				: 205,
		"PARTIAL_CONTENT" 		: 206,
		"BAD_REQUEST" 			: 400,
		"NOT_AUTHORIZED" 		: 403,
		"NOT_AUTHENTICATED" 	: 401,
		"NOT_FOUND" 			: 404,
		"NOT_ALLOWED" 			: 405,
		"NOT_ACCEPTABLE" 		: 406,
		"TOO_MANY_REQUESTS" 	: 429,
		"EXPECTATION_FAILED" 	: 417,
		"INTERNAL_ERROR" 		: 500,
		"NOT_IMPLEMENTED" 		: 501
	};

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 		= "";
	this.prehandler_except 		= "";
	this.posthandler_only 		= "";
	this.posthandler_except 	= "";
	this.aroundHandler_only 	= "";
	this.aroundHandler_except 	= "";

	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='#METHODS.POST#,#METHODS.DELETE#',index='#METTHOD.GET#'}
	this.allowedMethods = {
		"index" 	: METHODS.GET,
		"get" 		: METHODS.GET,
		"create" 	: METHODS.POST,
		"list" 		: METHODS.GET,
		"update" 	: METHODS.PUT & "," & METHODS.PATCH,
		"delete" 	: METHODS.DELETE
	};

	/**
	* Around handler for all actions it inherits
	*/
	function aroundHandler( event, rc, prc, targetAction, eventArguments ){
		try{
			// start a resource timer
			var stime = getTickCount();
			// prepare our response object
			prc.response = getModel( "Response@cb" );
			// prepare argument execution
			var args = { event = arguments.event, rc = arguments.rc, prc = arguments.prc };
			structAppend( args, arguments.eventArguments );
			// Incoming Format Detection
			if( structKeyExists( rc, "format") ){
				prc.response.setFormat( rc.format );
			}
			// Execute action
			var actionResults = arguments.targetAction( argumentCollection=args );
		} catch( Any e ){
			// Log Locally
			log.error( "Error calling #event.getCurrentEvent()#: #e.message# #e.detail#", e );

			// Setup General Error Response
			prc.response
				.setError( true )
				.addMessage( "General application error: #e.message#" )
				.setStatusCode( STATUS.INTERNAL_ERROR )
				.setStatusText( "General application error" );

			// Development additions
			if( getSetting( "environment" ) eq "development" ){
				rethrow;
			}
		}

		// Development additions
		if( getSetting( "environment" ) eq "development" ){
			prc.response.addHeader( "x-current-route", event.getCurrentRoute() )
				.addHeader( "x-current-routed-url", event.getCurrentRoutedURL() )
				.addHeader( "x-current-routed-namespace", event.getCurrentRoutedNamespace() )
				.addHeader( "x-current-event", event.getCurrentEvent() );
		}

		// end timer
		prc.response.setResponseTime( getTickCount() - stime );

		// If results detected, just return them, controllers requesting to return results
		if( !isNull( actionResults ) ){
			return actionResults;
		}

		// Verify if controllers doing renderdata overrides? If so, just short-circuit out.
		if( !structIsEmpty( event.getRenderData() ) ){
			return;
		}

		// Get response data
		var responseData = prc.response.getDataPacket();

		// If we have an error flag, render our messages and omit any marshalled data
		if( prc.response.getError() ){
			responseData = prc.response.getDataPacket( reset=true );
		}

		// Did the user set a view to be rendered? If not use renderdata, else just delegate to view.
		if( !len( event.getCurrentView() ) ){

			// Magical Response renderings
			event.renderData(
				type		= prc.response.getFormat(),
				data 		= prc.response.getDataPacket(),
				contentType = prc.response.getContentType(),
				statusCode 	= prc.response.getStatusCode(),
				statusText 	= prc.response.getStatusText(),
				location 	= prc.response.getLocation(),
				isBinary 	= prc.response.getBinary()
			);
		}

		// Global Response Headers
		prc.response.addHeader( "x-response-time", prc.response.getResponseTime() )
				.addHeader( "x-cached-response", prc.response.getCachedResponse() );

		// Response Headers
		for( var thisHeader in prc.response.getHeaders() ){
			event.setHTTPHeader( name=thisHeader.name, value=thisHeader.value );
		}
	}

	/**
	* on localized errors
	*/
	function onError( event, rc, prc, faultAction, exception, eventArguments ){
		// Log Locally
		log.error( "Error in base handler (#arguments.faultAction#): #arguments.exception.message# #arguments.exception.detail#", arguments.exception );

		// Verify response exists, else create one
		if( !structKeyExists( prc, "response" ) ){
			prc.response = getModel( "Response@cb" );
		}

		// Setup General Error Response
		prc.response
			.setError( true )
			.addMessage( "Base Handler Application Error: #arguments.exception.message#" )
			.setStatusCode( STATUS.INTERNAL_ERROR )
			.setStatusText( "General application error" );

		// Development additions
		if( getSetting( "environment" ) neq "development" ){
			// Render Error Out
			event.renderData(
				type		= prc.response.getFormat(),
				data 		= prc.response.getDataPacket( reset=true ),
				contentType = prc.response.getContentType(),
				statusCode 	= prc.response.getStatusCode(),
				statusText 	= prc.response.getStatusText(),
				location 	= prc.response.getLocation(),
				isBinary 	= prc.response.getBinary()
			);
		} else {
			throw( object=exception );
		}

	}

	/**
	* on invalid http verbs
	*/
	function onInvalidHTTPMethod( event, rc, prc, faultAction, eventArguments ){
		// Log Locally
		log.warn( "InvalidHTTPMethod Execution of (#arguments.faultAction#): #event.getHTTPMethod()#", getHTTPRequestData() );
		// Setup Response
		prc.response = getModel( "Response@cb" )
			.setError( true )
			.addMessage( "InvalidHTTPMethod Execution of (#arguments.faultAction#): #event.getHTTPMethod()#" )
			.setStatusCode( STATUS.NOT_ALLOWED )
			.setStatusText( "Invalid HTTP Method" );
		// Render Error Out
		event.renderData(
			type		= prc.response.getFormat(),
			data 		= prc.response.getDataPacket( reset=true ),
			contentType = prc.response.getContentType(),
			statusCode 	= prc.response.getStatusCode(),
			statusText 	= prc.response.getStatusText(),
			location 	= prc.response.getLocation(),
			isBinary 	= prc.response.getBinary()
		);
	}

	/**
	* Invalid method execution
	**/
	function onMissingAction( event, rc, prc, missingAction, eventArguments ){
		// Log Locally
		log.warn( "Invalid HTTP Method Execution of (#arguments.missingAction#): #event.getHTTPMethod()#", getHTTPRequestData() );
		// Setup Response
		prc.response = getModel( "Response@cb" )
			.setError( true )
			.addMessage( "Action '#arguments.missingAction#' could not be found" )
			.setStatusCode( STATUS.NOT_ALLOWED )
			.setStatusText( "Invalid Action" );
		// Render Error Out
		event.renderData(
			type		= prc.response.getFormat(),
			data 		= prc.response.getDataPacket( reset=true ),
			contentType = prc.response.getContentType(),
			statusCode 	= prc.response.getStatusCode(),
			statusText 	= prc.response.getStatusText(),
			location 	= prc.response.getLocation(),
			isBinary 	= prc.response.getBinary()
		);
	}

	/**************************** RESTFUL UTILITIES ************************/

	/**
	* Utility function for miscellaneous 404's
	**/
	private function routeNotFound( event, rc, prc ){

		if( !structKeyExists( prc, "response" ) ){
			prc.response = getModel( "Response@cb" );
		}

		prc.response.setError( true )
			.setStatusCode( STATUS.NOT_FOUND )
			.setStatusText( "Not Found" )
			.addMessage( "The object requested could not be found" );
	}

	/**
	* Utility method for when an expectation of the request failes ( e.g. an expected paramter is not provided )
	**/
	private function onExpectationFailed(
		event 	= getRequestContext(),
		rc 		= getRequestCollection(),
		prc 	= getRequestCollection( private=true )
	){
		if( !structKeyExists( prc, "response" ) ){
			prc.response = getModel( "Response@cb" );
		}

		prc.response.setError( true )
			.setStatusCode( STATUS.EXPECTATION_FAILED )
			.setStatusText( "Expectation Failed" )
			.addMessage( "An expectation for the request failed. Could not proceed" );
	}

	/**
	* Utility method to render missing or invalid authentication credentials
	**/
	private function onAuthenticationFailure(
		event 	= getRequestContext(),
		rc 		= getRequestCollection(),
		prc 	= getRequestCollection( private=true ),
		abort 	= false
	){
		if( !structKeyExists( prc, "response" ) ){
			prc.response = getModel( "Response@cb" );
		}

		log.warn( "Invalid Authentication", getHTTPRequestData() );

		prc.response.setError( true )
			.setStatusCode( STATUS.NOT_AUTHENTICATED )
			.setStatusText( "Invalid or Missing Credentials" )
			.addMessage( "Invalid or Missing Authentication Credentials" );
	}

	/**
	* Utility method to render a failure of authorization on any resource
	**/
	private function onAuthorizationFailure(
		event 	= getRequestContext(),
		rc 		= getRequestCollection(),
		prc 	= getRequestCollection( private=true ),
		abort 	= false
	){
		if( !structKeyExists( prc, "response" ) ){
			prc.response = getModel( "Response@cb" );
		}

		log.warn( "Authorization Failure", getHTTPRequestData() );

		prc.response.setError( true )
			.setStatusCode( STATUS.NOT_AUTHORIZED )
			.setStatusText( "Unauthorized Resource" )
			.addMessage( "Your permissions do not allow this operation" );

		/**
		* When you need a really hard stop to prevent further execution ( use as last resort )
		**/
		if( arguments.abort ){

			event.setHTTPHeader(
				name 	= "Content-Type",
	        	value 	= "application/json"
			);

			event.setHTTPHeader(
				statusCode = "#STATUS.NOT_AUTHORIZED#",
	        	statusText = "Not Authorized"
			);

			writeOutput(
				serializeJSON( prc.response.getDataPacket( reset=true ) )
			);
			flush;
			abort;
		}
	}

}
