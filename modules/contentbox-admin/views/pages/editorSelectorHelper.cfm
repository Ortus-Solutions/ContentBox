<cfoutput>
<!--- Shared Dynamic JS --->
#renderView(view="_tags/contentSelector",prePostExempt=true)#
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
 	// Shared Pointers
	$pageEditorSelectorForm 	= $("##pageEditorSelectorForm");
	$pageEditorSelectorLoader 	= $pageEditorSelectorForm.find("##pageLoader");
	// Filtering
	$pageEditorSelectorForm.find("##pageFilter").keyup(function(){
		$.uiTableFilter( $("##pages"), this.value );
	});
});
function pagerLink(page){
	$pageEditorSelectorLoader.fadeIn("fast");
	$('##remoteModelContent')
		.load('#event.buildLink(prc.xehEditorSelector)#?editorName=#rc.editorName#&page=' + page, function() {
			$pageEditorSelectorLoader.fadeOut();
	});
}
</script>
</cfoutput>