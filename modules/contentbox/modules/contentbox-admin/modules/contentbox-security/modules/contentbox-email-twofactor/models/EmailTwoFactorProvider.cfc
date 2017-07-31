/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Provides email two factor authentication
*/
component 
	extends="contentbox.models.security.twofactor.BaseTwoFactorProvider"
	implements="contentbox.models.security.twofactor.ITwoFactorProvider"
	singleton{

	variables.ALLOW_TRUSTED_DEVICE = true;

	/**
	 * Constructor
	 */
	function init(){
		return this;
	}

	/**
	* Get the internal name of the provider
	*/
	function getName(){
		return "email";
	}
	
	/**
	* Get the display name of the provider
	*/
	function getDisplayName(){
		return "Email";
	};

	/**
	 * If true, then ContentBox will set a tracking cookie for the authentication provider user browser.
	 * If the user, logs in and the device is within the trusted timespan, then no two-factor authentication validation will occur.
	 */
	boolean function allowTrustedDevice(){
		return variables.ALLOW_TRUSTED_DEVICE;
	}

}