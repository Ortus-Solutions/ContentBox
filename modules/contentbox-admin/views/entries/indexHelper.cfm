<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	// global ids
	$entryForm = $("##entryForm");
	$entries	  = $("##entries");
	// filters and sorters
	$entries.tablesorter();
	$("##entryFilter").keyup(function(){
		$.uiTableFilter( $("##entries"), this.value );
	});
	// quick look
	$entries.find("tr").bind("contextmenu",function(e) {
	    if (e.which === 3) {
	    	if($(this).attr('data-contentID') != null) {
				openRemoteModal('#event.buildLink(prc.xehEntryQuickLook)#/contentID/' + $(this).attr('data-contentID'));
				e.preventDefault();
			}
	    }
	});

});
function toggleActionsPanel(contentID){
	$("##entryActions_" + contentID).slideToggle();
	return false;
}
function toggleInfoPanel(contentID){
	$("##infoPanel_" + contentID).slideToggle();
	return false;
}
function remove(contentID){
	if( contentID != null ){
		$('##delete_'+contentID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
		checkByValue('contentID',contentID);		
	}
	$entryForm.submit();
}
function bulkChangeStatus(status, contentID){
	$entryForm.attr("action","#event.buildlink(linkTo=prc.xehEntryBulkStatus)#");
	$entryForm.find("##contentStatus").val( status );
	if( contentID != null ){
		$('##status_'+recordID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
		checkByValue('contentID',contentID);	
	}
	$entryForm.submit();
}
</script>
</cfoutput>