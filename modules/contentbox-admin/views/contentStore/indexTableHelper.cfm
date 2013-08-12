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
	// quick look
	activateQuickLook( $entries, '#event.buildLink(prc.xehContentQuickLook)#/contentID/' );
	// Popovers
	activateInfoPanels();
});
</script>
</cfoutput>