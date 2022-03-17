/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Listens to login attempts to keep track of them via the Login Tracker System
 */
component extends="coldbox.system.Interceptor" {

	// DI
	property name="settingService" inject="id:settingService@contentbox";
	property name="securityService" inject="id:securityService@contentbox";
	property name="loginTrackerService" inject="id:loginTrackerService@contentbox";
	property name="cb" inject="cbhelper@contentbox";
	property name="systemUtil" inject="SystemUtil@contentbox";
	property name="messagebox" inject="messagebox@cbMessagebox";

	/**
	 * Configure interceptor
	 */
	function configure(){
		return this;
	}

	/**
	 * Listen to end of requests to do log rotation for auth logs for login events only.
	 */
	function postProcess( event, data ) async="true" eventPattern="security\.doLogin"{
		// Do log rotation
		loginTrackerService.rotate();
	}

	/**
	 * Before login check if user has been blocked. It will verify login attempts
	 * by username and IP address and block accordingly.
	 */
	function cbadmin_preLogin( event, data, buffer ){
		// if disabled, we do not track logins
		if ( !settingService.getSetting( "cb_security_login_blocker" ) ) {
			return;
		}
		// reset attempts if time has expired for current user.
		loginTrackerService.reset();

		// prepare collections
		var prc          = event.getCollection( private = true );
		var realIP       = variables.securityService.getRealIP();
		var realUsername = event.getValue( "username", "" );

		// Try to find by username or IPs being blocked
		var aBlockIPs       = loginTrackerService.findAllByValue( realIP );
		var aBlockUsernames = loginTrackerService.findAllByValue( realUsername );

		prc.oBlockByIP       = ( arrayLen( aBlockIps ) ? aBlockIps[ 1 ] : loginTrackerService.new() );
		prc.oBlockByUsername = ( arrayLen( aBlockUsernames ) ? aBlockUsernames[ 1 ] : loginTrackerService.new() );

		// do checks to prevent login
		var isBlocked = false;
		// which reason?
		var byIP      = false;
		// do checks by username and IP
		if ( !isNull( prc.oBlockByUsername ) and loginTrackerService.isBlocked( prc.oBlockByUsername ) ) {
			isBlocked = true;
		}
		if ( !isNull( prc.oBlockByIP ) and loginTrackerService.isBlocked( prc.oBlockByIP ) ) {
			isBlocked = true;
			byIP      = true;
		}

		// If blocked, relocate
		if ( isblocked ) {
			if ( byIP ) {
				messagebox.warn( cb.r( "messages.ip_blocked@security" ) );
			} else {
				messagebox.warn( cb.r( "messages.user_blocked@security" ) );
			}
			// Log it
			log.warn( "Request blocked (#realIP#;#realUsername#) via login tracker" );
			// Relocate
			relocate( "#prc.cbAdminEntryPoint#.security.login" );
		}
	}

	/**
	 * Listen to successful logins
	 */
	function cbadmin_onLogin( event, data, buffer ){
		// if disabled, we do not track logins
		if ( !settingService.getSetting( "cb_security_login_blocker" ) ) {
			return;
		}
		// get prc
		var prc    = event.getCollection( private = true );
		// get logged in user
		var oUser  = securityService.getAuthorSession();
		// Build entry to log
		var oEntry = loginTrackerService.new( {
			lastLoginSuccessIP : variables.securityService.getRealIP(),
			attempts           : 0,
			value              : oUser.getUsername()
		} );

		// If blocked username get's it right, then log it and clear attempts
		if ( !isNull( prc.oBlockByUsername ) ) {
			oEntry = prc.oBlockByUsername;
		}
		// if found by IP delete his record, we are going with the auth username, if not we will get dup success records
		if ( !isNull( prc.oBlockByIP ) ) {
			loginTrackerService.delete( prc.oBlockByIP );
		}
		// Save logged in user
		oEntry.setLastLoginSuccessIP( variables.securityService.getRealIP() );
		oEntry.setCreatedDate( now() );
		oEntry.setAttempts( 0 );
		loginTrackerService.save( oEntry );
	}

	/**
	 * If logins fails, add entry to database with username and IP,
	 * so we can verify later if they will be blocked by username or ip misuses
	 * the blockByIp and blockByUsername entities are prepared on pre-login
	 */
	void function cbadmin_onBadLogin( event, data, buffer ){
		// if disabled, we do not track logins
		if ( !settingService.getSetting( "cb_security_login_blocker" ) ) {
			return;
		}
		// prepare collections
		var prc          = event.getCollection( private = true );
		var realIP       = variables.securityService.getRealIP();
		var realUsername = event.getValue( "username", "" );

		// make or update entry for IP
		if ( !isNull( prc.oBlockByIP ) ) {
			prc.oBlockByIP.setAttempts( prc.oBlockByIP.getAttempts() + 1 );
		} else {
			prc.oBlockByIP = loginTrackerService.new( { value : realIP, attempts : 1 } );
		}
		// Update date + Log it by ip
		prc.oBlockByIP.setCreatedDate( now() );
		loginTrackerService.save( prc.oBlockByIP );

		// make or update entry for username
		if ( !isNull( prc.oBlockByUsername ) ) {
			prc.oBlockByUsername.setAttempts( prc.oBlockByUsername.getAttempts() + 1 );
		} else {
			prc.oBlockByUsername = loginTrackerService.new( { value : realUsername, attempts : 1 } );
		}
		// Update date + Log it by ip
		prc.oBlockByUsername.setCreatedDate( now() );
		loginTrackerService.save( prc.oBlockByUsername );
	}

}
