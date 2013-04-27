<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	<cfif prc.oAuthor.checkPermission("ROLES_ADMIN")>
	$roleEditor = $("##roleEditor");
	// form validator
	$roleEditor.validate();
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
	openModal( $("##roleEditorContainer"), 500, 200 );
	$roleEditor.find("##roleID").val( roleID );
	$roleEditor.find("##role").val( role );
	$roleEditor.find("##description").val( description );
}
function remove(roleID){
	var $roleForm = $("##roleForm");
	$("##delete_"+ roleID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
	$roleForm.find("##roleID").val( roleID );
	$roleForm.submit();
}
function createRole(){
    // open modal
	openModal( $("##roleEditorContainer"), 500, 200 );
	return false;
}
</cfif>
</script>
</cfoutput>