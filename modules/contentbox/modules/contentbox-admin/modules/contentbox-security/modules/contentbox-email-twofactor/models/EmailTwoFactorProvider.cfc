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

}