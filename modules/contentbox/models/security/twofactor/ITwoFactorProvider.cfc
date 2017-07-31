/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* This is the interface to needed to implement two-factor authentication methods for ContentBox
*/
interface{

	/**
	* Get the internal name of a provider, used for registration, internal naming and more.
	*/
	function getName();
	
	/**
	* Get the display name for the provider.  Used in all UI screens
	*/
	function getDisplayName();

	/**
	 * If true, then ContentBox will set a tracking cookie for the authentication provider user browser.
	 * If the user, logs in and the device is within the trusted timespan, then no two-factor authentication validation will occur.
	 */
	boolean function allowTrustedDevice();

}