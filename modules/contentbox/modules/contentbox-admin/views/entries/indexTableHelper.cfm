<cfoutput>
<script>
$( document ).ready(function() {
	// tables references
	$entries = $( "##entries" );
	// sorting
	$entries.dataTable( {
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
	$( "##entriesCountContainer" ).html( "(" + $( "##entriesCount" ).val() + ")" );
	// activate confirmations
	activateConfirmations();
	// activate tooltips
	activateTooltips();
	// quick look
	activateQuickLook( $entries, '#event.buildLink( prc.xehEntryQuickLook )#/contentID/' );
	// Popovers
	activateInfoPanels();
} );
</script>
</cfoutput>