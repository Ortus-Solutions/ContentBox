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
	var icon 			= '<i class="fa fa-circle-o-notch fa-spin"></i>';
	var $btn 			= $( "##btnUpdates" );
	var originalValue 	= $btn.html();

	$btn.html( icon + originalValue );
	var channel = $updateCheckForm.find( "input[name='channel']:checked" ).val();
	// open update modal
	openRemoteModal( 
		'#event.buildLink(prc.xehUpdateCheck)#',
		{ channel:channel },
		function( data ){
			$btn.html( originalValue );
		} 
	);
	
	return false;
}
</script>
</cfoutput>