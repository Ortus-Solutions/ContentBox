<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$permissionForm = $("##permissionForm");
});
<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN")>
function addPermission(){
	// loader
	$("##permissionLoader").slideDown();
	// Assign it
	$.post('#event.buildLink(prc.xehPermissionSave)#',{authorID:'#rc.authorID#',permissionID:$permissionForm.find("##permissionID").val() },function(){ 
		$("##permissionLoader").slideUp();
		// load permissions via container
		loadPermissions(); 
	});
}
function removePermission(permissionID){
	// loader
	$("##permissionLoader").slideDown();
	// Assign it
	$.post('#event.buildLink(prc.xehPermissionRemove)#',{authorID:'#rc.authorID#',permissionID:permissionID },function(){ 
		$("##permissionLoader").slideUp();
		// load permissions via container
		loadPermissions();
	});
}
</cfif>
</script>
</cfoutput>