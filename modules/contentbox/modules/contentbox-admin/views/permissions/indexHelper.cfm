<cfoutput>
<!--- Custom JS --->
<script>
document.addEventListener( "DOMContentLoaded", () => {
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
	<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN" )>
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
<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT,TOOLS_EXPORT" )>
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
function exportSelected( exportEvent ){
	var selected = [];
	$( "##permissionID:checked" ).each( function(){
		selected.push( $( this ).val() );
	} );
	if( selected.length ){
		checkAll( false, 'permissionID' );
		window.open( exportEvent + "/permissionID/" + selected );
	} else {
		alert( "Please select something to export!" );
	}
}
</cfif>
</script>
</cfoutput>