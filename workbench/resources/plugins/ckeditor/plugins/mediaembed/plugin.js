/*
* Embed Media Dialog based on http://www.fluidbyte.net/embed-youtube-vimeo-etc-into-ckeditor
*
* Plugin name:      mediaembed
* Menu button name: MediaEmbed
*
* Youtube Editor Icon
* http://paulrobertlloyd.com/
*
* @author Fabian Vogelsteller [frozeman.de]
* @version 0.3
*/
( function() {
    CKEDITOR.plugins.add( 'mediaembed',
    {
        init: function( editor )
        {
           var me = this;
           CKEDITOR.dialog.add( 'MediaEmbedDialog', function ( editor )
           {
              return {
                 title : 'Embed Media',
                 minWidth : 550,
                 minHeight : 150,
                 contents :
                       [
                          {
                             id : 'iframe',
                             expand : true,
                             elements :[{
                                id : 'embedArea',
                                type : 'textarea',
                                label : 'Paste Embed Code Here (YouTube, Vimeo, Etc.)',
                                validate : CKEDITOR.dialog.validate.notEmpty( 'The embed field cannot be empty.' ),
                                'autofocus':'autofocus',
                                required : true,
                                commit: function( data ){
                                	data.embedArea = this.getValue();
                                }
                              }]
                          }
                       ],
                  onOk: function() {
                	  var dialog = this,
                	  	data = {},
                	  	div = editor.document.createElement( 'div' );
                	  // bind the data
                	  this.commitContent( data );
                	  // set the iframe content
                	  div.setHtml( data.embedArea );
                	  // insert back into editor
                      editor.insertElement( div );
                  }
              };
           } ); // end dialog function

            editor.addCommand( 'MediaEmbed', new CKEDITOR.dialogCommand( 'MediaEmbedDialog' ) );

            editor.ui.addButton( 'MediaEmbed',
            {
                label: 'Embed Media',
                command: 'MediaEmbed',
                icon: this.path + 'images/icon.png',
                toolbar: 'mediaembed'
            } );
        }
    } ); // end add
} )(); // end function
