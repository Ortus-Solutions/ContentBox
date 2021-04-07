/**
 * Handler to generate csrf tokens for a user according to key
 * This handler is secured by default if using cbGuard or cbSecurity
 */
component secured{

	property name="settings" inject="coldbox:moduleSettings:cbcsrf";

	/**
	 * Generate a token according to passed key
	 */
	function index( event, rc, prc ){
		// If not enabled or in production, just 404 it
		if ( !variables.settings.enableEndpoint ) {
			event.setHTTPHeader( statusCode = 404, statusText = "page not found" );
			return "Page Not Found";
		}

		return csrfToken( rc.key ?: "default" );
	}

}