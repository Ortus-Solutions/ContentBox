<cfoutput>
<!--- Custom Javascript --->
<script>
( () => {
	// Take height for iframe
    var height = $( "##modal" ).data( 'height' );
    $( "##previewFrame" ).attr( "height", height );
	$( "##previewForm" ).submit();
} )();
</script>
</cfoutput>