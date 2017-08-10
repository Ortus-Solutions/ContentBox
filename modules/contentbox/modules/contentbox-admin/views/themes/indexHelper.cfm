<cfoutput>
<!--- Custom JS --->
<script>
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
	$( "##themeFilter" ).keyup(
		_.debounce(
            function(){
                $.uiTableFilter( $( "##themes" ), this.value );
            },
            300
        )
	);
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

	var params = {
		typeslug: '#prc.forgeBoxSlug#',
		installDir: '#prc.forgeBoxInstallDir#',
		returnURL: '#prc.forgeboxReturnURL#',
		orderBY: orderBY
	};

	$forgebox.load('#event.buildLink(prc.xehForgeBox)#?' + $.param( params ) );
}
function toggleUploader(){
	$( "##uploaderBar" ).slideToggle();
	return false;
}
</script>
</cfoutput>