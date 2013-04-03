<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	$contentForm = $("##contentForm");
	$contentForm.find("##entries").tablesorter();
	$contentForm.find("##entryFilter").keyup(function(){
		$.uiTableFilter( $("##entries"), this.value );
	});
});
function remove(recordID){
	if( recordID != null ){
		$("##delete_"+ recordID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
		$("##contentID").val( recordID );
	}
	//Submit Form
	$contentForm.submit();
}</script>
</cfoutput>