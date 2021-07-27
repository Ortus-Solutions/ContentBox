/**
 * Copyright (c) 2012 Ortus Solutions, Corp. All rights reserved.
 * getContentStoreSelectorURL() is exposed by the dynamic editor being generated.
 * openRemoteModal() is part of contentbox js
 */
( function(){
	const pluginName = "cbContentStore";

	CKEDITOR.plugins.add(
		pluginName,
		{
			init : function( editor ){
				// Add the Command
				editor.addCommand( pluginName,{
					// Enable the button for both 'wysiwyg' and 'source' modes
					modes : { wysiwyg: 1, source: 1 },
					// Command Execution
					exec  : function( editor ){
						// Open the selector widget dialog.
						openRemoteModal( getContentStoreSelectorURL(), { editorName: editor.name } );
					}
				} );

				// Add the button
				editor.ui.addButton( pluginName,{
					label   : "Insert from ContentStore",
					icon    : this.path + "contentstore.png",
					command : pluginName
				} );

				// context menu
				if ( editor.addMenuItem ) {
					// A group menu is required
					editor.addMenuGroup( "contentbox" );
					// Create a menu item
					editor.addMenuItem( pluginName, {
						label   : "Insert From ContentStore",
						command : pluginName,
						icon    : this.path + "contentstore.png",
						group   : "contentbox",
						order   : 2
					} );
				}
				if ( editor.contextMenu ) {
					editor.contextMenu.addListener( function( element, selection ) {
						return { cbContentStore: CKEDITOR.TRISTATE_ON };
					} );
				}
			}
		}
	);
} )();
