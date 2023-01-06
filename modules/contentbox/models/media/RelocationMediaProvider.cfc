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
		variables.name        = "RelocationMediaProvider";
		variables.displayName = "Relocation Media Provider";
		variables.description = "This provider will relocate to the real physical location in the server for the media path requested. Use only
		if the media root is web accessible, so double check your media root.";
		return this;
	}

	/**
	 * Deliver the media
	 *
	 * @mediaPath.hint the media path to deliver back to the user
	 */
	any function deliverMedia( required mediaPath ){
		location(
			url        = getPublicURL( arguments.mediaPath ),
			addToken   = false,
			statusCode = "302"
		);
	}

}
