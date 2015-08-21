<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$importDialog = $( "##importDialog" );
	// table sorting + filtering
	//$( "##permissions" ).tablesorter();
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
	$( "##permissionFilter" ).keyup(function(){
		$.uiTableFilter( $( "##permissions" ), this.value );
	} );
	<cfif prc.oAuthor.checkPermission( "PERMISSIONS_ADMIN" )>
	// form id
	$permissionEditor = $( "##permissionEditor" );
	// form validator
	$permissionEditor.validate();
	// reset
	$('##btnReset').click(function() {
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
function importContent(){
	// local id's
	var $importForm = $( "##importForm" );
	// open modal for cloning options
	openModal( $importDialog, 500, 350 );
	// form validator and data
	$importForm.validate( { 
		submitHandler: function(form){
           	$importForm.find( "##importButtonBar" ).slideUp();
			$importForm.find( "##importBarLoader" ).slideDown();
			form.submit();
        }
	} );
	// close button
	$importForm.find( "##closeButton" ).click(function(e){
		closeModal( $importDialog ); return false;
	} );
	// clone button
	$importForm.find( "##importButton" ).click(function(e){
		$importForm.submit();
	} );
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