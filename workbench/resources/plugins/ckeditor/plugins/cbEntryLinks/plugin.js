/**
 * Copyright (c) 2012 Ortus Solutions, Corp. All rights reserved.
 * getEntrySelectorURL() is exposed by the dynamic editor being generated.
 * openRemoteModal() is part of contentbox js
 */
( function(){
	const pluginName = "cbEntryLinks";

	CKEDITOR.plugins.add(
		pluginName,
		{
			init : function( editor ){
				// Add the Command
				editor.addCommand( pluginName,{
					// Enable the button for both 'wysiwyg' and 'source' modes
					modes : { wysiwyg: true, source: false },
					// Command Execution
					exec  : function( editor ){
					// Open the selector widget dialog.
						openRemoteModal( getEntrySelectorURL(), { editorName: editor.name } );
					}
				} );

				// Add the button
				editor.ui.addButton( pluginName,{
					label   : "Link to a ContentBox Entry",
					icon    : this.path + "pen.png",
					command : pluginName
				} );

				// context menu
				if ( editor.addMenuItem ) {
				// A group menu is required
					editor.addMenuGroup( "contentbox" );
					// Create a menu item
					editor.addMenuItem( pluginName, {
						label   : "Link To Blog Entry",
						command : pluginName,
						icon    : this.path + "pen.png",
						group   : "contentbox",
						order   : 4
					} );
				}
				if ( editor.contextMenu ) {
					editor.contextMenu.addListener( function( element, selection ) {
						return { cbEntryLinks: CKEDITOR.TRISTATE_ON };
					} );
				}
			}
		}
	);
} )();
