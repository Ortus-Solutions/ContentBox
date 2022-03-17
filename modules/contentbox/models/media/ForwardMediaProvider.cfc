/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Deliver file via pagecontext forward
 */
component
	accessors ="true"
	implements="contentbox.models.media.IMediaProvider"
	singleton
{

	// Dependecnies
	property name="mediaService" inject="mediaService@contentbox";
	property name="log" inject="logbox:logger:{this}";

	/**
	 * Constructor
	 */
	any function init(){
		return this;
	}

	/**
	 * The internal name of the provider
	 */
	function getName(){
		return "ForwardMediaProvider";
	}

	/**
	 * Get the display name of a provider
	 */
	function getDisplayName(){
		return "Forward Media Provider";
	}

	/**
	 * Get the description of this provider
	 */
	function getDescription(){
		return "This provider will forward to the real physical location in the server for the media path requested via the internal servlet
		page context, so no real media path URL will be shown to the user. Use only if the media root is web accessible and a relative web root path, so double check your media root.";
	}

	/**
	 * Validate if a media requested exists
	 *
	 * @mediaPath.hint the media path to verify if it exists
	 */
	boolean function mediaExists( required mediaPath ){
		return fileExists( getRealMediaPath( arguments.mediaPath ) );
	}

	/**
	 * Deliver the media
	 *
	 * @mediaPath.hint the media path to deliver back to the user
	 */
	any function deliverMedia( required mediaPath ){
		// get the real path
		var realPath = mediaService.getCoreMediaRoot() & "/" & arguments.mediaPath;
		// relocate to it
		getPageContext().forward( realPath );
		abort;
		// abort so CF does not choke.
		abort;
	}

	/************************************** PRIVATE *********************************************/

	private function getRealMediaPath( required mediaPath ){
		return mediaService.getCoreMediaRoot( absolute = true ) & "/#arguments.mediaPath#";
	}

}
