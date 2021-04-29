/**
 * RESTFul CRUD for Settings
 */
component extends="baseHandler" {

	// DI
	property name="settingService" inject="SettingService@cb";

	variables.RESERVED_SETTINGS = [
		"cb_enc_key",
		"cb_salt",
		"cb_site_mail_password"
	];

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
						return !variables.RESERVED_SETTINGS.containsNoCase( arguments.key );
					} )
			);
	}

}
