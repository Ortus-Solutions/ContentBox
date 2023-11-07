<cfoutput>
    <script>
        var input = null;
        var hidden = null;
        var label = null;
        var typeIcon = null;

        if( !!document.getElementsByClassName( "select-content") ) {
            handleOnClick();
        };
        document.addEventListener( "DOMContentLoaded", () => {
           handleOnClick();
        } );
        /**
         * Gets next element sibling with selector
         * @param {HTMLElement} The DOM element
         * @param {String} The selector to search 
         */
        var getNextSibling = function( elem, selector ) {
            // Get the next sibling element
            var sibling = elem.nextElementSibling;

            // If there's no selector, return the first sibling
            if ( !selector ) return sibling;

            // If the sibling matches our selector, use it
            // If not, jump to the next sibling and continue the loop
            while ( sibling ) {
                if ( sibling.matches( selector ) ) return sibling;
                sibling = sibling.nextElementSibling
            }
        };
        /**
         * Handles the click on the element, with the class "select-content"
         */
        function handleOnClick(){
            var collection = document.getElementsByClassName( "select-content" );
            for ( var i = 0; i < collection.length; i++) {
                collection[i].onclick = function() {
                    input = getNextSibling( this, 'input[name^=contentTitle]' );
                    hidden = getNextSibling( this, 'input[name^=contentSlug]' )
                    label = this.closest( '.dd3-extracontent' ).querySelector( 'input[name^=label]' );
                    typeIcon = this.closest( '.dd3-item' ).querySelector( '.dd3-type' );
                    var baseURL = '#event.buildLink( args.xehContentSelector )#';
                    openRemoteModal( baseURL, {contentType:'Page,Entry'}, 900, 600 );
                };
            }
        }
        
        function chooseRelatedContent( id, title, type, slug ) {
            closeRemoteModal();
            input.value = title;
            hidden.value =  slug;
            label.value = label.value === "" ? title : label.value;
            updateLabel( label );
            typeIcon.classList.remove( 'btn-danger' );
            typeIcon.classList.add( 'btn-primary' );
            $( '##menuForm' ).valid();
            toggleErrors('off');
            return false;
        }
    </script>
</cfoutput>
