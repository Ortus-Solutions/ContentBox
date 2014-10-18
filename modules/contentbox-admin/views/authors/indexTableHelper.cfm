<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	// tables references
	$authors = $("##authors");
	// datatable
    $authors.dataTable({
        "paging": false,
        "info": false,
        "searching": false
    });
	// activate confirmations
	activateConfirmations();
	// activate tooltips
	activateTooltips();
});
</script>
</cfoutput>