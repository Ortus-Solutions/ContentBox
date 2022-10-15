/**
 * RESTFul API for visualizing site settings
 */
component extends="baseHandler" secured="SITES_ADMIN" {

	// DI
	property name="settingService" inject="SettingService@contentbox";

	variables.RESERVED_SETTINGS = [];

	/**
	 * Display all site settings
	 *
	 * @tags                     Sites
	 * @responses                contentbox/apidocs/sites/settings/responses.json
	 * @x-contentbox-permissions SITES_ADMIN
	 */
	function index( event, rc, prc ){
		var siteSettings = variables.settingService.getSettingsContainer().sites;

		if ( !siteSettings.keyExists( rc.slug ) ) {
			arguments.event
				.getResponse()
				.setError( true )
				.setStatusCode( arguments.event.STATUS.NOT_FOUND )
				.setStatusText( "The site requested doesn't exist" )
				.addMessage( "The site requested doesn't exist" );
			return;
		}

		event
			.getResponse()
			.setData(
				siteSettings[ rc.slug ].filter( function( key, value ){
					return !arrayContainsNoCase( variables.RESERVED_SETTINGS, arguments.key );
				} )
			);
	}

}
