/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Deliver file via pagecontext forward
 */
component accessors="true" extends="BaseProvider" singleton {

	/**
	 * Constructor
	 */
	any function init(){
		variables.name        = "ForwardMediaProvider";
		variables.displayName = "Forward Media Provider";
		variables.description = "This provider will forward to the real physical location in the server for the media path requested via the internal servlet
		page context, so no real media path URL will be shown to the user. Use only if the media root is web accessible and a relative web root path, so double check your media root.";
		return this;
	}

	/**
	 * Deliver the media
	 *
	 * @mediaPath.hint the media path to deliver back to the user
	 */
	any function deliverMedia( required mediaPath ){

		var publicURL = getPublicURL( arguments.mediaPath );

		var connection = createObject('java', 'java.net.URL')
							.init( publicURL )
							.openConnection();
		var response = structKeyExists( server, "lucee" ) ? getPageContext().getResponse()  : getPageContext().getResponse().getResponse();

		var outputStream = response.getOutputStream();

		try{
			var inputStream = connection.getInputStream();
		} catch( any e ){
			connection.disconnect();
			rethrow;
		}


		response.setStatus( connection.getResponseCode(), connection.getResponseMessage() );

		response.setContentType( createObject( "java", "java.net.URLConnection" ).guessContentTypeFromName( listLast( publicURL, "/" ) ) );

		if( connection.getResponseCode() > 399 ){
			response.flushBuffer();
			inputStream.close();
			abort;
		}

		try{
			while( true ){
				try{
					var remaining = inputStream.available();
					if( remaining == 0 ) break;
					var chunkSize = remaining > 1024 ? 1024 : remaining;
					var buffer = createObject( "java", "java.nio.ByteBuffer" ).allocate( chunkSize );
					var bytesRead = inputStream.read( buffer.array() );
					outputStream.write( buffer.array(), javaCast('int', 0), bytesRead );
					outputStream.flush();
				} catch( java.net.SocketException e ){
					// Connection reset by peer: socket write error
					break;
				}
			}
		} finally {
			if( !isNull( inputStream ) ) inputStream.close();
			if( !isNull( connection ) ) connection.disconnect();
			response.flushBuffer();
			// abort so CF does not choke.
			abort;
		}
	}

}
