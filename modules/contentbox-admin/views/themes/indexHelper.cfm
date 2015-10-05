<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$uploadForm = $( "##themeUploadForm" );
	$themeForm = $( "##themeForm" );
	$forgebox   = $( "##forgeboxPane" );
	// table sorting + filtering
	$( "##themes" ).dataTable( {
		"paging": false,
		"info": false,
		"searching": false,
	    "columnDefs": [
	        { 
	            "orderable": false, 
	            "targets": '{sorter:false}' 
	        }
	    ],
	    "order": []
	} );
	$( "##themeFilter" ).keyup(function(){
		$.uiTableFilter( $( "##themes" ), this.value );
	} );
	// form validator
	$uploadForm.validate( {
        success:function(e,els){ activateLoaders(); }
    } );	
} );
function activateLoaders(){
	$( "##uploadBar" ).slideToggle();
	$( "##uploadBarLoader" ).slideToggle();
}
function remove(themeName){
	$themeForm.find( "##themeName" ).val( themeName );
	$themeForm.submit();
}
function loadForgeBox(orderBY){
	if( orderBY == null ){ orderBY = "popular"; }
	$forgebox.load('#event.buildLink(prc.xehForgeBox)#',
		{typeslug:'#prc.forgeBoxSlug#', installDir:'#prc.forgeBoxInstallDir#', returnURL:'#prc.forgeboxReturnURL#', orderBY:orderBY} );
}
function toggleUploader(){
	$( "##uploaderBar" ).slideToggle();
	return false;
}
</script>
</cfoutput>