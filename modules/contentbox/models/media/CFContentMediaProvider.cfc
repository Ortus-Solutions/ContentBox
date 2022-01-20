/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Deliver file via cfcontent
 */
component
	accessors ="true"
	implements="contentbox.models.media.IMediaProvider"
	singleton
{

	// Dependecnies
	property name="mediaService" inject="mediaService@contentbox";
	property name="log" inject="logbox:logger:{this}";
	property name="requestService" inject="coldbox:requestService";

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
		return "CFContentMediaProvider";
	}

	/**
	 * Get the display name of a provider
	 */
	function getDisplayName(){
		return "CF Content Media Provider";
	}

	/**
	 * Get the description of this provider
	 */
	function getDescription(){
		return "This provider uses the ColdFusion cfcontent tag to deliver and stream files securely to the user.";
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
		var realPath = getRealMediaPath( arguments.mediaPath );
		// Deliver the file
		variables.requestService
			.getContext()
			.sendFile(
				file        = realPath,
				disposition = "inline",
				mimeType    = getPageContext().getServletContext().getMimeType( realPath )
			);
	}

	/************************************** PRIVATE *********************************************/

	private function getRealMediaPath( required mediaPath ){
		return mediaService.getCoreMediaRoot( absolute = true ) & "/#arguments.mediaPath#";
	}

}
