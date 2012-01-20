<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$settingEditor = $("##settingEditor");
	// table sorting + filtering
	$("##settings").tablesorter();
	$("##settingFilter").keyup(function(){
		$.uiTableFilter( $("##settings"), this.value );
	});
	// table sorting + filtering
	$("##singletons").tablesorter({ sortList: [[0,0]] });
	$("##singletonsFilter").keyup(function(){
		$.uiTableFilter( $("##singletons"), this.value );
	});
	// form validator
	$settingEditor.validator({position:'bottom left'});
	// reset
	$('##btnReset').click(function() {
		$settingEditor.find("##settingID").val( '' );
		$settingEditor.find("##btnSave").val( "Save" );
		$settingEditor.find("##btnReset").val( "Reset" );
	});
});
function edit(settingID,name,value){
	$settingEditor.find("##settingID").val( settingID );
	$settingEditor.find("##name").val( name );
	$settingEditor.find("##value").val( value );
	$settingEditor.find("##btnSave").val( "Update" );
	$settingEditor.find("##btnReset").val( "Cancel" );
}
function remove(settingID){
	var $settingForm = $("##settingForm");
	$settingForm.find("##settingID").val( settingID );
	$settingForm.submit();
}
</script>
</cfoutput>