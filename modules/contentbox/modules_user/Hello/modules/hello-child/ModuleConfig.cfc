/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * A child module for hello
 */
component {

	// Module Properties
	this.title              = "Hello Child";
	this.author             = "Ortus Solutions, Corp";
	this.webURL             = "https://www.ortussolutions.com";
	this.description        = "This is an awesome hello world module";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup   = true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint         = "Hello-Child";

	function configure(){
		// parent settings
		parentSettings = {};

		// module settings - stored in modules.name.settings
		settings = {};

		// Layout Settings
		layoutSettings = { defaultLayout : "" };

		// datasources
		datasources = {};

		// web services
		webservices = {};

		// SES Routes
		routes = [
			// Module Entry Point
			{ pattern : "/", handler : "main", action : "index" },
			// Convention Route
			{ pattern : "/:handler/:action?" }
		];

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
	 * Fired when the module is activated by ContentBox
	 */
	function onActivate(){
	}

	/**
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload(){
	}

	/**
	 * Fired when the module is deactivated by ContentBox
	 */
	function onDeactivate(){
	}

}
