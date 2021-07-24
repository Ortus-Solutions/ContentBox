/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 */
component {

	// Module Properties
	this.title              = "ContentBox Sitemap Generator";
	this.author             = "Ortus Solutions, Corp";
	this.webURL             = "https://www.ortussolutions.com";
	this.description        = "Generates XML, TXT, JSON and HTML Sitemaps for your website";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup   = true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point: /sitemap.(json,html,txt)
	this.entryPoint         = "sitemap";

	function configure(){
		// module settings - stored in modules.name.settings
		settings = {};

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
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload(){
	}

}
