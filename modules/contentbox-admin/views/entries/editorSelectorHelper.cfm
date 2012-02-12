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
function selectCBEntry(slug,title){
	var editor = $("###rc.editorName#").ckeditorGet();
	var link = editor.document.createElement( 'a' );
	link.setAttribute( 'href', 'entry:['+slug+']');
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
		if (mySelection.getSelectedElement() != null) {
			link.setHtml( mySelection.getSelectedElement().getOuterHtml() );
		}
		else{
			link.setHtml( title );
		}
	}
	editor.insertElement( link );
	closeRemoteModal();
}

function pagerLink(page){
	$entryEditorSelectorLoader.fadeIn("fast");
	$('##remoteModelContent')
		.load('#event.buildLink(prc.xehEditorSelector)#?editorName=#rc.editorName#&page=' + page, function() {
			$entryEditorSelectorLoader.fadeOut();
	});
}
</script>
</cfoutput>