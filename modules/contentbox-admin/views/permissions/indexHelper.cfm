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
	$permissionEditor.validate();
	// reset
	$('##btnReset').click(function() {
		$permissionEditor.find("##permissionID").val( '' );
	});
	</cfif>
});
<cfif prc.oAuthor.checkPermission("PERMISSIONS_ADMIN")>
function edit(permissionID,permission,description){
	openModal( $("##permissionEditorContainer"), 500, 200 );
	$permissionEditor.find("##permissionID").val( permissionID );
	$permissionEditor.find("##permission").val( permission );
	$permissionEditor.find("##description").val( description );
}
function remove(permissionID){
	var $permissionForm = $("##permissionForm");
	$("##delete_"+ permissionID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
	$permissionForm.find("##permissionID").val( permissionID );
	$permissionForm.submit();
}
function createPermission(){
	openModal( $("##permissionEditorContainer"), 500, 200 );
	$permissionEditor.find("##permissionID").val( '' );
	$permissionEditor.find("##permission").val( '' );
	$permissionEditor.find("##description").val( '' );
	return false;
}
</cfif>
</script>
</cfoutput>