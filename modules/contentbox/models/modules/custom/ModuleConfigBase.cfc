/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * This Module loads all of a user's custom assets:
 * - content - media manager assets
 * - themes - custom themes
 * - modules - custom modules
 */
component {

	// Module Properties
	this.title              = "ContentBox Custom Module";
	this.author             = "Ortus Solutions, Corp";
	this.webURL             = "https://www.ortussolutions.com";
	this.description        = "This module is where all custom user assets can be placed and version controlled";
	this.viewParentLookup   = true;
	this.layoutParentLookup = true;
	// URL Entry Point
	this.entryPoint         = "cbCustom";
	// Model Namespace
	this.modelNamespace     = "contentbox-custom";
	// CF Mapping
	this.cfmapping          = "contentbox-custom";
	// ContentBox must be loaded first
	this.dependencies       = [ "contentbox" ];

	/**
	 * Configure Module
	 */
	function configure(){
		// contentbox settings
		settings = {};

		// CB Module Conventions
		conventions = { layoutsLocation : "_themes", viewsLocation : "_themes" };

		// Parent Affected Settings
		parentSettings = {};

		// interceptor settings
		interceptorSettings = {
			// ContentBox Custom Events
			customInterceptionPoints : []
		};

		// interceptors
		interceptors = [];
	}

	/**
	 * Development tier
	 */
	function development(){
	}

	/**
	 * Fired when the module is registered and activated.
	 */
	function onLoad(){
	}

	/**
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload(){
	}

	/************************************** PRIVATE *********************************************/

}
