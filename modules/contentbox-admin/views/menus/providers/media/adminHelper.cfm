<cfoutput>
    <script>
        var input = null;
        var hidden = null;
        var label = null;
        var typeIcon = null;
        var win = null;
        $( document ).ready(function() {
            $( '.select-media' ).on( 'click', function() {
                input = $( this ).siblings( 'input[name^=media]' );
                hidden= $( this ).siblings( 'input[name^=mediaPath]' );
                label = $( this ).closest( '.dd3-extracontent' ).find( 'input[name^=label]' );
                typeIcon = $( this ).closest( '.dd3-item' ).find( '.dd3-type' );
                var baseURL = '#args.xehMediaSelector#';
                win = window.open( baseURL, 'fbSelector', 'height=600,width=600' )
            });
        });
        /**
         * Custom callback for menu item selection
         * @param {String} sPath
         * @param {String} sURL
         * @param {String} sType
         */
        function fbMenuItemSelect( sPath, sURL, sType ) {
            var fileParts = sURL.split( '/' ),
                fileName = fileParts[ fileParts.length-1 ];
            input.val( fileName );
            hidden.val( sURL );
            label.val( fileName );
            updateLabel( label );
            typeIcon.removeClass( 'btn-danger' ).addClass( 'btn-info' );
            win.close();
            return false;
        }
    </script>
</cfoutput>