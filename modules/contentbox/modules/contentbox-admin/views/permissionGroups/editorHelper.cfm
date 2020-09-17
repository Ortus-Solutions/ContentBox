<cfoutput>
	<script>
	$( document ).ready( function() {
		$groupForm = $( "##groupForm" );
		// form validators
		$groupForm.validate();
		// Quick div filter
		$( "##permissionFilter" ).keyup( function(){
			$.uiDivFilter( $( ".thisPermission" ), this.value );
		} );
	} );
	function clearFilter(){
		$( '##permissionFilter' ).val( '' );
		$( ".thisPermission" ).show();
	}
	</script>
	</cfoutput>