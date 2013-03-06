<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	$importForm = $("##importerForm");
	// form validator
	$importForm.validator({position:'center right'});	
	$importForm.submit(function(){
		if ($importForm.data("validator").checkValidity()) {
			activateLoaders();
		}
	});
});
function activateLoaders(){
	$("##uploadBar").slideToggle();
	$("##uploadBarLoader").slideToggle();
}
</script>
</cfoutput>