<cfoutput>
<script>
( () => {
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
	$( "##entriesCountContainer" ).html( "(" + $( "##contentCount" ).val() + ")" );
	// activate confirmations
	activateConfirmations();
	// activate tooltips
	activateTooltips();
	// quick look
	contentListHelper.activateQuickLook( $entries, '#event.buildLink( prc.xehEntryQuickLook )#/contentID/' );
	// Info Panels
	contentListHelper.activateInfoPanels();
} )();
</script>
</cfoutput>