<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	// table sorting
	//$("##templates").tablesorter();
    $("##templates").dataTable({
        "paging": false,
        "info": false,
        "searching": false
    });
});
</script>
</cfoutput>