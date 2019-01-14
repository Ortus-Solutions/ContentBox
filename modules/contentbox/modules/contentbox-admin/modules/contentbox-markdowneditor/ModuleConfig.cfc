/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ContentBox Admin Markdown Editor Module
*/
component {

	// Module Properties
	this.title 				= "ContentBox Markdown Editor";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "https://www.ortussolutions.com";
	this.description 		= "ContentBox Markdown Module";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	this.entryPoint			= "cbadmin/markdown";
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
			customInterceptionPoints = [ ]
		};

		// interceptors
		interceptors = [ ];
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		var editorService = wirebox.getInstance( "EditorService@cb" );
		editorService.registerEditor( wirebox.getInstance( "MarkdownEditor@contentbox-markdowneditor" ) );
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		var editorService = wirebox.getInstance( "EditorService@cb" );
		editorService.unregisterEditor( 'simplemde' );
	}

}