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
			openRemoteModal( getCustomHTMLSelectorURL(), {editorName: editor.name} );
		}
	},
	//Section 2 : Create the button and add the functionality to it
	b='cbCustomHTML';
	CKEDITOR.plugins.add(b,{
		init:function(editor){
			editor.addCommand(b,a);
			editor.ui.addButton('cbCustomHTML',{
				label:'Insert a ContentBox CustomHTML',
				icon: this.path + 'html.png',
				command:b
			});
		}
	});
})();
