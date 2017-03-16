<cfoutput>
<script>
function selectCBContent(slug,title,type){

	// NO CKEditor
	if( typeof( CKEDITOR ) == 'undefined' ){
		var link = "[" + title + "](" + type + ":[" + slug + "])";
		insertEditorContent( '#rc.editorName#', link );
		closeRemoteModal();
		return false;
	}

	// CKEDITOR Specific 
	var editor = $( "###rc.editorName#" ).ckeditorGet();
	var link = editor.document.createElement( 'a' );
	link.setAttribute( 'href', type+':['+slug+']');
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
	
	return false;
}
</script>	
</cfoutput>