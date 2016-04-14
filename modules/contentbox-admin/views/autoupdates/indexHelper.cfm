<cfoutput>
<!--- Custom JS --->
<script>
$(document).ready(function() {
	$updateCheckForm = $( "##updateCheckForm" );
	// form validators
	$( "##updateNowForm" ).validate();
	$( "##uploadNowForm" ).validate();
} );
function checkForUpdates(){
	var channel = $updateCheckForm.find( "input[name='channel']:checked" ).val();
	// open update modal
	openRemoteModal('#event.buildLink(prc.xehUpdateCheck)#',{channel:channel} );
	
	return false;
}
</script>
</cfoutput>