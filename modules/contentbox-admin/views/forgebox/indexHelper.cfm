<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	// pointers
	$forgeBoxInstall = $( "##forgeBoxInstall" ); 
	$downloadURL = $forgeBoxInstall.find( "##downloadURL" );
	// Div Filter
	$( "##entryFilter" ).keyup(function(){
		$.uiDivFilter( $( ".forgeBox-entrybox" ), this.value );
	} )
	// tool tips
	activateTooltips();
} );
function openForgeboxModal(id){
	$( "##"+id).overlay( {
		mask: {
			color: '##fff',
			loadSpeed: 200,
			opacity: 0.6 },
		closeOnClick : true,
		closeOnEsc : true,
		oneInstance: false
	} );
	// open the modal
	$( "##"+id).data( "overlay" ).load();
}
function installEntry(id, downloadURL){
	$( "##"+id).html('<div class="text-center"><i class="fa fa-spinner fa-spin fa-lg"></i><br/>Please wait, installing from ForgeBox...</div>');
	$downloadURL.val( downloadURL );
	$forgeBoxInstall.submit();
	return true;
}
</script>
</cfoutput>