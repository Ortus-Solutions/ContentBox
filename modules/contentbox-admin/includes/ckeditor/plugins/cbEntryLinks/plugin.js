/*
Copyright (c) 2012 Ortus Solutions, Corp. All rights reserved.
openRemoteModal() is part of contentbox js
*/
(function(){
	//Section 1 : Code to execute when the toolbar button is pressed
	var a= {
		exec:function(editor){
			// Open the selector widget dialog.
			openRemoteModal( getEntrySelectorURL(), {editorName: editor.name} );
		}
	},
	//Section 2 : Create the button and add the functionality to it
	b='cbEntryLinks';
	CKEDITOR.plugins.add(b,{
		init:function(editor){
			editor.addCommand(b,a);
			editor.ui.addButton('cbEntryLinks',{
				label:'Link to a ContentBox Entry',
				icon: this.path + 'pen.png',
				command:b
			});
		}
	});
})();
