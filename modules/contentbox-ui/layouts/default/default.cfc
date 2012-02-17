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
 / views (The folder that contains views for rendering)
   	+ archives.cfm (MANDATORY: The view used to render out blog archives.)
   	+ entry.cfm (MANDATORY: The view used to render out a single blog entry with comments, etc.)
   	+ error.cfm (MANDATORY: The view used to display errors when they ocurr in your blog or pages)
   	+ index.cfm (MANDATORY: The view used to render out the home page where all blog entries are rendered)
   	+ notfound.cfm (The view used to display messages to users when a blog entry requested was not found in our system.)
   	+ page.cfm (MANDATORY: The view used to render out individual pages.)
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

*/
component{
	// Layout Variables
	this.name 			= "ContentBox Goodness";
	this.description 	= "ContentBox Default Layout";
	this.version		= "1.0";
	this.author 		= "Ortus Solutions";
	this.authorURL		= "http://www.ortussolutions.com";
	// Screenshot URL, can be absolute or locally in your layout package.
	this.screenShotURL	= "screenshot.png";
	// ForgeBox slug if you want auto-update featuress
	this.forgeBoxSlug	= "cblayouts-goodness";
	// The custom interception points this layout announces, an array of event strings
	this.customInterceptionPoints = arrayToList( ["cbui_beforeBottomBar","cbui_afterBottomBar"] );
}