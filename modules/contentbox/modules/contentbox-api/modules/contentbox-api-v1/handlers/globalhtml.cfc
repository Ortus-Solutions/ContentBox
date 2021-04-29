/**
 * Endpoint to consume the global html elements you can set in the admin
 */
component extends="baseHandler" {

	// DI
	property name="settingService" inject="SettingService@cb";

	/**
	 * Display all system settings
	 */
	function index( event, rc, prc ){
		event
			.getResponse()
			.setData(
				variables.settingService
					.getAllSettings()
					.filter( function( key, value ){
						return reFindNoCase( "^cb\_html\_", arguments.key );
					} )
			);
	}

}
