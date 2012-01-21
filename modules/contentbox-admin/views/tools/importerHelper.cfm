<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	$importForm = $("##importerForm");
	// form validator
	$importForm.validator({position:'center right',onSuccess:function(e,els){ activateLoaders(); }});	
});
function activateLoaders(){
	$("##uploadBar").slideToggle();
	$("##uploadBarLoader").slideToggle();
}
</script>
</cfoutput>