/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ContentBox Dependencies Module.  This controls the loading/unloading of all the
* dependencies required in ContentBox, via the `this.dependencies` property.
*/
component {

	// Module Properties
	this.title 				= "contentbox-deps";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "https://www.ortussolutions.com";
	this.description 		= "ContentBox Dependencies Module";
	// No models to map
	this.automapModels		= false;
	// The order of the dependencies to load before ContentBox loads.
	this.dependencies 		= [
		"cborm",
        "cbjavaloader",
        "bcrypt",
        "cbstorages",
        "cbsecurity",
        "cbmailservices",
        "cbfeeds",
        "cbmessagebox",
        "cbantisamy",
        "cbmarkdown",
        "forgeboxsdk"
	];

	/**
	* Configure Module
	*/
	function configure(){
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
	}

}