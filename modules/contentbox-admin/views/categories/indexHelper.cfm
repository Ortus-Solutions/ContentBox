<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$categoryEditor = $("##categoryEditor");
	$importDialog = $("##importDialog");
	// table sorting + filtering
	$("##categories").tablesorter();
	$("##categoryFilter").keyup(function(){
		$.uiTableFilter( $("##categories"), this.value );
	});
	// form validator
	$categoryEditor.validate();
	// reset
	$('##btnReset').click(function() {
		$categoryEditor.find("##categoryID").val( '' );
	});
});
<cfif prc.oAuthor.checkPermission("CATEGORIES_ADMIN,TOOLS_IMPORT")>
function importContent(){
	// local id's
	var $importForm = $("##importForm");
	// open modal for cloning options
	openModal( $importDialog, 500, 350 );
	// form validator and data
	$importForm.validate({ 
		submitHandler: function(form){
           	$importForm.find("##importButtonBar").slideUp();
			$importForm.find("##importBarLoader").slideDown();
			form.submit();
        }
	});
	// close button
	$importForm.find("##closeButton").click(function(e){
		closeModal( $importDialog ); return false;
	});
	// clone button
	$importForm.find("##importButton").click(function(e){
		$importForm.submit();
	});
}
function edit(categoryID,category,slug){
	openModal( $("##categoryEditorContainer"), 500, 200 );
	$categoryEditor.find("##categoryID").val( categoryID );
	$categoryEditor.find("##category").val( category );
	$categoryEditor.find("##slug").val( slug );
}
function remove(categoryID){
	var $categoryForm = $("##categoryForm");
	$("##delete_"+ categoryID).removeClass( "icon-remove-sign" ).addClass( "icon-spinner icon-spin" );
	$categoryForm.find("##categoryID").val( categoryID );
	$categoryForm.submit();
}
function createCategory(){
	openModal( $("##categoryEditorContainer"), 500, 200 );
	$categoryEditor.find("##categoryID").val( '' );
	$categoryEditor.find("##category").val( '' );
	$categoryEditor.find("##slug").val( '' );
	return false;
}
</cfif>
</script>
</cfoutput>