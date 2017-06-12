<cfoutput>
<!--- Custom JS --->
<script>
$( document ).ready( function(){
	$permissionForm = $( "##permissionForm" );
} );
function addPermission(){
	// loader
	$( "##permissionLoader" ).slideDown();
	// Assign it
	$.post(
		'#event.buildLink( prc.xehPermissionSave )#',
		{
			permissionGroupID	: '#prc.oGroup.getPermissionGroupID()#',
			permissionID 		: $permissionForm.find( "##permissionID" ).val()
		},
		function(){ 
			$( "##permissionLoader" ).slideUp();
			reloadPerms(); 
		} 
	);
}
function removePermission( permissionID ){
	// loader
	$( "##permissionLoader" ).slideDown();
	// Assign it
	$.post(
		'#event.buildLink( prc.xehPermissionRemove )#',
		{
			permissionGroupID 	: '#prc.oGroup.getPermissionGroupID()#',
			permissionID		: permissionID 
		},
		function(){ 
			$( "##permissionLoader" ).slideUp();
			reloadPerms();
		} 
	);
}
function reloadPerms(){
	$remoteModal.load( '#event.buildLink( prc.xehGroupPermissions )#/permissionGroupID/#prc.oGroup.getPermissionGroupID()#' );
}
</script>
</cfoutput>