<cfoutput>
<script>
$(document).ready(function() {
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
    // activate confirmations
    activateConfirmations();
    // activate tooltips
    activateTooltips();
} );
</script>
</cfoutput>