<cfoutput>
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
	// Take height for iframe
    var height = $( "##modal" ).data( 'height' );
    $( "##previewFrame" ).attr( "height", height );
	$( "##previewForm" ).submit();
} );
</script>
</cfoutput>