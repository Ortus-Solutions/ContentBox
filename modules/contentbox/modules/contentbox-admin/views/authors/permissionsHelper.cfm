<cfoutput>
<!--- Custom JS --->
<script>
( () => {
	$permissionForm = $( "##permissionForm" );
	$groupsForm 	= $( "##groupsForm" );
} )();
<cfif prc.oCurrentAuthor.checkPermission( "AUTHOR_ADMIN" )>
function addPermission(){
	// loader
	$( "##permissionLoader" ).slideDown();
	// Assign it
	$.post(
		'#event.buildLink( prc.xehPermissionSave )#',
		{
			authorID	 : '#rc.authorID#',
			permissionID : $permissionForm.find( "##permissionID" ).val()
		},
		function(){
			$( "##permissionLoader" ).slideUp();
			// load permissions via container
			loadPermissions();
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
			authorID	 : '#rc.authorID#',
			permissionID : permissionID
		},
		function(){
			$( "##permissionLoader" ).slideUp();
			// load permissions via container
			loadPermissions();
		}
	);
}
function addPermissionGroup(){
	// loader
	$( "##groupsLoader" ).slideDown();
	// Assign it
	$.post(
		'#event.buildLink( prc.xehGroupSave )#',
		{
			authorID	 		: '#rc.authorID#',
			permissionGroupID 	: $groupsForm.find( "##permissionGroupID" ).val()
		},
		function(){
			$( "##groupsLoader" ).slideUp();
			// load permissions via container
			loadPermissions();
		}
	);
}
function removePermissionGroup( permissionGroupID ){
	// loader
	$( "##groupsLoader" ).slideDown();
	// Assign it
	$.post(
		'#event.buildLink( prc.xehGroupRemove )#',
		{
			authorID	 		: '#rc.authorID#',
			permissionGroupID 	: permissionGroupID
		},
		function(){
			$( "##groupsLoader" ).slideUp();
			// load permissions via container
			loadPermissions();
		}
	);
}
</cfif>
</script>
</cfoutput>