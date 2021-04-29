component {

	function configure(){
		// Api Echo
		route( "/", "echo.index" );

		// Security endpoints
		post( "/login", "auth.login" );
		post( "/logout", "auth.logout" );
		get( "/whoami", "auth.whoami" );

		// Settings
		get( "/settings", "settings" );
		get( "/siteSettings/:slug", "siteSettings" );

		// Global HTML
		get( "/globalhtml", "globalhtml" );

		// Resource Groups
		var except = "new,edit";
		resources( resource: "sites", except: except );

		// Catch All Resource
		route( "/:anything" ).to( "Echo.onInvalidRoute" );
	}

}
