/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* A theme is composed of the following pieces
* 
* /ThemeDirectory
*  + Theme.cfc (The CFC that models your theme implementation)
*  / layouts (The folder that contains layouts in your theme)
*    + blog.cfm (Mandatory layout used for all blog views by convention)
*    + pages.cfm (Mandatory layout used for all pages by convention)
*    + maintenance.cfm (Optional used when in maintenance mode, else defaults to pages)
*    + search.cfm (Optional used when doing searches, else defaults to pages)
*  / views (The folder that contains views for rendering)
*  	 + archives.cfm (MANDATORY: The view used to render out blog archives.)
*  	 + entry.cfm (MANDATORY: The view used to render out a single blog entry with comments, etc.)
*  	 + error.cfm (MANDATORY: The view used to display errors when they ocurr in your blog or pages)
*  	 + index.cfm (MANDATORY: The view used to render out the home page where all blog entries are rendered)
*  	 + notfound.cfm (The view used to display messages to users when a blog entry requested was not found in our system.)
*  	 + page.cfm (MANDATORY: The view used to render out individual pages.)
*  	 + maintenance.cfm (OPTIONAL: Used when in maintenance mode)
* / templates (The folder that contains optional templates for collection rendering that are used using the quick rendering methods in the CB Helper)
* 	 + category.cfm (The template used to display an iteration of entry categories using coldbox collection rendering)
* 	 + comment.cfm (The template used to display an iteration of entry or page comments using coldbox collection rendering)
* 	 + entry.cfm (The template used to display an iteration of entries in the home page using coldbox collection rendering)
* / widgets (A folder that can contain layout specific widgets which override core ContentBox widgets)
* 
* Templates
* Templates are a single cfm template that is used by ContentBox to iterate over a collection (usually entries or categories or comments) and
* render out all of them in uniformity.  Please refer to ColdBox Collection Rendering for more information.  Each template recevies
* the following:
* 
* _counter (A variable created for you that tells you in which record we are currently looping on)
* _items (A variable created for you that tells you how many records exist in the collection)
* {templateName} The name of the object you will use to display: entry, comment, category
*
* Layout Local CallBack Functions:
* onActivation()
* onDelete()
* onDeactivation()
* 
* Settings
* You can declare settings for your layouts that ContentBox will manage for you.
* 
* this.settings = [
* 	{ name="Title", defaultValue="My Awesome Title", required="true", type="text", label="Title:" },
* 	{ name="Colors", defaultValue="blue", required="false", type="select", label="Color:", options="red,blue,orange,gray" }
* ];
* 
* The value is an array of structures with the following keys:
* 
* - name : The name of the setting (required), the setting is saved as cb_layoutname_settingName
* - defaultValue : The default value of the setting (required)
* - required : Whether the setting is required or not. Defaults to false
* - type : The type of the HTMl control (text=default, textarea, boolean, select)
* - label : The HTML label of the control (defaults to name)
* - title : The HTML title of the control (defaults to empty string)
* - options : The select box options. Can be a list or array of values or an array of name-value pair structures
* 
*/
component{
	// Layout Variables
    this.name       	= "ContentBox 3 Default Theme";
	this.description 	= "ContentBox Default layout for ContentBox 3 based on Bootstrap 3 and Bootswatch";
	this.version		= "1.0.0";
	this.author 		= "Ortus Solutions";
	this.authorURL		= "http://www.ortussolutions";
	// Screenshot URL, can be absolute or locally in your layout package.
	this.screenShotURL	= "screenshot.png";
	// Layout Settings
	this.settings = [
		{ name="cbBootswatchTheme", group="Colors", defaultValue="green", 	type="select", 		label="ContentBox Bootswatch Theme:", 	required="false", options="cerulean,cosmo,cyborg,darkly,flatly,green,journal,lumen,paper,readable,sandstone,simplex,slate,spacelab,superhero,united,yeti" },
		{ name="headerLogo", 		group="Header", defaultValue="", 		type="text", 	label="Logo URL:" },
		{ name="footerBox", 		group="Footer", defaultValue="", 		type="textarea", 	label="Footer Text:" },
		{ name="hpHeaderTitle", 	group="Homepage", defaultValue="", 		type="text", 		label="Homepage Header Title:" },
		{ name="hpHeaderText",	group="Homepage", defaultValue="", 		type="textarea", 	label="Homepage Header Text:" },
		{ name="hpHeaderLink", 	group="Homepage", 	defaultValue="", 		type="text", 		label="Homepage Header Button Link:" },
		{ name="hpHeaderBtnText", 	group="Homepage", 	defaultValue="", 		type="text", 		label="Homepage Header Button Text:" },
		{ name="hpHeaderBg", 	group="Homepage", 	defaultValue="green", 	type="select", 		label="Homepage Header Background:", 	required="false", options="Green,World" },
		{ name="hpHeaderImgBg", 	group="Homepage", 	defaultValue="", 	type="text", 		label="Homepage Header Image Background:" },
		{ name="rssDiscovery", 	group="Homepage", 	defaultValue="true", 	type="boolean",		label="Active RSS Discovery Links", 	required="false" },
		{ name="showCategoriesBlogSide", group="Blog Sidebar Options", defaultValue="true", type="boolean",		label="Show Categories in Blog Sidebar", 	required="false" },
		{ name="showRecentEntriesBlogSide", 	group="Blog Sidebar Options", defaultValue="true", type="boolean",	label="Show Recent Enties in Blog Sidebar", 	required="false" },
		{ name="showSiteUpdatesBlogSide", 	group="Blog Sidebar Options", defaultValue="true", type="boolean",	label="Show Site Updates in Blog Sidebar", 	required="false" },
		{ name="showEntryCommentsBlogSide", 	group="Blog Sidebar Options", defaultValue="true", type="boolean",	label="Show Entry Comments in Blog Sidebar", 	required="false" },
		{ name="showArchivesBlogSide", 	group="Blog Sidebar Options", defaultValue="true", type="boolean",	label="Show Archives in Blog Sidebar", 	required="false" },
		{ name="showEntriesSearchBlogSide", 	group="Blog Sidebar Options", defaultValue="true", type="boolean",	label="Show Entries Search in Blog Sidebar", 	required="false" }
		
	];

	/**
	* Call Back when layout is activated
	*/
	function onActivation(){

	}

	/**
	* Call Back when layout is deactivated
	*/
	function onDeactivation(){

	}

	/**
	* Call Back when layout is deleted from the system
	*/
	function onDelete(){

	}
}
