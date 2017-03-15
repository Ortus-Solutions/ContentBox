<cfoutput>
<script>
$(document).ready(function() {
	// pointers
	$forgeBoxInstall = $( "##forgeBoxInstall" ); 
	$downloadURL = $forgeBoxInstall.find( "##downloadURL" );
	// Div Filter
	$( "##entryFilter" ).keyup(
		_.debounce(
            function(){
              	$.uiDivFilter( $( ".forgeBox-entrybox" ), this.value );
            },
            300
        )
	)
	// tool tips
	activateTooltips();
} );
function installEntry( id, downloadURL ){
	$( "##"+id ).html( '<div class="text-center"><i class="fa fa-circle-o-notch fa-spin fa-lg"></i><br/>Please wait, installing from ForgeBox...</div>' );
	$downloadURL.val( downloadURL );
	$forgeBoxInstall.submit();
	return true;
}
</script>
</cfoutput>