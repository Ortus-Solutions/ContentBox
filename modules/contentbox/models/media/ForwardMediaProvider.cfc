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
		// relocate to it
		getPageContext().forward( getPublicURL( arguments.mediaPath ) );
		// abort so CF does not choke.
		abort;
	}

}
