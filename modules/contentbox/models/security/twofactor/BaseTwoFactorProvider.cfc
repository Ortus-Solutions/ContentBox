/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* This is a base class all two-factor authenticators can leverage for basic functionality
*/
component{

	// DI
	property name="log" inject="logbox:logger:{this}";
	
	/**
	 * Constructor
	 */
	function init(){
		return this;
	}

}