/**
 * Copyright (c) 2012 Ortus Solutions, Corp. All rights reserved.
 * getPageSelectorURL() is exposed by the dynamic editor being generated.
 * openRemoteModal() is part of contentbox js
 */
( function(){
	const pluginName = "cbLinks";

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
						openRemoteModal( getPageSelectorURL(), { editorName: editor.name } );
					}
				} );

				// Add Button
				editor.ui.addButton( pluginName,{
					label   : "Link to a ContentBox Page",
					icon    : this.path + "page.png",
					command : pluginName
				} );

				// context menu
				if ( editor.addMenuItem ) {
				// A group menu is required
					editor.addMenuGroup( "contentbox" );
					// Create a menu item
					editor.addMenuItem( pluginName, {
						label   : "Link To Page",
						command : pluginName,
						icon    : this.path + "page.png",
						group   : "contentbox",
						order   : 5
					} );
				}
				if ( editor.contextMenu ) {
					editor.contextMenu.addListener( function( element, selection ) {
						return { cbLinks: CKEDITOR.TRISTATE_ON };
					} );
				}
			}
		} );
} )();
