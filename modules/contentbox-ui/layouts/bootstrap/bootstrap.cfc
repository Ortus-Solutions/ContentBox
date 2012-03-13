/**
You can use this template theme to start your own.

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
	this.name 			= "Bootstrap, from Twitter";
	this.description 	= "Simple and flexible HTML, CSS, and Javascript for popular user interface components and interactions.";
	this.version		= "1.0";
	// Bootstrap theme integrated by:
	this.author 		= "Nolan Dubeau";
	this.authorURL		= "http://www.nolandubeau.com";
	// ForgeBox slug if you want auto-update featuress
	this.forgeBoxSlug	= "cblayouts-bootstrap";
	// Screenshot URL, can be absolute or locally in your layout package.
	//this.screenShotURL	= "screenshot.png";
	// The custom interception points this layout announces, an array of event strings
	//this.customInterceptionPoints = arrayToList( ["cbui_beforeBottomBar","cbui_afterBottomBar"] );
	
	/* 
	Bootstrap, from Twitter - http://twitter.github.com/bootstrap/
	Designed and built with all the love in the world @twitter by @mdo and @fat.
	Code licensed under the Apache License v2.0. Documentation licensed under CC BY 3.0.
	Icons from Glyphicons Free, licensed under CC BY 3.0.
	*/
	
	
}