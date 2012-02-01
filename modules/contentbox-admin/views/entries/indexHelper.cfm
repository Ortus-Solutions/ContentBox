<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	$("##entries").tablesorter();
	$("##entryFilter").keyup(function(){
		$.uiTableFilter( $("##entries"), this.value );
	});
	// quick look
	$("##entries").find("tr").bind("contextmenu",function(e) {
	    if (e.which === 3) {
	    	if($(this).attr('data-contentID') != null) {
				openRemoteModal('#event.buildLink(prc.xehEntryQuickLook)#/contentID/' + $(this).attr('data-contentID'));
				e.preventDefault();
			}
	    }
	});

});
function remove(contentID){
	$("##contentID").val( contentID );
	$("##entryForm").submit();
}
</script>
</cfoutput>