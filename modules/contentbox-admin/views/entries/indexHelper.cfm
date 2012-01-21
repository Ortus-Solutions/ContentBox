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
	    	if($(this).attr('data-entryID') != null) {
				openRemoteModal('#event.buildLink(prc.xehEntryQuickLook)#/entryID/' + $(this).attr('data-entryID'));
				e.preventDefault();
			}
	    }
	});

});
function remove(entryID){
	$("##entryID").val( entryID );
	$("##entryForm").submit();
}
</script>
</cfoutput>