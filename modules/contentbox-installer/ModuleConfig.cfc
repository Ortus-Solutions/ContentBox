/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ContentBox installer module
*/
component {
	
	// Module Properties
	this.title 				= "contentbox-installer";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "The ContentBox installer module";
	this.version			= "@version.number@+@build.number@";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	this.entryPoint			= "cbinstaller";
	this.modelNamespace 	= "cbi";
	
	function configure(){
		
		// layout settings
		layoutSettings = {
			defaultLayout = "simple.cfm"
		};
		
		// i18n
		i18n = {
			resourceBundles = {
		    	"installer" = "#moduleMapping#/includes/i18n/installer"
		  	}
		};
		
		// SES Routes
		routes = [
			{ pattern="/", 					handler="home", action="index" },
			{ pattern="/language/:lang", 	handler="home", action="changelang" },
			{ pattern="/install", 			handler="home", action="install" },
			{ pattern="/finished", 			handler="home", action="finished" },
			{ pattern="/:handler/:action?" }	
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