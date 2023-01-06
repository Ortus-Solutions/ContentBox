/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Deliver file via cfcontent
 */
component accessors="true" extends="BaseProvider" singleton {

	property name="requestService" inject="coldbox:requestService";

	/**
	 * Constructor
	 */
	any function init(){
		variables.name        = "CFContentMediaProvider";
		variables.displayName = "CF Content Media Provider";
		variables.description = "This provider uses the ColdFusion cfcontent tag to deliver and stream files securely to the user.";
		return this;
	}

	/**
	 * Deliver the media
	 *
	 * @mediaPath.hint the media path to deliver back to the user
	 */
	any function deliverMedia( required mediaPath ){
		var cbfsParts = listToArray( arguments.mediaPath, ":" );
		var context   = variables.requestService.getContext();
		if ( cbfsParts.len() > 1 ) {
			return variables.cbfs.get( cbfsParts[ 1 ] ).download( cbfsParts[ 2 ] );
		} else {
			var file     = getRealMediaPath( arguments.mediaPath );
			var mimeType = fileGetMimeType( file );
			context.sendFile(
				file        = file,
				disposition = "inline",
				mimeType    = mimeType,
				extension   = listLast( arguments.mediaPath, "." )
			);
		}
	}

}
