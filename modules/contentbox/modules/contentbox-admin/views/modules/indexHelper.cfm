<cfoutput>
<!--- Custom JS --->
<script>
document.addEventListener( "DOMContentLoaded", () => {
	$uploadForm = $( "##moduleUploadForm" );
	$moduleForm = $( "##moduleForm" );
	$( "##modules" ).dataTable( {
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
	$( "##moduleFilter" ).keyup(
		_.debounce(
            function(){
                $.uiTableFilter( $( "##modules" ), this.value );
            },
            300
        )
	);
	// form validator
	$uploadForm.validate( {success:function(e,els){ activateLoaders(); }} );
} );
function activateLoaders(){
	$( "##uploadBar" ).slideToggle();
	$( "##uploadBarLoader" ).slideToggle();
}
function remove(moduleName){
	$moduleForm.find( "##moduleName" ).val( moduleName );
	$moduleForm.attr( "action","#event.buildLink(prc.xehModuleRemove)#" );
	$moduleForm.submit();
}
function activate(moduleName){
	$moduleForm.find( "##moduleName" ).val( moduleName );
	$moduleForm.attr( "action","#event.buildLink(prc.xehModuleActivate)#" );
	$moduleForm.submit();
}
function deactivate(moduleName){
	$moduleForm.find( "##moduleName" ).val( moduleName );
	$moduleForm.attr( "action","#event.buildLink(prc.xehModuleDeactivate)#" );
	$moduleForm.submit();
}
</script>
</cfoutput>