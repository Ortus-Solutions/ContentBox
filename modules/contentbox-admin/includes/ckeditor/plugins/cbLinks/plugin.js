/*
Copyright (c) 2012 Ortus Solutions, Corp. All rights reserved.
openRemoteModal() is part of contentbox js
*/
(function(){
	//Section 1 : Code to execute when the toolbar button is pressed
	var a= {
		exec:function(editor){
			// Open the selector widget dialog.
			openRemoteModal( getPageSelectorURL(), {editorName: editor.name} );
		}
	},
	//Section 2 : Create the button and add the functionality to it
	b='cbLinks';
	CKEDITOR.plugins.add(b,{
		init:function(editor){
			editor.addCommand(b,a);
			editor.ui.addButton('cbLinks',{
				label:'Link to a ContentBox Page',
				icon: this.path + 'page.png',
				command:b
			});
			// context menu
			if (editor.addMenuItem) {
				// A group menu is required
				editor.addMenuGroup('contentbox');
				// Create a menu item
				editor.addMenuItem('cbLinks', {
					label: 'Link To Page',
					command: b,
					icon: this.path + 'page.png',
					group: 'contentbox',
					order:5
				});
			}
			if (editor.contextMenu) {
				editor.contextMenu.addListener(function(element, selection) {
					return { cbLinks: CKEDITOR.TRISTATE_ON };
				});
			}
		}
	});
})();
