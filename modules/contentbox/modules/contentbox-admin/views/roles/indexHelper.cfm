<cfoutput>
<!--- Custom JS --->
<script>
document.addEventListener( "DOMContentLoaded", () => {
	$( "##roles" ).dataTable( {
		"paging": false,
		"info": false,
		"searching": false,
	    "columnDefs": [
	        {
	            "orderable": false,
	            "targets": '{sorter:false}'
	        }
	    ],
	    "order": []
	} );

	<cfif prc.oCurrentAuthor.checkPermission( "ROLES_ADMIN" )>
	$importDialog = $( "##importDialog" );
	</cfif>

	// table sorting + filtering
	$( "##roleFilter" ).keyup(
		_.debounce(
            function(){
                $.uiTableFilter( $( "##roles" ), this.value );
            },
            300
        )
	);
} );
<cfif prc.oCurrentAuthor.checkPermission( "ROLES_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
function remove( roleID ){
	var $roleForm = $( "##roleForm" );
	$( "##delete_"+ roleID )
		.removeClass( "fa-trash-o" )
		.addClass( "fa fa-spinner fa-spin" );
	$roleForm.find( "##roleID" ).val( roleID );
	$roleForm.submit();
}
function exportSelected( exportEvent ){
	var selected = [];
	$( "##roleID:checked" ).each( function(){
		selected.push( $( this ).val() );
	} );
	if( selected.length ){
		checkAll( false, 'roleID' );
		window.open( exportEvent + "/roleID/" + selected );
	} else {
		alert( "Please select something to export!" );
	}
}
</cfif>
</script>
</cfoutput>