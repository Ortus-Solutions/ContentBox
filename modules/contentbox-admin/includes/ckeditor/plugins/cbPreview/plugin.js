/*
Copyright (c) 2012 Ortus Solutions, Corp. All rights reserved.
openRemoteModal() is part of contentbox js
*/
(function(){
	//Section 1 : Code to execute when the toolbar button is pressed
	var a= {
		exec:function(editor){
			// Open the preview
			openRemoteModal( getPreviewSelectorURL(), 
							 { content: editor.getData(), 
							   layout: $("#layout").val(),
							   title: $("#title").val(),
							   slug: $("#slug").val() },
							 "95%",
							 "90%");
		}
	},
	//Section 2 : Create the button and add the functionality to it
	b='cbPreview';
	CKEDITOR.plugins.add(b,{
		init:function(editor){
			editor.addCommand(b,a);
			editor.ui.addButton('cbPreview',{
				label:'Quick Preview',
				icon: this.path + 'eye.png',
				command:b
			});
			// context menu
			if (editor.addMenuItem) {
				// A group menu is required
				editor.addMenuGroup('contentbox');
				// Create a menu item
				editor.addMenuItem('cbQuickPreview', {
					label: 'Quick Preview',
					command: b,
					icon: this.path + 'eye.png',
					group: 'contentbox',
					order: 6
				});
			}
			if (editor.contextMenu) {
				editor.contextMenu.addListener(function(element, selection) {
					return { cbQuickPreview: CKEDITOR.TRISTATE_ON };
				});
			}
		}
		
	});
})();
