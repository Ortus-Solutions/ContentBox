<cfoutput>
<!--- Custom JS --->
<script>
$( document ).ready(function() {
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
<cfif prc.oCurrentAuthor.checkPermission( "ROLES_ADMIN,TOOLS_IMPORT" )>
function remove(roleID){
	var $roleForm = $( "##roleForm" );
	$( "##delete_"+ roleID).removeClass( "fa-trash-o" ).addClass( "fa fa-spinner fa-spin" );
	$roleForm.find( "##roleID" ).val( roleID );
	$roleForm.submit();
}
</cfif>
</script>
</cfoutput>