/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * ContentBox Admin Email Two Factor Authentication Module
 */
component {

	// Module Properties
	this.title        = "ContentBox Email Two Factor";
	this.author       = "Ortus Solutions, Corp";
	this.webURL       = "https://www.ortussolutions.com";
	this.version      = "@version.number@+@build.number@";
	this.description  = "Provides email two factor authentication";
	this.dependencies = [ "contentbox-admin" ];
	this.cfmapping    = "contentbox-email-twofactor";

	/**
	 * Configure
	 */
	function configure(){
		// SES Routes
		routes = [ { pattern : "/:handler/:action?" } ];

		// Custom Declared Points
		interceptorSettings = {
			// CB Admin Custom Events
			customInterceptionPoints : []
		};

		// interceptors
		interceptors = [];
	}

	/**
	 * Fired when the module is registered and activated.
	 */
	function onLoad(){
		// Register this 2 Auth provider with the TwoFactorService
		var twoFactorService = wirebox.getInstance( "TwoFactorService@contentbox" );
		twoFactorService.registerProvider(
			wirebox.getInstance( "EmailTwoFactorProvider@contentbox-email-twofactor" )
		);
	}

	/**
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload(){
		// Like a Ninja, remove yourself
		var twoFactorService = wirebox.getInstance( "TwoFactorService@contentbox" );
		twoFactorService.unregisterProvider( "email" );
	}

}
