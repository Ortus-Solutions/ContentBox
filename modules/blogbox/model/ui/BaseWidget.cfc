/**
* This is the base class for BlogBox widgets
*/
component extends="coldbox.system.Plugin" accessors="true"{
	
	// Shared DI all widgets receive
	property name="categoryService"		inject="id:categoryService@bb";
	property name="entryService"		inject="id:entryService@bb";
	property name="pageService"			inject="id:pageService@bb";
	property name="authorService"		inject="id:authorService@bb";
	property name="commentService"		inject="id:commentService@bb";
	property name="customHTMLService"	inject="id:customHTMLService@bb";
	property name="bb"					inject="coldbox:myplugin:BBHelper@blogbox-ui";
	property name="html"				inject="coldbox:plugin:HTMLHelper";
	
	// Local Properties
	property name="forgeBoxSlug" type="string" default="";

	/**
	* This is the main renderit method you will need to implement in concrete widgets
	*/
	any function renderIt(){
		throw(message="This is a base method that you must implement",type="BlogBox.BaseWidget.BaseClassException");
	}
	
	
	
}