<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	// tables references
	$entries = $("##entries");
	// sorting
	$entries.tablesorter();
	// activate confirmations
	activateConfirmations();
	// activate tooltips
	activateTooltips();
});
</script>
</cfoutput>