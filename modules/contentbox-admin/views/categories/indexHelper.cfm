﻿<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$categoryEditor = $("##categoryEditor");
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
<cfif prc.oAuthor.checkPermission("CATEGORIES_ADMIN")>
function edit(categoryID,category,slug){
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
</cfif>
</script>
</cfoutput>