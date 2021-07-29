<cfoutput>
<!--- Custom JS --->
<script>
document.addEventListener( "DOMContentLoaded", () => {
	$uploadForm = $( "##themeUploadForm" );
	$themeForm = $( "##themeForm" );
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
function toggleUploader(){
	$( "##uploaderBar" ).slideToggle();
	return false;
}
</script>
</cfoutput>