<cfoutput>
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
	// Take height for iframe
	$("##previewFrame").attr("height", $("##remoteModelContent").height() - 50 + "px" );
	// load source
	$("##previewForm").submit();
});
</script>
</cfoutput>