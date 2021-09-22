<cfoutput>
<script>
document.addEventListener( "DOMContentLoaded", () => {
	$importDialog 	= $( "##importDialog" );
	$siteForm 		= $( "##siteForm" );
	$sitesTable 	= $siteForm.find( "##sites" );
	$siteForm.find( "##sites" ).dataTable( {
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
	$siteForm.find( "##siteFilter" ).keyup(
		_.debounce(
            function(){
                $.uiTableFilter( $( "##sites" ), this.value );
            },
            300
        )
	);
} );
function remove( recordID ){
	if( recordID != null ){
		$( "##delete_"+ recordID )
			.removeClass( "fa fa-minus-circle" )
			.addClass( "fa fa-spinner fa-spin" );
		$( "##siteID" ).val( recordID );
	}
	//Submit Form
	$siteForm.submit();
}
</script>
</cfoutput>