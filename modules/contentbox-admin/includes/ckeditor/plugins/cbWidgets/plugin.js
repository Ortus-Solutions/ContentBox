/*
Copyright (c) 2012 Ortus Solutions, Corp. All rights reserved.
getWidgetSelectorURL() is exposed by the dynamic editor being generated.
openRemoteModal() is part of contentbox js
*/
(function(){
	//Section 1 : Code to execute when the toolbar button is pressed
	var a= {
		exec:function(editor){
			// Open the selector widget dialog.
			openRemoteModal( getWidgetSelectorURL(), {editorName: editor.name} );
		}
	},
	//Section 2 : Create the button and add the functionality to it
	b='cbWidgets';
	CKEDITOR.plugins.add(b,{
		init:function(editor){
			editor.addCommand(b,a);
			editor.ui.addButton('cbWidgets',{
				label:'Insert a ContentBox Widget',
				icon: this.path + 'ContentBox-Circle_16.png',
				command:b
			});
			// context menu
			if (editor.addMenuItem) {
				// A group menu is required
				editor.addMenuGroup('contentbox');
				// Create a menu item
				editor.addMenuItem('cbWidget', {
					label: 'Insert Widget',
					command: b,
					icon: this.path + 'ContentBox-Circle_16.png',
					group: 'contentbox',
					order:3
				});
			}
			if (editor.contextMenu) {
				editor.contextMenu.addListener(function(element, selection) {
					return { cbWidget: CKEDITOR.TRISTATE_ON };
				});
			}
		}
	});
})();
