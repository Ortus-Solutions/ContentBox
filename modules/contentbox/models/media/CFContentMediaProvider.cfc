/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Deliver file via cfcontent
 */
component
	accessors ="true"
	extends="BaseProvider"
	singleton
{

	property name="requestService" inject="coldbox:requestService";

	/**
	 * Constructor
	 */
	any function init(){
		variables.name = "CFContentMediaProvider";
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
		var cbfsParts = listToArray( arguments.mediaPath );
		var context = variables.requestService.getContext();

		context.sendFile(
			file = cbfsParts.len() > 1
					? cbfs.get( cbfsParts[ 1 ] ).getAsBinary( arguments.mediaPath )
					: getRealMediaPath( arguments.mediaPath ),
			disposition = "inline"
		);

	}

}
