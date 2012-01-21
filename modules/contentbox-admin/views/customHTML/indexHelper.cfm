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
		$('##delete_'+recordID).attr('src','#prc.cbRoot#/includes/images/ajax-spinner.gif');
		$("##contentID").val( recordID );
	}
	//Submit Form
	$contentForm.submit();
}</script>
</cfoutput>