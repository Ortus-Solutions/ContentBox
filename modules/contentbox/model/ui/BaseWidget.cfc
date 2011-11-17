/**
* This is the base class for contentbox widgets
*/
component extends="coldbox.system.Plugin" accessors="true"{
	
	// Shared DI all widgets receive
	property name="categoryService"		inject="id:categoryService@cb";
	property name="entryService"		inject="id:entryService@cb";
	property name="pageService"			inject="id:pageService@cb";
	property name="authorService"		inject="id:authorService@cb";
	property name="commentService"		inject="id:commentService@cb";
	property name="customHTMLService"	inject="id:customHTMLService@cb";
	property name="cb"					inject="id:CBHelper@cb";
	property name="securityService" 	inject="id:securityService@cb";
	property name="html"				inject="coldbox:plugin:HTMLHelper";
	
	// Local Properties
	property name="forgeBoxSlug" type="string" default="";

	/**
	* This is the main renderit method you will need to implement in concrete widgets
	*/
	any function renderIt(){
		throw(message="This is a base method that you must implement",type="ContentBox.BaseWidget.BaseClassException");
	}
	
	
	
}