/**
 * Copyright (c) 2012 Ortus Solutions, Corp. All rights reserved.
 * openRemoteModal() is part of contentbox js
 */
( function(){
	const msg1 = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut odio. Nam sed est. Nam a risus et est iaculis adipiscing. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Integer ut justo. In tincidunt viverra nisl. Donec dictum malesuada magna. Curabitur id nibh auctor tellus adipiscing pharetra. Fusce vel justo non orci semper feugiat. Cras eu leo at purus ultrices tristique.\n\n";
	const msg2 = "Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.\n\n";
	const pluginName = "cbIpsumLorem";

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
						editor.insertText( msg1 + msg2 );
					}
				} );

				// Add Button
				editor.ui.addButton( pluginName,{
					label   : "Insert Ipsum Lorem",
					icon    : this.path + "text.png",
					command : b
				} );

				// context menu
				if ( editor.addMenuItem ) {
				// A group menu is required
					editor.addMenuGroup( "contentbox" );
					// Create a menu item
					editor.addMenuItem( pluginName, {
						label   : "Insert Ipsum Lorem",
						command : pluginName,
						icon    : this.path + "text.png",
						group   : "contentbox",
						order   : 1
					} );
				}
				if ( editor.contextMenu ) {
					editor.contextMenu.addListener( function( element, selection ) {
						return { cbIpsumLorem: CKEDITOR.TRISTATE_ON };
					} );
				}
			}
		}
	);
} )();
