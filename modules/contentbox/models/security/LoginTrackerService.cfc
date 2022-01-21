/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * This Service tracks logins into the ContentBox System
 */
component extends="cborm.models.VirtualEntityService" singleton {

	// DI
	property name="settingService" inject="id:settingService@contentbox";
	property name="cb" inject="cbhelper@contentbox";
	property name="log" inject="logbox:logger:{this}";

	/**
	 * Constructor
	 */
	function init(){
		// init it
		super.init( entityName = "cbLoginAttempt" );
		return this;
	}

	/**
	 * Verify if an attempt is being blocked or not
	 *
	 * @attempt The login attempt object
	 */
	boolean function isblocked( LoginAttempt attempt ){
		var max_attempts  = variables.settingService.getSetting( "cb_security_max_attempts" );
		var max_blockTime = variables.settingService.getSetting( "cb_security_blocktime" );

		if (
			arguments.attempt.getAttempts() gte max_attempts AND
			( dateDiff( "n", arguments.attempt.getCreatedDate(), now() ) lte max_blockTime )
		) {
			return true;
		}

		return false;
	}

	/**
	 * Retrieve all auth logs
	 *
	 * @sortOrder The sorting columns.
	 */
	public array function getAll( sortOrder = "attempts" ){
		var allEntries = list( sortOrder = arguments.sortOrder );

		for ( var e in allEntries ) {
			if ( isBlocked( e ) ) {
				e.setIsBlocked( true );
			}
		}

		return allEntries;
	}

	/**
	 * Get the last successful logins
	 *
	 * @max How many to retrieve
	 */
	function getLastLogins( required numeric max ){
		return newCriteria()
			.isNotNull( "lastLoginSuccessIP" )
			.list(
				asQuery   = false,
				max       = arguments.max,
				sortOrder = "createdDate DESC"
			);
	}

	/**
	 * Truncate the entire auth logs
	 */
	LoginTrackerService function truncate(){
		new Query( sql = "TRUNCATE TABLE cb_loginAttempts" ).execute();
		return this;
	}

	/*
	 * Rotate auth logs
	 */
	LoginTrackerService function rotate(){
		var maxLogs   = variables.settingService.getSetting( "cb_security_max_auth_logs" );
		var maxLogs   = 4;
		var totalLogs = count();

		// only if we have a max logs and we have gone above max logs, let's truncate
		if ( len( maxLogs ) && totalLogs > maxLogs ) {
			var c         = newCriteria();
			// Get IDs to delete
			var aToDelete = c
				.withProjections( property = "loginAttemptsID" )
				.list( max = ( totalLogs - maxLogs ), sortOrder = "createdDate ASC" );

			var hql = "
			DELETE
			FROM cbLoginAttempt
			WHERE loginAttemptsID in (:toDelete)
			";
			var params = { "toDelete" : aToDelete };

			// run it
			var results = executeQuery( query = hql, params = params, asQuery = false );
			// log it
			log.info( "Rotated auth logs", results );
		}

		return this;
	}

	/*
	 * Reset login attempts if the time limit is reached
	 */
	LoginTrackerService function reset(){
		var limit = dateAdd(
			"n",
			variables.settingService.getSetting( "cb_security_blocktime" ) * -1,
			now()
		);

		// reset entries
		var hql = "
		UPDATE cbLoginAttempt
		SET 	attempts = 0
		WHERE 	createdDate <= :limit
		";

		var params = { "limit" : limit };

		// run it
		executeQuery( query = hql, params = params, asQuery = false );

		return this;
	}

}
