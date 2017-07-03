<cfoutput>
<!--- Custom JS --->
<script>
$(document).ready(function() {
	$uploadForm = $( "##moduleUploadForm" );
	$moduleForm = $( "##moduleForm" );
	$forgebox   = $( "##forgeboxPane" );
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