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

		// Catch All Resource
		route( "/:anything" ).to( "Echo.onInvalidRoute" );
	}

}
