<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	// tables references
	$authors = $("##authors");
	// sorting
	$authors.tablesorter();
	// activate confirmations
	activateConfirmations();
	// activate tooltips
	activateTooltips();
});
</script>
</cfoutput>