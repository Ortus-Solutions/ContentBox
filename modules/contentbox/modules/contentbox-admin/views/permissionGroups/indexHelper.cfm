<cfoutput>
<!--- Custom JS --->
<script>
$( document ).ready(function() {
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
	$groupEditor 	= $( "##groupEditor" );
	
	// form validator
	$groupEditor.validate();
	
	// reset
	$( '##btnReset' ).click( function(){
		$groupEditor.find( "##permissionGroupID" ).val( '' );
	} );
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

<cfif prc.oCurrentAuthor.checkPermission( "PERMISSIONS_ADMIN,TOOLS_IMPORT" )>
function edit( permissionGroupID, name, description ){
	openModal( $( "##groupEditorContainer" ), 500, 200 );
	$groupEditor.find( "##permissionGroupID" ).val( permissionGroupID );
	$groupEditor.find( "##name" ).val( name );
	$groupEditor.find( "##description" ).val( description );
}
function remove( permissionGroupID ){
	var $groupForm = $( "##groupForm" );
	$( "##delete_"+ permissionGroupID).removeClass( "fa-trash-o" ).addClass( "fa fa-spinner fa-spin" );
	$groupForm.find( "##permissionGroupID" ).val( permissionGroupID );
	$groupForm.submit();
}
function createGroup(){
	openModal( $( "##groupEditorContainer" ), 500, 200 );
	$groupEditor.find( "##permissionGroupID" ).val( '' );
	$groupEditor.find( "##name" ).val( '' );
	$groupEditor.find( "##description" ).val( '' );
	return false;
}
</cfif>
</script>
</cfoutput>