/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Limits and prevents DOS attacks
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="settingService" inject="id:settingService@contentbox";
	property name="securityService" inject="id:securityService@contentbox";
	property name = "cachebox"			inject = "Cachebox";

	/**
	 * Limiter
	 */
	function onRequestCapture( event, data, buffer ){
		var allSettings = variables.settingService.getAllSettings();

		// If turned off, just exist
		if ( !structKeyExists( allSettings, "cb_security_rate_limiter" ) || allSettings.cb_security_rate_limiter == false ) {
			return false;
		}

		// do we limit bot OR normal requests as well?
		if ( !len( cgi.http_cookie ) OR !allSettings.cb_security_rate_limiter_bots_only ) {
			// limit it now.
			limiter(
				count    = allSettings[ "cb_security_rate_limiter_count" ],
				duration = allSettings[ "cb_security_rate_limiter_duration" ],
				event    = arguments.event,
				settings = allSettings
			);
		}
	}

	/** 
	* Written by Charlie Arehart, charlie@carehart.org, in 2009, updated 2012, modified by Luis Majano 2016
	* - Throttles requests made more than "count" times within "duration" seconds from single IP. 
	* - Duck typed for performance
	* @count	The throttle counter
	* @duration	The time in seconds to limit
	* @event	The request context object
	* @settings	The settings structure
	*/
	private function limiter( count, duration, event, settings ) {
		// Get real IP address of requester
		var realIP 		= variables.securityService.getRealIP();
		var cache 		= cachebox.getDefaultCache();
		var cacheKey 	= 'limiter'&realIP;

		// If first time visit, create record.
		var targetData = cache.get( cacheKey );
		if( isNull( targetData ) ){
			cache.set( cacheKey, { attempts = 1, lastAttempt = now() });
			return this;
		}

		log.debug( "Limit data", targetData );
		//log.info( "DateDiff " & dateDiff( "s", targetData.lastAttempt, Now() ) );
		//log.info( "Within Duration " & dateDiff( "s", targetData.lastAttempt, Now() ) LT arguments.duration );
		
		// Are we executing another request withing our duration in seconds? Ex: Has X seconds passed before last attempt
		if( dateDiff( "s", targetData.lastAttempt, Now() ) LT arguments.duration ){
			// Limit by count?
			if( targetData.attempts GT arguments.count ){

				if( settings.cb_security_rate_limiter_logging && log.canInfo() ){
					// Log it to app logs
					log.info( "'limiter invoked for:','#realIP#',#targetData.attempts#,#cgi.request_method#,'#cgi.SCRIPT_NAME#', '#cgi.QUERY_STRING#','#cgi.http_user_agent#','#targetData.lastAttempt#',#listlen(cgi.http_cookie,";" )#" );
				}
				
				// Log attempt
				targetData.attempts++;
				targetData.lastAttempt = now();
				cache.set( cacheKey, targetData );

				// Do we have a redirect URL setup?
				if( len( settings.cb_security_rate_limiter_redirectURL ) ){
					location( settings.cb_security_rate_limiter_redirectURL, "false", "301" );
					return;
				}

				// Output Message
				writeOutput( 
					replaceNoCase( settings[ "cb_security_rate_limiter_message" ], "{duration}", arguments.duration, "all" ) 
				);
				arguments.event.setHTTPHeader( statusCode="503", statusText="Service Unavailable" )
					.setHTTPHeader( name="Retry-After", value=arguments.duration );

				// No execution anymore.
				event.noExecution();

				// Hard abort;
				abort; 
			} else {
				// Log attempt
				targetData.attempts++;
				targetData.lastAttempt = now();
			}
		} else {
			// Reset attempts counter, since we are in the safe zone, just log the last attempt timestamp
				targetData.attempts = 0;
	       		targetData.lastAttempt = now();
		}

		cache.set( cacheKey, targetData );
		return this;
	}
}
