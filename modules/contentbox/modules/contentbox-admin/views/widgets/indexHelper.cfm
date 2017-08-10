<cfoutput>
<!--- Custom JS --->
<script>
$(document).ready(function() {
	$uploadForm = $( "##widgetUploadForm" );
	$widgetForm = $( "##widgetForm" );
	$forgebox   = $( "##forgeboxPane" );
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
function loadForgeBox(orderBY){
	if( orderBY == null ){ orderBY = "popular"; }

	var params = {
		typeslug: '#prc.forgeBoxSlug#',
		installDir: '#prc.forgeBoxInstallDir#',
		returnURL: '#prc.forgeboxReturnURL#',
		orderBY: orderBY
	};

	$forgebox.load('#event.buildLink(prc.xehForgeBox)#?' + $.param( params ) );
}
</script>
</cfoutput>