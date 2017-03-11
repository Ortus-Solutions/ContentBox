<cfoutput>
<!--- Custom JS --->
<script>
$(document).ready(function() {
	$importDialog = $( "##importDialog" );
	// table sorting + filtering
	$( "##permissions" ).dataTable( {
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
	$( "##permissionFilter" ).keyup(
		_.debounce(
            function(){
                $.uiTableFilter( $( "##permissions" ), this.value );
            },
            300
        )
	);
	<cfif prc.oAuthor.checkPermission( "PERMISSIONS_ADMIN" )>
	// form id
	$permissionEditor = $( "##permissionEditor" );
	// form validator
	$permissionEditor.validate();
	// reset
	$( '##btnReset' ).click( function() {
		$permissionEditor.find( "##permissionID" ).val( '' );
	} );
	</cfif>
} );
<cfif prc.oAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT" )>
function edit(permissionID,permission,description){
	openModal( $( "##permissionEditorContainer" ), 500, 200 );
	$permissionEditor.find( "##permissionID" ).val( permissionID );
	$permissionEditor.find( "##permission" ).val( permission );
	$permissionEditor.find( "##description" ).val( description );
}
function remove(permissionID){
	var $permissionForm = $( "##permissionForm" );
	$( "##delete_"+ permissionID).removeClass( "fa-times" ).addClass( "fa fa-spinner icon-spin" );
	$permissionForm.find( "##permissionID" ).val( permissionID );
	$permissionForm.submit();
}
function createPermission(){
	openModal( $( "##permissionEditorContainer" ), 500, 200 );
	$permissionEditor.find( "##permissionID" ).val( '' );
	$permissionEditor.find( "##permission" ).val( '' );
	$permissionEditor.find( "##description" ).val( '' );
	return false;
}
</cfif>
</script>
</cfoutput>