<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	$contentForm = $("##contentForm");
	$importDialog = $("##importDialog");
	// sorting and filter
	$contentForm.find("##entries").tablesorter();
	$contentForm.find("##entryFilter").keyup(function(){
		$.uiTableFilter( $("##entries"), this.value );
	});
});
<cfif prc.oAuthor.checkPermission("CUSTOMHTML_ADMIN,TOOLS_IMPORT")>
function importContent(){
	// local id's
	var $importForm = $("##importForm");
	// open modal for cloning options
	openModal( $importDialog, 500, 350 );
	// form validator and data
	$importForm.validate({ 
		submitHandler: function(form){
           	$importForm.find("##importButtonBar").slideUp();
			$importForm.find("##importBarLoader").slideDown();
			form.submit();
        }
	});
	// close button
	$importForm.find("##closeButton").click(function(e){
		closeModal( $importDialog ); return false;
	});
	// clone button
	$importForm.find("##importButton").click(function(e){
		$importForm.submit();
	});
}
function remove(recordID){
	if( recordID != null ){
		$("##delete_"+ recordID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
		$("##contentID").val( recordID );
	}
	//Submit Form
	$contentForm.submit();
}
function bulkChangeStatus(status, contentID){
	$contentForm.attr("action","#event.buildlink( linkTo=prc.xehBulkStatus )#");
	$contentForm.find("##contentStatus").val( status );
	if( contentID != null ){
		$("##status_"+ recordID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
		checkByValue('contentID',contentID);	
	}
	$contentForm.submit();
}
</cfif>
</script>
</cfoutput>