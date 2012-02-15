<cfoutput>
<!--- Shared Dynamic JS --->
#renderView(view="_tags/contentSelector",prePostExempt=true)#
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
</script>
</cfoutput>