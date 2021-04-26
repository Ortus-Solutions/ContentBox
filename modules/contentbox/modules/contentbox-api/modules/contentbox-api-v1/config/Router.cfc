component {

	function configure(){
		// Api Echo
		route( "/", "echo.index" );

		// Security endpoints
		post( "/login", "auth.login" );
		post( "/logout", "auth.logout" );
		get( "/whoami", "auth.whoami" );

		// Resource Groups
		var except = "new,edit";
		resources( resource: "permissions", except: except );
		resources( resource: "sites", except: except );

		// Catch All Resource
		route( "/:anything" ).to( "Echo.onInvalidRoute" );
	}

}
