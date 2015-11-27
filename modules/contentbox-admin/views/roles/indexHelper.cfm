<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
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
	//$( "##roles" ).tablesorter();
	$( "##roleFilter" ).keyup(function(){
		$.uiTableFilter( $( "##roles" ), this.value );
	} );
} );
<cfif prc.oAuthor.checkPermission( "ROLES_ADMIN,TOOLS_IMPORT" )>
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