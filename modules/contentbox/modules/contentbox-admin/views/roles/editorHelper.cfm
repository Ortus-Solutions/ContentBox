<cfoutput>
	<script>
	document.addEventListener( "DOMContentLoaded", () => {
		$roleForm = $( "##roleForm" );
		// form validators
		$roleForm.validate();
		// Quick div filter
		$( "##roleFilter" ).keyup( function(){
			$.uiDivFilter( $( ".thisPermission" ), this.value );
		} );
	} );
	function clearFilter(){
		$( '##roleFilter' ).val( '' );
		$( ".thisPermission" ).show();
	}
	</script>
	</cfoutput>