<cfoutput>
    <script>
        var input = null;
        var hidden = null;
        var label = null;
        var typeIcon = null;
        var win = null;

        if( !!document.getElementsByClassName( "select-media") ) {
            handleMediaOnClick();
        };
        document.addEventListener( "DOMContentLoaded", () => {
            handleMediaOnClick();
        } );
        /**
         * Custom callback for menu item selection
         * @param {String} sPath
         * @param {String} sURL
         * @param {String} sType
         */
        function fbMenuItemSelect( sPath, sURL, sType ) {
            var fileParts = sURL.split( '/' ),
                fileName = fileParts[ fileParts.length-1 ];
            input.value = fileName;
            hidden.value = sURL;
            label.value = fileName;
            updateLabel( label );
            typeIcon.classList.remove( 'btn-danger' )
            typeIcon.classList.add( 'btn-info' );
            win.close();
            $('##menuForm').valid();
            toggleErrors('off');
            return false;
        }
        /**
         * Handles the click on the element, with the class "select-media"
         */
        function handleMediaOnClick(){
            var collection = document.getElementsByClassName( "select-media" );
            for ( var i = 0; i < collection.length; i++) {
                collection[i].onclick = function() {
                    input = getNextSibling( this, 'input[name^=media-]' ); //getNextSibling() in content adminHelper
                    hidden = getNextSibling( this, 'input[name^=mediaPath]' )
                    label = this.closest( '.dd3-extracontent' ).querySelector( 'input[name^=label]' );
                    typeIcon = this.closest( '.dd3-item' ).querySelector( '.dd3-type' );
                    var baseURL = '#args.xehMediaSelector#';
                    win = window.open( baseURL, 'fbSelector', 'height=600,width=600' );
                };
            }
        }
    </script>
</cfoutput>
