<cfoutput>
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
 	// Shared Pointers
	$entryEditorSelectorForm 	= $("##entryEditorSelectorForm");
	$entryEditorSelectorLoader 	= $entryEditorSelectorForm.find("##entryLoader");
	// Filtering
	$entryEditorSelectorForm.find("##entryFilter").keyup(function(){
		$.uiTableFilter( $("##entries"), this.value );
	});
});
function pagerLink(page){
	$entryEditorSelectorLoader.fadeIn("fast");
	$('##remoteModelContent')
		.load('#event.buildLink(prc.xehEditorSelector)#?editorName=#rc.editorName#&page=' + page, function() {
			$entryEditorSelectorLoader.fadeOut();
	});
}
function insertCustomHTML(customHTML){
	var customContent = "{{{CustomHTML slug='"+customHTML+"'}}}";
	$("###rc.editorName#").ckeditorGet().insertText( customContent );
	closeRemoteModal();
	return false;
}
</script>
</cfoutput>