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
	ContentStoreRemove={
		exec: function( editor ) {
			editor.widgetSelection.remove( false );
        }
	}
	//Section 2 : Create the button and add the functionality to it
	b='cbContentStore';
	CKEDITOR.plugins.add(b,{
		init:function(editor){
			editor.addCommand(b,a);
			editor.addCommand( 'ContentStoreRemove', ContentStoreRemove )
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

				// Remove Content Store Items 
				editor.addMenuItem('ContentStoreRemove', {
					// Item label.
    				label : 'Remove Contentstore Item',
    				// Item icon path using the variable defined above.
    				icon: this.path + 'cross.png',
    				// Reference to the plugin command name.
    				command : 'ContentStoreRemove',
    				// Context menu group that this entry belongs to.
    				group : 'clipboard'
				});
			}
			if (editor.contextMenu) {
				editor.contextMenu.addListener(function(element, selection) {
					return { cbContentStore: CKEDITOR.TRISTATE_ON };
				} );

				editor.contextMenu.addListener( function( element ) {
					if( element.getAscendant( 'contentstore', true ) ) {
						editor.widgetSelection = element.getAscendant( 'contentstore', true );
						return {
								ContentStoreRemove: CKEDITOR.TRISTATE_OFF
						};
					}
				});


			}
		}
	} );
} )();
