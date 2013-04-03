<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	$("##authors").tablesorter();
	$("##authorFilter").keyup(function(){
		$.uiTableFilter( $("##authors"), this.value );
	})
});
function removeAuthor(authorID){
	$("##delete_"+ authorID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
	$("##authorID").val( authorID );
	$("##authorForm").submit();
}
</script>
</cfoutput>