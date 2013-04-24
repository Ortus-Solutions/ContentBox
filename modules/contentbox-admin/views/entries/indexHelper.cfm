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
    // Popovers
	$(".popovers").popover({
		html : true,
		content : function(){
			return getInfoPanelContent( $(this).attr( "data-contentID" ) );
		},
		trigger : 'hover',
		placement : 'left',
		title : '<i class="icon-info-sign"></i> Quick Info',
		delay : { show: 200, hide: 500 }
	});
});
function getInfoPanelContent(contentID){
	return $("##infoPanel_" + contentID).html();
}
function remove(contentID){
	if( contentID != null ){
		$("##delete_"+ contentID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
		checkByValue('contentID',contentID);		
	}
	$entryForm.submit();
}
function bulkChangeStatus(status, contentID){
	$entryForm.attr("action","#event.buildlink(linkTo=prc.xehEntryBulkStatus)#");
	$entryForm.find("##contentStatus").val( status );
	if( contentID != null ){
		$("##status_"+ recordID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
		checkByValue('contentID',contentID);	
	}
	$entryForm.submit();
}
</script>
</cfoutput>