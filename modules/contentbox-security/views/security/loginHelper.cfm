<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
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