<cfoutput>
<script>
$(document).ready(function() {
	// tables references
	$authors = $( "##authors" );
	// datatable
    $authors.dataTable( {
        "paging": false,
        "info": false,
        "searching": false,
        "columnDefs": [
            { 
                "orderable": false, 
                "targets": '{sorter:false}' 
            }
        ],
        "order": []
    } );
	// activate confirmations
	activateConfirmations();
	// activate tooltips
	activateTooltips();
} );
</script>
</cfoutput>