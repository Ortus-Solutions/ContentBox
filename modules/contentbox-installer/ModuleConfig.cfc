/**
* ContentBox main module configuration
*/
component {
	
	// Module Properties
	this.title 				= "contentbox-installer";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "http://www.ortussolutions.com";
	this.description 		= "The ContentBox installer module";
	this.version			= "3.0.0-beta+@build.number@";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	this.entryPoint			= "cbinstaller";
	
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
		
		// Settings
		settings = {
			languages = [ "de_DE", "en_US", "es_SV", "it_IT", "pt_BR" ]
		};
		
		// SES Routes
		routes = [
			{ pattern="/", handler="home", action="index" },
			{ pattern="/language/:lang", handler="home", action="changelang" },
			{ pattern="/install", handler="home", action="install" },
			{ pattern="/finished", handler="home", action="finished" },
			{ pattern="/:handler/:action?" }	
		];
		
		// Binder
		binder.map( "InstallerService@cbi" ).to( "#moduleMapping#.model.InstallerService" );
		binder.map( "SetupBean@cbi" ).to( "#moduleMapping#.model.Setup" );
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