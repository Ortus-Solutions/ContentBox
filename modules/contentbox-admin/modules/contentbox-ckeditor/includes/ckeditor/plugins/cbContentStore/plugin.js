/*
Copyright (c) 2012 Ortus Solutions, Corp. All rights reserved.
getContentStoreSelectorURL() is exposed by the dynamic editor being generated.
openRemoteModal() is part of contentbox js
*/
(function(){
	//Section 1 : Code to execute when the toolbar button is pressed
	var a= {
		exec:function(editor){
			// Open the selector widget dialog.
			openRemoteModal( getContentStoreSelectorURL(), {editorName: editor.name} );
		}
	},
	//Section 2 : Create the button and add the functionality to it
	b='cbContentStore';
	CKEDITOR.plugins.add(b,{
		init:function(editor){
			editor.addCommand(b,a);
			editor.ui.addButton('cbContentStore',{
				label:'Insert from ContentStore',
				icon: this.path + 'contentstore.png',
				command:b
			} );
			// context menu
			if (editor.addMenuItem) {
				// A group menu is required
				editor.addMenuGroup('contentbox');
				// Create a menu item
				editor.addMenuItem('cbContentStore', {
					label: 'Insert From ContentStore',
					command: b,
					icon: this.path + 'contentstore.png',
					group: 'contentbox',
					order:2
				} );
			}
			if (editor.contextMenu) {
				editor.contextMenu.addListener(function(element, selection) {
					return { cbContentStore: CKEDITOR.TRISTATE_ON };
				} );
			}
		}
	} );
} )();
