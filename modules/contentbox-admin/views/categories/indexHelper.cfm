<cfoutput>
<!--- Custom JS --->
<script>
$(document).ready(function() {
	$categoryForm = $( "##categoryForm" );
	$categoryEditor = $( "##categoryEditor" );
	$importDialog = $( "##importDialog" );
	// form validator
	$categoryEditor.validate();
	// reset
	$('##btnReset').click(function() {
		$categoryEditor.find( "##categoryID" ).val( '' );
	} );
	//
	$( "##categorySearch" ).keyup(
		_.debounce(
			function(){
				$.uiTableFilter( $( "##categories" ), this.value );
			},
			300
		)
	);
	// Data tables
	$('##categories').dataTable( {
		"paging" : false,
		"info" : false,
		"searching" : false,
		"columnDefs": [
    		{ 
    			"orderable": false, 
    			"targets": '{sorter:false}' 
    		}
  		],
  		"order": []
	} );
} );
<cfif prc.oAuthor.checkPermission( "CATEGORIES_ADMIN,TOOLS_IMPORT" )>
function bulkRemove(){
	$categoryForm.submit();
}
function edit(categoryID,category,slug){
	openModal( $( "##categoryEditorContainer" ) );
	$categoryEditor.find( "##categoryID" ).val( categoryID );
	$categoryEditor.find( "##category" ).val( category );
	$categoryEditor.find( "##slug" ).val( slug );
}
function removeCategory(categoryID){
	var $categoryForm = $( "##categoryForm" );
	$( "##delete_"+ categoryID).removeClass( "fa-trash-o" ).addClass( "fa-spin fa-spinner" );
	checkAll( false, 'categoryID' );
	$categoryForm.find( "##categoryID" ).val( categoryID );
	$categoryForm.submit();
}
function createCategory(){
	openModal( $( "##categoryEditorContainer" ), 500, 250 );
	$categoryEditor.find( "##categoryID" ).val( '' );
	$categoryEditor.find( "##category" ).val( '' );
	$categoryEditor.find( "##slug" ).val( '' );
	return false;
}
</cfif>
</script>
</cfoutput>