/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * ContentBox API Module
 */
component {

	// Module Properties
	this.title          = "ContentBox API";
	this.author         = "Ortus Solutions, Corp";
	this.webURL         = "https://www.ortussolutions.com";
	this.version        = "@version.number@+@build.number@";
	this.description    = "ContentBox API Module";
	this.modelNamespace = "contentbox-api";
	this.cfmapping      = "contentbox-api";
	this.dependencies   = [];

	/**
	 * Configure Module
	 */
	function configure(){
		// Module Settings
		settings = {};

		// Custom Declared Points
		interceptorSettings = {
			// CB Admin Custom Events
			customInterceptionPoints : []
		};

		// Custom Declared Interceptors
		interceptors = [];
	}

	/*
	 * On Module Load
	 */
	function onLoad(){
	}

}
