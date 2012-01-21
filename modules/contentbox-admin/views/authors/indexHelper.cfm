<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	$("##authors").tablesorter();
	$("##authorFilter").keyup(function(){
		$.uiTableFilter( $("##authors"), this.value );
	})
});
function removeAuthor(authorID){
	$("##authorID").val( authorID );
	$("##authorForm").submit();
}
</script>
</cfoutput>