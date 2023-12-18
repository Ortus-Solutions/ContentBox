component accessors="true" singleton {

	// Dependecnies
	property name="mediaService" inject="mediaService@contentbox";
	property name="log" inject="logbox:logger:{this}";
	property name="cbfs" inject="DiskService@cbfs";
	property name="templateCache" inject="cachebox:template";
	/**
	 * The internal name of the provider
	 */
	property name="name";

	/**
	 * The display name of a provider
	 */
	property name="displayName";

	/**
	 * The description of this provider
	 */
	property name="description";

	/**
	 * Validate if a media requested exists
	 *
	 * @mediaPath.hint the media path to verify if it exists
	 */
	public boolean function mediaExists( required mediaPath ){
		return templateCache.getOrSet( "provider_item_exists_#hash( mediaPath )#", function(){
			var cbfsParts = listToArray( mediaPath, ":" );
			return cbfsParts.len() > 1
			 ? cbfs.get( cbfsParts[ 1 ] ).exists( cbfsParts[ 2 ] )
			 : fileExists( getRealMediaPath( mediaPath ) );
		} );
	}

	/************************************** Package Utility Methods *********************************************/
	package function getPublicURL( required mediaPath ){
		var cbfsParts = listToArray( arguments.mediaPath, ":" );
		return cbfsParts.len() > 1
		 ? cbfs.get( cbfsParts[ 1 ] ).url( cbfsParts[ 2 ] )
		 : cbfs.get( "contentbox" ).url( arguments.mediaPath );
	}

	package function getRealMediaPath( required mediaPath ){
		return mediaService.getCoreMediaRoot( absolute = true ) & "/#arguments.mediaPath#";
	}

}
