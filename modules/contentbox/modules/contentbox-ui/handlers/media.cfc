/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Handles media services
 */
component singleton {

	// DI
	property name="mediaService" inject="id:mediaService@contentbox";
	property name="settingService" inject="id:settingService@contentbox";

	/**
	 * Deliver Media
	 */
	function index( event, rc, prc ){
		// Param cache purge
		event.paramValue( "cbcache", "false" );
		if ( !isBoolean( rc.cbcache ) ) {
			rc.cbcache = false;
		}

		// Get the requested media path
		var replacePath = ( len( prc.cbEntryPoint ) ? "#prc.cbEntryPoint#/" : "" ) & event.getCurrentRoute();
		prc.mediaPath   = trim(
			replaceNoCase(
				urlDecode( event.getCurrentRoutedURL() ),
				replacePath,
				""
			)
		);
		prc.mediaPath = reReplace( prc.mediaPath, "\/$", "" );

		// Determine if ColdBox is doing a format extension detection?
		if ( structKeyExists( rc, "format" ) && len( rc.format ) ) {
			prc.mediaPath &= ".#rc.format#";
		}

		// Get the media provider
		var mediaProvider = mediaService.getDefaultProvider();
		// Check if media path detected
		if ( !len( prc.mediaPath ) OR !mediaProvider.mediaExists( prc.mediaPath ) ) {
			// return invalid media
			return invalidMedia( event, rc, prc );
		}

		// Announce media delivery
		var iData = { mediaPath : prc.mediaPath, mediaProvider : mediaProvider };
		announce( "cbui_onMediaRequest", iData );

		// Media Caching Headers
		if ( !rc.cbcache and settingService.getSetting( "cb_media_provider_caching" ) ) {
			// Set expiration for one year in advanced
			event
				.setHTTPHeader( name = "expires", value = "#getHTTPTimeString( dateAdd( "yyyy", 1, now() ) )#" )
				.setHTTPHeader( name = "pragma", value = "cache" )
				.setHTTPHeader( name = "cache-control", value = "public, max-age=2592000" );
		} else {
			event
				.setHTTPHeader( name = "expires", value = "#getHTTPTimeString( now() )#" )
				.setHTTPHeader( name = "pragma", value = "no-cache" )
				.setHTTPHeader( name = "cache-control", value = "no-cache, no-store, must-revalidate" );
		}

		// Deliver it baby!
		mediaProvider.deliverMedia( prc.mediaPath );
	}

	/************************************** PRIVATE *********************************************/

	// Invalid Media
	private function invalidMedia( event, rc, prc ){
		// Announce invalid media
		var iData = { mediaPath : prc.mediaPath };
		announce( "cbui_onInvalidMediaRequest", iData );
		// Render invalid media
		event.renderData(
			data       = "<h1>404: Requested path not found</h1>",
			statusCode = "404",
			statusText = "Requested Path Not Found"
		);
	}

}
