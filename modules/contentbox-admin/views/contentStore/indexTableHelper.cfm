<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	// tables references
	$content = $("##content");
	// sorting
	$content.dataTable({
		"paging": false,
		"info": false
	});
	// activate confirmations
	activateConfirmations();
	// activate tooltips
	activateTooltips();
	// Popovers
	activateInfoPanels();
});
</script>
</cfoutput>