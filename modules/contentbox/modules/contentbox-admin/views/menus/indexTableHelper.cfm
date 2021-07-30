<cfoutput>
<script>
( () => {
    // tables references
    $menu = $( "##menu" );
    // sorting
    $menu.dataTable( {
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
	$( "##menusCountContainer" ).html( "(" + $( "##menusCount" ).val() + ")" );
    // activate confirmations
    activateConfirmations();
    // activate tooltips
    activateTooltips();
} )();
</script>
</cfoutput>