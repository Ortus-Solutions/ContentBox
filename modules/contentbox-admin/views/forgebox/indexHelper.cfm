<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	// pointers
	$forgeBoxInstall = $("##forgeBoxInstall"); 
	$downloadURL = $forgeBoxInstall.find("##downloadURL");
	// Div Filter
	$("##entryFilter").keyup(function(){
		$.uiDivFilter( $(".forgeBox-entrybox"), this.value );
	})
	// tool tips
	activateTooltips();
});
function openForgeboxModal(id){
	$("##"+id).overlay({
		mask: {
			color: '##fff',
			loadSpeed: 200,
			opacity: 0.6 },
		closeOnClick : true,
		closeOnEsc : true,
		oneInstance: false
	});
	// open the modal
	$("##"+id).data("overlay").load();
}
function installEntry(id, downloadURL){
	$("##"+id).html('<div class="center"><img src="#prc.cbRoot#/includes/images/ajax-loader-blue.gif" alt="loader"/><br/>Please wait, installing from ForgeBox...</div>');
	$downloadURL.val( downloadURL );
	$forgeBoxInstall.submit();
}
</script>
</cfoutput>