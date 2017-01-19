/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
*/
component{

	// Module Properties
	this.title 				= "ContentBox Sitemap Generator";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "Generates XML and HTML Sitemaps for your website";
	this.version			= "3.1.0+@build.number@";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "sitemap";

	function configure(){

		// module settings - stored in modules.name.settings
		settings = {

		};

		// SES Routes
		routes = [
			// Module Entry Point
			{pattern="/", handler="main",action="index"},
			// Convention Route
			{pattern="/:handler/:action?"}
		];

		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = ""
		};

		// Custom Declared Interceptors
		interceptors = [
		];

		// Binder Mappings
		// binder.map( "Alias" ).to( "#moduleMapping#.model.MyService" );

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