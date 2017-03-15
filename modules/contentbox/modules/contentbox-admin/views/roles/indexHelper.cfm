<cfoutput>
<!--- Custom JS --->
<script>
$(document).ready(function() {
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
	<cfif prc.oAuthor.checkPermission( "ROLES_ADMIN" )>
	$importDialog = $( "##importDialog" );
	$roleEditor = $( "##roleEditor" );
	// form validator
	$roleEditor.validate();
	// reset
	$('##btnReset').click(function() {
		$roleEditor.find( "##roleID" ).val( '' );
	} );
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
<cfif prc.oAuthor.checkPermission( "ROLES_ADMIN,TOOLS_IMPORT" )>
function edit(roleID,role,description){
	openModal( $( "##roleEditorContainer" ), 500, 200 );
	$roleEditor.find( "##roleID" ).val( roleID );
	$roleEditor.find( "##role" ).val( role );
	$roleEditor.find( "##description" ).val( description );
}
function remove(roleID){
	var $roleForm = $( "##roleForm" );
	$( "##delete_"+ roleID).removeClass( "icon-remove-sign" ).addClass( "fa fa-spinner fa-spin" );
	$roleForm.find( "##roleID" ).val( roleID );
	$roleForm.submit();
}
function createRole(){
	openModal( $( "##roleEditorContainer" ), 500, 200 );
	$roleEditor.find( "##roleID" ).val( '' );
	$roleEditor.find( "##role" ).val( '' );
	$roleEditor.find( "##description" ).val( '' );
	return false;
}
</cfif>
</script>
</cfoutput>