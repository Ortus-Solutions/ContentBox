/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ContentBox Admin CKEditor Module
*/
component {

	// Module Properties
	this.title 				= "ContentBox CKEditor";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "https://www.ortussolutions.com";
	this.description 		= "ContentBox CKEditor Module";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	this.entryPoint			= "cbadmin/ckeditor";
	this.dependencies 		= [ "contentbox-admin" ];

	/**
	* Configure
	*/
	function configure(){

		// SES Routes
		routes = [
			{ pattern="/:handler/:action?" }
		];

		// Custom Declared Points
		interceptorSettings = {
			// CB Admin Custom Events
			customInterceptionPoints = [
				"cbadmin_ckeditorToolbar",
				"cbadmin_ckeditorExtraPlugins",
				"cbadmin_ckeditorExtraConfig",
				"cbadmin_ckeditorContentsCss"
			]
		};

		// interceptors
		interceptors = [ ];
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		var editorService = wirebox.getInstance( "EditorService@cb" );
		editorService.registerEditor( wirebox.getInstance( "CKEditor@contentbox-ckeditor" ) );
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		var editorService = wirebox.getInstance( "EditorService@cb" );
		editorService.unregisterEditor( 'ckeditor' );
	}

}