<cfoutput>
<script>
document.addEventListener( "DOMContentLoaded", () => {
	$( "##groups" ).dataTable( {
		"paging"		: false,
		"info"			: false,
		"searching"		: false,
	    "columnDefs"	: [
	        {
	            "orderable"	: false,
	            "targets"	: '{sorter:false}'
	        }
	    ],
	    "order" 		: []
	} );

	<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN" )>
	$importDialog 	= $( "##importDialog" );
	</cfif>

	// table sorting + filtering
	$( "##groupFilter" ).keyup(
		_.debounce(
            function(){
                $.uiTableFilter( $( "##groups" ), this.value );
            },
            300
        )
	);
} );

<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
function remove( permissionGroupID ){
	var $groupForm = $( "##groupForm" );
	$( "##delete_"+ permissionGroupID).removeClass( "fa-trash-o" ).addClass( "fa fa-spinner fa-spin" );
	$groupForm.find( "##permissionGroupID" ).val( permissionGroupID );
	$groupForm.submit();
}
function exportSelected( exportEvent ){
	var selected = [];
	$( "##permissionGroupID:checked" ).each( function(){
		selected.push( $( this ).val() );
	} );
	if( selected.length ){
		checkAll( false, 'permissionGroupID' );
		window.open( exportEvent + "/permissionGroupID/" + selected );
	} else {
		alert( "Please select something to export!" );
	}
}
</cfif>
</script>
</cfoutput>