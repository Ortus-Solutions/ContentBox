<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	// tables references
	$content = $("##content");
	// sorting
	$content.tablesorter();
	// activate confirmations
	activateConfirmations();
	// activate tooltips
	activateTooltips();
	// Popovers
	activateInfoPanels();
});
</script>
</cfoutput>