/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * ContentBox installer module
 */
component {

	// Module Properties
	this.title              = "contentbox-installer";
	this.author             = "Ortus Solutions, Corp";
	this.webURL             = "https://www.ortussolutions.com";
	this.description        = "The ContentBox installer module";
	this.viewParentLookup   = true;
	this.layoutParentLookup = true;
	this.entryPoint         = "cbinstaller";
	this.modelNamespace     = "cbi";
	this.dependencies       = [ "contentbox" ];

	function configure(){
		// layout settings
		layoutSettings = { defaultLayout : "simple.cfm" };

		// i18n
		cbi18n = { resourceBundles : { "installer" : "#moduleMapping#/includes/i18n/installer" } };

		// SES Routes
		routes = [
			{ pattern : "/", handler : "home", action : "index" },
			{
				pattern : "/language/:lang",
				handler : "home",
				action  : "changelang"
			},
			{
				pattern : "/install",
				handler : "home",
				action  : "install"
			},
			{
				pattern : "/finished",
				handler : "home",
				action  : "finished"
			},
			{ pattern : "/:handler/:action?" }
		];
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
