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
* Limits and prevents DOS attacks
*/
component extends="coldbox.system.Interceptor"{

	// DI
	property name="settingService"		inject="id:settingService@cb";
	property name="loginTrackerService"	inject="id:loginTrackerService@cb";

	/**
	* Configure
	*/
	function configure(){
		// the limiter data
		variables.limitData = {};
	}
	
	/**
	* Limiter
	*/
	function onRequestCapture( event, interceptData, buffer ){
		// If turned off, just exist
		if( !settingService.getSetting( "cb_security_rate_limiter", false ) ){ return false; }
		// do we limit bot OR normal requests as well?
		if( !len( cgi.http_cookie ) OR !settingService.getSetting( "cb_security_rate_limiter_bots_only" ) ) {
			// limit it now.
			limiter(
				count 		= settingService.getSetting( "cb_security_rate_limiter_count" ),
				duration	= settingService.getSetting( "cb_security_rate_limiter_duration" ),
				event		= arguments.event
			);
		}
	}

	/** 
	* Written by Charlie Arehart, charlie@carehart.org, in 2009, updated 2012
	* - Throttles requests made more than "count" times within "duration" seconds from single IP. 
	* @count The throttle counter
	* @duration The time in seconds to limit
	* @event The request context object
	*/
	private function limiter( count=4, duration=1, required event ) {
		// Get real IP address of requester
		var realIP = loginTrackerService.getRealIP();
		// If first time visit, create record.
		if( !structKeyExists( variables.limitData, realIP ) ){
			variables.limitData[ realIP ] = { attempts = 1, lastAttempt = now() };
			return this;
		}
		var targetData = variables.limitData[ realIP ];
		
		// Limit by duration?
		if( dateDiff( "s", targetData.lastAttempt, Now() ) LT arguments.duration ){
			// Limit by count?
			if( targetData.attempts GT arguments.count) {

				// Output Message
				writeOutput( replaceNoCase( settingService.getSetting( "cb_security_rate_limiter_message" ), "{duration}", arguments.duration, "all" ) );
				arguments.event.setHTTPHeader( statusCode="503", statusText="Service Unavailable" )
					.setHTTPHeader( name="Retry-After", value=arguments.duration );

				// Log it to app logs
				log.info( "'limiter invoked for:','#realIP#',#targetData.attempts#,#cgi.request_method#,'#cgi.SCRIPT_NAME#', '#cgi.QUERY_STRING#','#cgi.http_user_agent#','#targetData.lastAttempt#',#listlen(cgi.http_cookie,";" )#" );

				// Setup counter
				targetData.attempts++;
				targetData.lastAttempt = now();
				
				// No execution anymore.
				event.noExecution();
				// Hard abort;
				abort; 
			} // end by count
			else {
				// Log attempt
               targetData.attempts++;
               targetData.lastAttemp = now();
            }
		} // by duration

		return this;
	}
	
}
