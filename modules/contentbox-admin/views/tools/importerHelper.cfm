<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	$importForm = $("##importerForm");
	// form validator
	$importForm.validate();	
	$importForm.submit(function(){
		if ( $importForm.valid() ) {
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