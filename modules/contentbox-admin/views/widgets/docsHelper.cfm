<cfoutput>
<script type="text/javascript">
    $( document ).ready(function() {
        var select = $( '##renderMethodSelect' );
        select.change( showRenderMethod );
    });
    
    function showRenderMethod() {
        var value = $( this ).val();
        $( '.widget-preview' ).find( '.rendermethod' ).hide()
        $( '##' + value ).show( 300 );
    }
</script>
</cfoutput>