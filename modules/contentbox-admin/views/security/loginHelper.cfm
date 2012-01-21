<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	<cfif len(prc.rememberMe)>
		//Get Focus
		$("##password").focus();
	<cfelse>
		$("##username").focus();
	</cfif>
	// form validators
	$("##loginForm").validator({grouped:true});
});
</script>
</cfoutput>