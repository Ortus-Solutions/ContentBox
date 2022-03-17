/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Unenroll users from two-factor authentication on provider change
 */
component extends="coldbox.system.Interceptor" {

	/**
	 * Configure
	 */
	function configure(){
	}

	/**
	 * Unenrolls all users from two-factor authentication on two-factor provider change
	 */
	public void function cbadmin_preSettingsSave( required any event, required struct data ){
		// Verify settings sent?
		if (
			!data.oldSettings.keyExists( "cb_security_2factorAuth_provider" ) || !data.newSettings.keyExists(
				"cb_security_2factorAuth_provider"
			)
		) {
			return;
		}
		// Verify provider change?
		if ( data.oldSettings.cb_security_2factorAuth_provider != data.newSettings.cb_security_2factorAuth_provider ) {
			queryExecute( "UPDATE cb_author SET is2FactorAuth = 0" );
		}
	}

}
