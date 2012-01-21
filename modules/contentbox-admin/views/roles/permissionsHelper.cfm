<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$permissionForm = $("##permissionForm");
});
function addPermission(){
	// loader
	$("##permissionLoader").slideDown();
	// Assign it
	$.post('#event.buildLink(prc.xehPermissionSave)#',{roleID:'#prc.role.getRoleID()#',permissionID:$permissionForm.find("##permissionID").val() },function(){ 
		$("##permissionLoader").slideUp();
		reloadPerms(); 
	});
}
function removePermission(permissionID){
	// loader
	$("##permissionLoader").slideDown();
	// Assign it
	$.post('#event.buildLink(prc.xehPermissionRemove)#',{roleID:'#prc.role.getRoleID()#',permissionID:permissionID },function(){ 
		$("##permissionLoader").slideUp();
		reloadPerms();
	});
}
function reloadPerms(){
	$remoteModalContent.load('#event.buildLink(prc.xehRolePermissions)#/roleID/#prc.role.getRoleID()#');
}
</script>
</cfoutput>