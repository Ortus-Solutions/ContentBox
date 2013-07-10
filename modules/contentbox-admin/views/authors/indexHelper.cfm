<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	$importDialog = $("##importDialog");
	$("##authors").tablesorter();
	$("##authorFilter").keyup(function(){
		$.uiTableFilter( $("##authors"), this.value );
	})
});
<cfif prc.oAuthor.checkPermission("AUTHOR_ADMIN")>
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
function removeAuthor(authorID){
	$("##delete_"+ authorID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
	$("##authorID").val( authorID );
	$("##authorForm").submit();
}
</cfif>
</script>
</cfoutput>