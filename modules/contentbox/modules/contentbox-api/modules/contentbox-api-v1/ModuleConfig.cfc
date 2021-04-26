/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * ContentBox API Module: version 1.x
 */
component {

	// Module Properties
	this.title          = "ContentBox API v1.x";
	this.author         = "Ortus Solutions, Corp";
	this.webURL         = "https://www.ortussolutions.com";
	this.version        = "@version.number@+@build.number@";
	this.description    = "ContentBox API v1.x Module";
	// Module Entry Point
	this.entryPoint     = "/cbapi/v1";
	// Inherit entry point from parent, so this will be http://{host}:{port}/cbapi/v1
	this.modelNamespace = "contentbox-api-v1";
	this.cfmapping      = "contentbox-api-v1";
	this.dependencies   = [];

	/**
	 * Configure
	 */
	function configure(){
		// module settings - stored in modules.name.settings
		settings = {};

		// Custom Declared Points
		interceptorSettings = { customInterceptionPoints : "" };

		// Custom Declared Interceptors
		interceptors = [];
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

}
