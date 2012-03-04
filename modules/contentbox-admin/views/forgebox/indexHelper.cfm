<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
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
</script>
</cfoutput>