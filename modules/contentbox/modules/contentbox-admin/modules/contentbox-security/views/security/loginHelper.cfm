<cfoutput>
<script type="text/javascript">
document.addEventListener( "DOMContentLoaded", () => {
	// form validators
	$( "##loginForm" ).validate();
	<cfif len(prc.rememberMe)>
		//Get Focus
		$( "##password" ).focus();
	<cfelse>
		$( "##username" ).focus();
	</cfif>
} );
</script>
</cfoutput>