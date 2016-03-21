/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* This Service tracks logins into the ContentBox System
*/
component extends="cborm.models.VirtualEntityService" singleton{

	// DI
	property name="settingService"		inject="id:settingService@cb";
	property name="cb"					inject="cbhelper@cb";
	property name="log"					inject="logbox:logger:{this}";
	
	/**
	* Constructor
	*/
	function init(){
		// init it
		super.init( entityName="cbLoginAttempt" );
		return this;
	}

	/**
	* Get Real IP, by looking at clustered, proxy headers and locally.
	*/
	function getRealIP(){
		var headers = GetHttpRequestData().headers;

		// Very balanced headers
		if( structKeyExists( headers, 'x-cluster-client-ip' ) ){
			return headers[ 'x-cluster-client-ip' ];
		}
		if( structKeyExists( headers, 'X-Forwarded-For' ) ){
			return headers[ 'X-Forwarded-For' ];
		}

		return len( cgi.remote_addr ) ? cgi.remote_addr : '127.0.0.1';
	}

	/**
	* Verify if an attempt is being blocked or not
	* @attempt The login attempt object
	*/
	boolean function isblocked( LoginAttempt attempt ){
		var max_attempts 	= settingService.getSetting( 'cb_security_max_attempts' );
		var max_blockTime 	= settingService.getSetting( 'cb_security_blocktime' ); 

		if( arguments.attempt.getAttempts() gte max_attempts AND 
			( datediff( 'n', arguments.attempt.getCreatedDate(), now() ) lte max_blockTime ) ){
			return true;
		}
		
		return false;
	}
	
	/**
	* Retrieve all auth logs
	* @sortOrder The sorting columns.
	*/
	public array function getAll( sortOrder = "attempts" ){
		var allEntries = list( sortOrder=arguments.sortOrder, asQuery=false );

		for( var e in allEntries ){
			if( isBlocked( e ) ){
				e.setIsBlocked( true );
			}
		}

		return allEntries;
	}

	/**	
	* Get the last successful logins
	* @max How many to retrieve
	*/
	function getLastLogins( required numeric max ){
		return newCriteria()
			.isNotNull( "lastLoginSuccessIP" )
			.list( asQuery=false, max=arguments.max, sortOrder="createdDate DESC" );
	}

	/**
	* Truncate the entire auth logs
	*/
	LoginTrackerService function truncate(){
		var q = new Query( sql="truncate cb_loginAttempts" ).execute();
		return this;
	}

	/*
	* Rotate auth logs
	*/
	LoginTrackerService function rotate(){
		var maxLogs 	= settingService.getSetting( "cb_security_max_auth_logs" );
		var maxLogs 	= 4;
		var totalLogs  	= count();

		// only if we have a max logs and we have gone above max logs, let's truncate
		if( len( maxLogs ) && totalLogs > maxLogs ){
			var c = newCriteria();
			// Get IDs to delete
			var aToDelete = c.withProjections( property="loginAttemptsID" )
			.list( max=( totalLogs - maxLogs ), sortOrder="createdDate ASC" );

			var hql = "
			DELETE
			FROM cbLoginAttempt
			WHERE loginAttemptsID in (:toDelete)
			";
			var params = {
				"toDelete" = aToDelete
			};

			// run it
			var results = executeQuery( query=hql, params=params, asQuery=false );
			// log it
			log.info( "Rotated auth logs", results );
		}

		return this;
	}

	/*
	* Reset login attempts if the time limit is reached
	*/
	LoginTrackerService function reset(){
		var limit = dateAdd( 'n', settingService.getSetting( 'cb_security_blocktime' ) * -1, now() );

		// reset entries
		var hql = "
		UPDATE cbLoginAttempt
		SET 	attempts = 0
		WHERE 	createdDate <= :limit
		";

		var params = {
			"limit" = limit
		};

		// run it
		executeQuery( query=hql, params=params, asQuery=false );

		return this;
	}	
	 
}