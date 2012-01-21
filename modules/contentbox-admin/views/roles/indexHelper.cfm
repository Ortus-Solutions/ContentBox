<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	<cfif prc.oAuthor.checkPermission("ROLES_ADMIN")>
	$roleEditor = $("##roleEditor");
	// form validator
	$roleEditor.validator({position:'top left'});
	// reset
	$('##btnReset').click(function() {
		$roleEditor.find("##roleID").val( '' );
	});
	</cfif>
	// table sorting + filtering
	$("##roles").tablesorter();
	$("##roleFilter").keyup(function(){
		$.uiTableFilter( $("##roles"), this.value );
	});
});
<cfif prc.oAuthor.checkPermission("ROLES_ADMIN")>
function edit(roleID,role,description){
	$roleEditor.find("##roleID").val( roleID );
	$roleEditor.find("##role").val( role );
	$roleEditor.find("##description").val( description );
}
function remove(roleID){
	var $roleForm = $("##roleForm");
	$roleForm.find("##roleID").val( roleID );
	$roleForm.submit();
}
</cfif>
</script>
</cfoutput>