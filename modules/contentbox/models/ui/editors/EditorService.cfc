/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Manages editor contributions within ContentBox
 */
component accessors="true" threadSafe singleton {

	// DI
	property name="settingService" inject="settingService@contentbox";

	/**
	 * Registered ContentBox Editors
	 */
	property name="editors" type="struct";

	/**
	 * Registered ContentBox Markups
	 */
	property name="markups" type="array";

	/**
	 * Constructor
	 *
	 * @wirebox.inject wirebox
	 */
	EditorService function init( required wirebox ){
		// init editors and markups
		variables.editors = {};
		variables.markups = [];

		// store factory
		variables.wirebox = arguments.wirebox;

		// register default markups ContentBox supports natively
		registerMarkup( "HTML" ).registerMarkup( "Markdown" ).registerMarkup( "JSON" );

		return this;
	}

	/**
	 * Get the default system editor
	 */
	string function getDefaultEditor(){
		return variables.settingService.getSetting( "cb_editors_default" );
	}

	/**
	 * Get the default system markup
	 */
	string function getDefaultMarkup(){
		return variables.settingService.getSetting( "cb_editors_markup" );
	}

	/**
	 * Register a new editor in ContentBox
	 *
	 * @editor The editor instance to register
	 */
	EditorService function registerEditor( required contentbox.models.ui.editors.IEditor editor ){
		variables.editors[ arguments.editor.getName() ] = arguments.editor;
		return this;
	}

	/**
	 * Register a new markup in ContentBox
	 *
	 * @markup The markup name to register
	 */
	EditorService function registerMarkup( required markup ){
		arrayAppend( variables.markups, arguments.markup );
		return this;
	}

	/**
	 * UnRegister an editor in ContentBox
	 *
	 * @name The name of the editor to unregister
	 */
	EditorService function unRegisterEditor( required name ){
		structDelete( variables.editors, arguments.name );
		return this;
	}

	/**
	 * UnRegister a markup in ContentBox
	 *
	 * @markup The markup name to unregister
	 */
	EditorService function unRegisterMarkup( required markup ){
		arrayDeleteAt( variables.markups, arrayFindNoCase( variables.markups, arguments.markup ) );
		return this;
	}

	/**
	 * Get an array of registered editor names in alphabetical order
	 */
	array function getRegisteredEditors(){
		var sortedArray = variables.editors.keyArray();
		sortedArray.sort( "textnocase" );
		return sortedArray;
	}

	/**
	 * Get an array of registered markup names in alphabetical order
	 */
	array function getRegisteredMarkups(){
		arraySort( variables.markups, "textnocase" );
		return variables.markups;
	}

	/**
	 * Get an array of registered editor names in alphabetical order with their display names
	 */
	array function getRegisteredEditorsMap(){
		var aEditors = getRegisteredEditors();
		var result   = [];
		for ( var thisEditor in aEditors ) {
			arrayAppend(
				result,
				{
					name        : thisEditor,
					displayName : variables.editors[ thisEditor ].getDisplayName()
				}
			);
		}
		return result;
	}

	/**
	 * Get a registered editor instance
	 *
	 * @name The name of the editor
	 */
	contentbox.models.ui.editors.IEditor function getEditor( required name ){
		return variables.editors[ arguments.name ];
	}

	/**
	 * Check if an editor exists or not
	 *
	 * @name The name of the editor
	 */
	boolean function hasEditor( required name ){
		return structKeyExists( variables.editors, arguments.name );
	}

	/**
	 * Check if an markup exists or not
	 *
	 * @markup The name of the markup
	 */
	boolean function hasMarkup( required markup ){
		return structKeyExists( variables.markups, arguments.name );
	}

}
