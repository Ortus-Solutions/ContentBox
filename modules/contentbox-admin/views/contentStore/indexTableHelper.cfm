<cfoutput>
<script>
$(document).ready(function() {
	// tables references
	$content = $( "##content" );
	// sorting
	$content.dataTable( {
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
	// Popovers
	activateInfoPanels();
} );
</script>
</cfoutput>