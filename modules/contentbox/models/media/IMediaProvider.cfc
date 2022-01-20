/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Interface to implement ContentBox Media Providers
 */
interface {

	/**
	 * The internal name of your media provider
	 */
	function getName();

	/**
	 * Get the display name of a provider
	 */
	function getDisplayName();

	/**
	 * Get the description of this provider
	 */
	function getDescription();

	/**
	 * Validate if a media requested exists
	 *
	 * @mediaPath.hint the media path to verify if it exists
	 */
	boolean function mediaExists( required mediaPath );

	/**
	 * Deliver the media
	 *
	 * @mediaPath.hint the media path to deliver back to the user
	 */
	any function deliverMedia( required mediaPath );

}
