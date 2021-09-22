<cfoutput>
<!--- Custom JS --->
<script>
document.addEventListener( "DOMContentLoaded", () => {
	$uploadForm = $( "##widgetUploadForm" );
	$widgetForm = $( "##widgetForm" );
	// form validator
	$uploadForm.validate( {success:function(e,els){ activateLoaders(); }} );
} );
function activateLoaders(){
	$( "##uploadBar" ).slideToggle();
	$( "##uploadBarLoader" ).slideToggle();
}
function remove(widgetFile){
	$widgetForm.find( "##widgetFile" ).val( widgetFile );
	$widgetForm.submit();
}
</script>
</cfoutput>