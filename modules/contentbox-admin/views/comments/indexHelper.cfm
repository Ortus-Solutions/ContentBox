<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$commentForm = $("##commentForm");
	$commentForm.find("##comments").tablesorter();
	$commentForm.find("##commentFilter").keyup(function(){
		$.uiTableFilter( $("##comments"), this.value );
	});
	// comment quick look
	$commentForm.find("##comments").find("tr").bind("contextmenu",function(e) {
	    if (e.which === 3) {
	    	if ($(this).attr('data-commentID') != null) {
				openRemoteModal('#event.buildLink(prc.xehCommentQuickLook)#', {
					commentID: $(this).attr('data-commentID')
				});
				e.preventDefault();
			}
	    }
	});
});
<cfif prc.oAuthor.checkPermission("COMMENTS_ADMIN")>
function changeStatus(status,recordID){
	$commentForm.attr("action","#event.buildlink(linkTo=prc.xehCommentstatus)#");
	$commentForm.find("##commentStatus").val(status);
	if( recordID != null ){
		$("##status_"+ recordID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
		checkByValue('commentID',recordID);	
	}
	$commentForm.submit();
}
function remove(recordID){
	if( recordID != null ){
		$("##delete_"+ recordID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
		checkByValue('commentID',recordID);		
	}
	//Submit Form
	$commentForm.submit();
}
</cfif>
</script>
</cfoutput>