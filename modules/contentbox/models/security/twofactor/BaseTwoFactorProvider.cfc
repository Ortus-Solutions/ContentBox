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
 * - siteService
 * - renderer
 * - CBHelper
 */
component {

	// DI
	property name="log" inject="logbox:logger:{this}";
	property name="settingService" inject="settingService@contentbox";
	property name="securityService" inject="securityService@contentbox";
	property name="siteService" inject="siteService@contentbox";
	property name="renderer" inject="coldbox:renderer";
	property name="CBHelper" inject="id:CBHelper@contentbox";

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
		return variables.settingService.getAllSettings();
	}

	/**
	 * Get the default site object
	 *
	 * @return Site
	 */
	function getDefaultSite(){
		return variables.siteService.getDefaultSite();
	}

	/**
	 * Get a discovered site object
	 *
	 * @return Site
	 */
	function discoverSite(){
		return variables.siteService.discoverSite();
	}

}
