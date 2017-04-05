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
	$forgebox.load('#event.buildLink(prc.xehForgeBox)#',
		{typeslug:'#prc.forgeBoxSlug#', installDir:'#prc.forgeBoxInstallDir#', returnURL:'#prc.forgeboxReturnURL#', orderBY:orderBY} );
}
</script>
</cfoutput>