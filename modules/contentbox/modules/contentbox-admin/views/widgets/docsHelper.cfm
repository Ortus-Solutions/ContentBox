<cfoutput>
<style>
    .rendermethod {padding: 0 10px 10px;border: solid 1px ##eaeaea;background: ##fafafa;margin-top: 10px;border-radius: 4px;box-shadow: 1px 1px 2px ##ddd;}
</style>
<script>
    ( () => {
        var select = $( '##renderMethodSelect' );
        select.change( showRenderMethod );
    } )();

    function showRenderMethod() {
        var value = $( this ).val();
        $( '##widget-detail' ).find( '.rendermethod' ).hide()
        $( '##' + value ).show( 300 );
    }
</script>
</cfoutput>