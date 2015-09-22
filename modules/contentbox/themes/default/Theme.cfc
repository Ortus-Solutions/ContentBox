/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.gocontentbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
A layout is composed of the following pieces

/LayoutName
 + {layoutName}.cfc (The CFC that models your layout implementation)
 / layouts (The folder that contains layouts in your theme)
   + blog.cfm (Mandatory layout used for all blog views by convention)
   + pages.cfm (Mandatory layout used for all pages by convention)
   + maintenance.cfm (Optional used when in maintenance mode)
   + search.cfm (Optional used when doing searches, else defaults to pages)
 / views (The folder that contains views for rendering)
   	+ archives.cfm (MANDATORY: The view used to render out blog archives.)
   	+ entry.cfm (MANDATORY: The view used to render out a single blog entry with comments, etc.)
   	+ error.cfm (MANDATORY: The view used to display errors when they ocurr in your blog or pages)
   	+ index.cfm (MANDATORY: The view used to render out the home page where all blog entries are rendered)
   	+ notfound.cfm (The view used to display messages to users when a blog entry requested was not found in our system.)
   	+ page.cfm (MANDATORY: The view used to render out individual pages.)
   	+ maintenance.cfm (OPTIONAL: Used when in maintenance mode)
/ templates (The folder that contains optional templates for collection rendering that are used using the quick rendering methods in the CB Helper)
	+ category.cfm (The template used to display an iteration of entry categories using coldbox collection rendering)
	+ comment.cfm (The template used to display an iteration of entry or page comments using coldbox collection rendering)
	+ entry.cfm (The template used to display an iteration of entries in the home page using coldbox collection rendering)
/ widgets (A folder that can contain layout specific widgets which override core ContentBox widgets)

Templates
Templates are a single cfm template that is used by ContentBox to iterate over a collection (usually entries or categories or comments) and
render out all of them in uniformity.  Please refer to ColdBox Collection Rendering for more information.  Each template recevies
the following:

* _counter (A variable created for you that tells you in which record we are currently looping on)
* _items (A variable created for you that tells you how many records exist in the collection)
* {templateName} The name of the object you will use to display: entry, comment, category

Layout Local CallBack Functions:
onActivation()
onDelete()
onDeactivation()

Settings
You can declare settings for your layouts that ContentBox will manage for you.

this.settings = [
	{name="Title", defaultValue="My Awesome Title", required="true", type="text", label="Title:"},
	{name="Colors", defaultValue="blue", required="false", type="select", label="Color:", options="red,blue,orange,gray"}
];

The value is an array of structures with the following keys:

- name : The name of the setting (required), the setting is saved as cb_layoutname_settingName
- defaultValue : The default value of the setting (required)
- required : Whether the setting is required or not. Defaults to false
- type : The type of the HTMl control (text=default, textarea, boolean, select)
- label : The HTML label of the control (defaults to name)
- title : The HTML title of the control (defaults to empty string)
- options : The select box options. Can be a list or array of values or an array of name-value pair structures

*/
component{
	// Layout Variables
    this.name       = "ContentBox3 Default Theme";
	this.description 	= "ContentBox Default layout for ContentBox 3 based on Bootstrap 3 and Bootswatch";
	this.version		= "1.0";
	this.author 		= "Ortus Solutions";
	this.authorURL		= "http://www.ortussolutions";
	// Screenshot URL, can be absolute or locally in your layout package.
	this.screenShotURL	= "screenshot.png";
	// ForgeBox slug if you want auto-update features
	this.forgeBoxSlug	= "cbtheme-cb3default";
	// Layout Settings
	this.settings = [
		{ name="cbBootswatchTheme", defaultValue="default", required="false", type="select", label="Content Box Bootswatch Theme:", options="Default,Green" },
		{ name="minifyCacheAssets", defaultValue="true", type="boolean", label="Minify/Cache Assets:" },
		{ name="useLESS", defaultValue="true", type="boolean", label="Use LESS (Requires 'Minify/Cache Assets'):" },
		{ name="footerBox", defaultValue="", type="textarea", label="Footer Text:" },
		{ name="hpHeaderTitle", defaultValue="", type="text", label="Homepage Header Title:" },
		{ name="hpHeaderText", defaultValue="", type="text", label="Homepage Header Text:" },
		{ name="hpHeaderLink", defaultValue="", type="text", label="Homepage Header Button Link:" },
		{ name="hpHeaderBg", defaultValue="green", required="false", type="select", label="Homepage Header Background:", options="Green,World" }
		
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
