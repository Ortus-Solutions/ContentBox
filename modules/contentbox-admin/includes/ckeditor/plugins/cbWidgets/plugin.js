/*
Copyright (c) 2012 Ortus Solutions, Corp. All rights reserved.
getEditorSelectorURL() is exposed by the dynamic editor being generated.
openRemoteModal() is part of contentbox js
*/
(function(){
	//Section 1 : Code to execute when the toolbar button is pressed
	var a= {
		exec:function(editor){
			// Open the selector widget dialog.
			openRemoteModal( getEditorSelectorURL(), {editorName: editor.name} );
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
		}
	});
})();
