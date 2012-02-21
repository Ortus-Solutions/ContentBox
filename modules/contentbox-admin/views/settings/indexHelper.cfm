<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	// form validators
	$("##settingsForm").validator({grouped:true});
});
function chooseAdapter(adapter){
	$("##settingsForm").find("##cb_search_adapter").val( adapter );
}
</script>
</cfoutput>