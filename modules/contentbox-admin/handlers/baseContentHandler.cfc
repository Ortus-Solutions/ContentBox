/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* The base content handler
*/
component extends="baseHandler"{

	// Dependencies
	property name="authorService"		inject="id:authorService@cb";
	property name="themeService"		inject="id:themeService@cb";
	property name="CBHelper"			inject="id:CBHelper@cb";
	property name="categoryService"		inject="id:categoryService@cb";
	property name="editorService"		inject="id:editorService@cb";

	// pre handler
	function preHandler( event, action, eventArguments, rc, prc ){
	}

	/**
	* Get the user's default editor with some logic
	* @author.hint The author object
	*/
	private function getUserDefaultEditor( required author ){
		// get user default editor
		var userEditor = arguments.author.getPreference( "editor", editorService.getDefaultEditor() );

		// verify if editor exists
		if( editorService.hasEditor( userEditor ) ){
			return userEditor;
		}

		// not found, reset prefernce to system default, something is wrong.
		arguments.author.setPreference( "editor", editorService.getDefaultEditor() );
		authorService.save( arguments.author );

		// return default editor
		return editorService.getDefaultEditor();
	}

}