/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * The base content handler which is used by the entries, contentstore and pages handlers to provide uniformity
 */
component extends="baseHandler" {

	// Dependencies
	property name="authorService" inject="authorService@cb";
	property name="themeService" inject="themeService@cb";
	property name="CBHelper" inject="CBHelper@cb";
	property name="categoryService" inject="categoryService@cb";
	property name="editorService" inject="editorService@cb";
	property name="siteService" inject="siteService@cb";

	/**
	 * Pre Handler
	 *
	 * @event
	 * @action
	 * @eventArguments
	 * @rc
	 * @prc
	 */
	function preHandler( event, action, eventArguments, rc, prc ){
		prc.tabContent = true;
	}

	/**
	 * Get the user's default editor with some logic
	 *
	 * @author The author object to get the default editor from
	 *
	 * @return The default editor in string format
	 */
	private function getUserDefaultEditor( required author ){
		// get user default editor
		var userEditor = arguments.author.getPreference(
			"editor",
			editorService.getDefaultEditor()
		);

		// verify if editor exists
		if ( editorService.hasEditor( userEditor ) ) {
			return userEditor;
		}

		// not found, reset prefernce to system default, something is wrong.
		arguments.author.setPreference( "editor", editorService.getDefaultEditor() );
		authorService.save( arguments.author );

		// return default editor
		return editorService.getDefaultEditor();
	}

}
