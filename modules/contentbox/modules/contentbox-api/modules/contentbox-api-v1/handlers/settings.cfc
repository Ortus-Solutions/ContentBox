/**
 * RESTFul API for Settings
 */
component extends="baseHandler" {

	// DI
	property name="settingService" inject="SettingService@contentbox";

	variables.RESERVED_SETTINGS = [
		"cb_enc_key",
		"cb_salt",
		"cb_site_mail_password"
	];

	/**
	 * Display all system settings
	 *
	 * @tags                     Settings
	 * @responses                contentbox/apidocs/settings/index/responses.json
	 * @x-contentbox-permissions SYSTEM_RAW_SETTINGS
	 */
	function index( event, rc, prc ) secured="SYSTEM_RAW_SETTINGS"{
		event
			.getResponse()
			.setData(
				variables.settingService
					.getAllSettings()
					.filter( function( key, value ){
						return !arrayContainsNoCase( variables.RESERVED_SETTINGS, arguments.key );
					} )
			);
	}

}
