<cfoutput>
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
function selectCBPage(slug,title){
	var editor = $("###rc.editorName#").ckeditorGet();
	var link = editor.document.createElement( 'a' );
	link.setAttribute( 'href', 'page:['+slug+']');
	link.setAttribute( 'title', title );

	// get selected text
	var mySelection = editor.getSelection();
	var selectedText = "";
	if (CKEDITOR.env.ie) {
	    mySelection.unlock(true);
	    selectedText = mySelection.getNative().createRange().text;
	} else {
	    selectedText = mySelection.getNative();
	}
	// get selection or use default title
	if( selectedText != '' ){
		link.setHtml( selectedText );
	}
	else{
		link.setHtml( title );
	}
	editor.insertElement( link );
	closeRemoteModal();
	return false;
}

function pagerLink(page){
	$pageEditorSelectorLoader.fadeIn("fast");
	$('##remoteModelContent')
		.load('#event.buildLink(prc.xehEditorSelector)#?editorName=#rc.editorName#&page=' + page, function() {
			$pageEditorSelectorLoader.fadeOut();
	});
}
</script>
</cfoutput>