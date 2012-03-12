<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$uploadForm = $("##widgetUploadForm");
	$widgetForm = $("##widgetForm");
	// table sorting + filtering
	$("##widgets").tablesorter();
	$("##widgetFilter").keyup(function(){
		$.uiTableFilter( $("##widgets"), this.value );
	});
	// form validator
	$uploadForm.validator({position:'top left',onSuccess:function(e,els){ activateLoaders(); }});	
});
function activateLoaders(){
	$("##uploadBar").slideToggle();
	$("##uploadBarLoader").slideToggle();
}
function remove(widgetFile){
	$widgetForm.find("##widgetFile").val( widgetFile );
	$widgetForm.submit();
}
</script>
</cfoutput>