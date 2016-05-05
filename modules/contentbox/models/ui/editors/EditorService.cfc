/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Manages editor services
*/
component accessors="true" threadSafe singleton{

	// The structure that keeps the editors
	property name="editors"		type="struct";
	// The structure that keeps the markup languages
	property name="markups"		type="struct";
	// Setting Servie
	property name="settingService" inject="settingService@cb";
	
	/**
	* Constructor
	* @wirebox.inject wirebox
	*/
	EditorService function init( required wirebox ){
		// init editors and markups
		editors = {};
		markups = [];
		
		// store factory
		variables.wirebox = arguments.wirebox;
		
		// register core editors
		registerEditor( arguments.wirebox.getInstance( "TextareaEditor@cb" ) );
		
		// register default markup
		registerMarkup( "HTML" )
			.registerMarkup( "Markdown" );

		return this;
	}
	
	/**
	* Get the default system editor
	*/
	string function getDefaultEditor(){
		return settingService.getSetting( "cb_editors_default" );
	}
	
	/**
	* Get the default system markup
	*/
	string function getDefaultMarkup(){
		return settingService.getSetting( "cb_editors_markup" );
	}

	/**
	* Register a new editor in ContentBox
	* @editor.hint The editor instance to register
	*/
	EditorService function registerEditor( required contentbox.models.ui.editors.IEditor editor ){
		editors[ arguments.editor.getName() ] = arguments.editor;	
		return this;
	}
	
	/**
	* Register a new markup in ContentBox
	* @markup.hint The markup name to register
	*/
	EditorService function registerMarkup( required markup ){
		arrayAppend( markups, arguments.markup );	
		return this;
	}
	
	/**
	* UnRegister an editor in ContentBox
	* @name.hint The name of the editor to unregister
	*/
	EditorService function unRegisterEditor( required name ){
		structDelete( editors, arguments.name );	
		return this;
	}
	
	/**
	* UnRegister a markup in ContentBox
	* @markup.hint The markup name to unregister
	*/
	EditorService function unRegisterMarkup( required markup ){
		arrayDeleteAt( markups, arrayFindNoCase( markups, arguments.markup ) );
		return this;
	}
	
	/**
	* Get an array of registered editor names in alphabetical order
	*/
	array function getRegisteredEditors(){
		return listToArray( listSort( structKeyList( editors ), "textnocase" ) );
	}
	
	/**
	* Get an array of registered markup names in alphabetical order
	*/
	array function getRegisteredMarkups(){
		arraySort( markups, "textnocase" );
		return markups;
	}
	
	/**
	* Get an array of registered editor names in alphabetical order with their display names
	*/
	array function getRegisteredEditorsMap(){
		var aEditors = getRegisteredEditors();
		var result = [];
		for( var thisEditor in aEditors ){
			arrayAppend( result, { name=thisEditor, displayName=editors[ thisEditor ].getDisplayName() } );
		}
		return result;
	}
	
	/**
	* Get a registered editor instance
	* @name.hint The name of the editor
	*/
	contentbox.models.ui.editors.IEditor function getEditor( required name ){
		return editors[ arguments.name ];
	}

	/**
	* Check if an editor exists or not
	* @name.hint The name of the editor
	*/
	boolean function hasEditor( required name ){
		return structKeyExists( editors, arguments.name );
	}

	/**
	* Check if an markup exists or not
	* @markup.hint The name of the markup
	*/
	boolean function hasMarkup( required markup ){
		return structKeyExists( markups, arguments.name );
	}

}