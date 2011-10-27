/**
ContentBox Reddy Layout

A layout is composed of the following pieces

/LayoutName
 + layout.cfm (The main coldbox layout for your skin)
 + {layoutName}.cfc (The CFC that models your layout implementation)
 / views (The folder that contains views for rendering)
   	+ index.cfm (The view used to render out the home page where all blog entries are rendered)
   	+ entry.cfm (The view used to render out a single blog entry with comments, etc.)
   	+ error.cfm (The view used to display errors when they ocurr in your blog)
   	+ notfound.cfm (The view used to display messages to users when a blog entry requested was not found in our system.)
/ templates (The folder that contains templates for collection rendering)
	+ entry.cfm (The template used to display an iteration of entries in the home page using coldbox collection rendering)
	+ category.cfm (The template used to display an iteration of entry categories using coldbox collection rendering)

Templates
Templates are a single cfm template that is used by ContentBox to iterate over a collection (usually entries or categories) and 
render out all of them in uniformity.  Please refer to ColdBox Collection Rendering for more information.  Each template recevies
the following:

* _counter (A variable created for you that tells you in which record we are currently looping on)
* _items (A variable created for you that tells you how many records exist in the collection)

The iterating object will be either: entry if using _entry.cfm and category if using _category.cfm



*/
component{
	// Layout Variables
	this.name 			= "ContentBox Reddy";
	this.description 	= "An awesome free layout called Reddy!";
	this.version		= "1.0";
	this.author 		= "Ortus Solutions";
	this.authorURL		= "http://www.ortussolutions.com";
	// Screenshot URL, can be absolute or locally in your layout package.
	this.screenShotURL	= "screenshot.png";
	// ForgeBox slug if you want auto-update featuress
	this.forgeBoxSlug	= "cblayouts-reddy";
}