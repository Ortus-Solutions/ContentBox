component {

	function configure(){
		// Api Echo
		route( "/", "echo.index" );

		// Security endpoints
		post( "/login", "auth.login" );
		post( "/logout", "auth.logout" );
		get( "/whoami", "auth.whoami" );

		// Global Settings
		get( "/settings", "settings" );

		// Site Settings
		get( "/sites/:slug/settings", "siteSettings" );

		// Resource Groups
		var except     = "new,edit";
		var sitePrefix = "/sites/:site";
		resources(
			resource: "categories",
			pattern = "#siteprefix#/categories",
			except  : except
		);
		resources( resource: "authors", except: except );
		resources( resource: "sites", except: except );

		// Catch All Resource
		route( "/:anything" ).to( "Echo.onInvalidRoute" );
	}

}
