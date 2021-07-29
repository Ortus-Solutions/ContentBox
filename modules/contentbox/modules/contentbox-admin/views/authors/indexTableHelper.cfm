<cfoutput>
<script>
( () => {
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
	// Setup Count Container
	$( "##authorCountContainer" ).html( "(" + $( "##authorCount" ).val() + ")" );
	// activate confirmations
	activateConfirmations();
	// activate tooltips
	activateTooltips();
} )();
</script>
</cfoutput>