/**
* ContentBox main module configuration
*/
component {
	
	// Module Properties
	this.title 				= "contentbox-installer";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "The ContentBox installer module";
	this.version			= "1.0";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	this.entryPoint			= "cbinstaller";
	
	function configure(){
		
		// layout settings
		layoutSettings = {
			defaultLayout = "simple.cfm"
		};
		
		// SES Routes
		routes = [
			{pattern="/", handler="home", action="index"},
			{pattern="/install", handler="home", action="install"},
			{pattern="/finished", handler="home", action="finished"},
			{pattern="/:handler/:action?"}	
		];
		
		// Binder
		binder.map("InstallerService@cbi").to("#moduleMapping#.model.InstallerService");
		binder.map("SetupBean@cbi").to("#moduleMapping#.model.Setup");
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