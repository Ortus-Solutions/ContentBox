// plugin for adding generic key events to CKEDITOR
CKEDITOR.plugins.add( 'cbKeyBinding', {
	// setup plugin
	init : function( editor ) {
		//editor.addCommand( pluginCmd, new CKEDITOR.dialogCommand( pluginCmd, {} ) );
		// add command for quickSave
		editor.addCommand( 'quickSave', {
			exec: function( editor ) {
				quickSave();
			}
		});

		// bind keystrokes...can be for ad-hoc commands added above, or event named commands in other plugins
		// add key stroke -- ctrl+s
		editor.setKeystroke( CKEDITOR.CTRL+83, 'quickSave' );
		// add key stroke -- ctrl+shift+p
		editor.setKeystroke( CKEDITOR.CTRL+CKEDITOR.SHIFT+80, 'cbLinks' );
		// add key stroke -- ctrl+shift+b
		editor.setKeystroke( CKEDITOR.CTRL+CKEDITOR.SHIFT+66, 'cbEntryLinks' );
		// add key stroke -- ctrl+shift+h
		editor.setKeystroke( CKEDITOR.CTRL+CKEDITOR.SHIFT+72, 'cbCustomHTML' );
		// add key stroke -- ctrl+shift+w
		editor.setKeystroke( CKEDITOR.CTRL+CKEDITOR.SHIFT+87, 'cbWidgets' );
	}	
});