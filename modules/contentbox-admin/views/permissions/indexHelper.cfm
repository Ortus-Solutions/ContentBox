<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	// table sorting + filtering
	$("##permissions").tablesorter();
	$("##permissionFilter").keyup(function(){
		$.uiTableFilter( $("##permissions"), this.value );
	});
	<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN")>
	// form id
	$permissionEditor = $("##permissionEditor");
	// form validator
	$permissionEditor.validator({position:'top left'});
	// reset
	$('##btnReset').click(function() {
		$permissionEditor.find("##permissionID").val( '' );
	});
	</cfif>
});
<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN")>
function edit(permissionID,permission,description){
	$permissionEditor.find("##permissionID").val( permissionID );
	$permissionEditor.find("##permission").val( permission );
	$permissionEditor.find("##description").val( description );
}
function remove(permissionID){
	var $permissionForm = $("##permissionForm");
	$permissionForm.find("##permissionID").val( permissionID );
	$permissionForm.submit();
}
</cfif>
</script>
</cfoutput>