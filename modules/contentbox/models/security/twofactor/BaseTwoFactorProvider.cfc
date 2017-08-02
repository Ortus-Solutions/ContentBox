/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* This is a base class all two-factor authenticators can leverage for basic functionality
* 
* All Providers get access to global injected services
* - log
* - settingService
* - renderer
* - CBHelper
*/
component{

	// DI
	property name="log" 				inject="logbox:logger:{this}";
	property name="settingService"		inject="settingService@cb";
	property name="renderer"			inject="provider:ColdBoxRenderer";
	property name="CBHelper"			inject="id:CBHelper@cb";
	
	/**
	 * Constructor
	 */
	function init(){
		return this;
	}

	/**
	 * Get all system settings
	 */
	struct function getAllSettings(){
		return settingService.getAllSettings( asStruct = true );
	}

}