/**
* BlogBox Goodness Layout
*/
component{
	// Layout Variables
	this.name 			= "BlogBox Goodness";
	this.description 	= "BlogBox Default Layout";
	this.version		= "1.0";
	this.author 		= "Luis Majano";
	this.authorURL		= "http://www.ortussolutions.com";
	// Screenshot URL, can be absolute or locally in your layout package.
	this.screenShotURL	= "includes/images/screenshot.png";
	// ForgeBox slug if you want auto-update featuress
	this.forgeBoxSlug	= "blogbox-goodness";
	// The custom interception points this layout announces, an array of event strings
	this.customInterceptionPoints = ["bbui_beforeBottomBar","bbui_afterBottomBar"];
}