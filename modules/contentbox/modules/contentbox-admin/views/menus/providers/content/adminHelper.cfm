<cfoutput>
    <script>
        var input = null;
        var hidden = null;
        var label = null;
        var typeIcon = null;
        document.addEventListener( "DOMContentLoaded", () => {
            $( '.select-content' ).on( 'click', function() {
                input = $( this ).siblings( 'input[name^=contentTitle]' );
                hidden= $( this ).siblings( 'input[name^=contentSlug]' );
                label = $( this ).closest( '.dd3-extracontent' ).find( 'input[name^=label]' );
                typeIcon = $( this ).closest( '.dd3-item' ).find( '.dd3-type' );
                var baseURL = '#event.buildLink( args.xehContentSelector )#';
                openRemoteModal( baseURL, {contentType:'Page,Entry'}, 900, 600 );
            } );
        } );
        function chooseRelatedContent( id, title, type, slug ) {
            closeRemoteModal();
            input.val( title );
            hidden.val( slug );
            label.val( title );
            updateLabel( label );
            typeIcon.removeClass( 'btn-danger' ).addClass( 'btn-primary' );
            $('##menuForm').valid();
            toggleErrors('off');
            return false;
        }
    </script>
</cfoutput>
