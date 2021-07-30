<cfoutput>
<!--- Custom Javascript --->
<script>
( () => {
	// keyup quick search
	$( "##contentSearch" ).keyup(
		_.debounce(
            function(){
				loadContent( $( this ).val() );
            },
            300
        )
	);
	<cfif len( rc.search )>
		$( "##contentSearch" ).focus();
	</cfif>
} )();

function clearSearch(){
	$( '##contentSearch' ).val( '' );
	loadContent( '' );
}

function loadContent( search ){
	$( "##contentLoader" ).fadeIn();
	$( "##contentContainer" )
		.load(
			'#event.buildLink( prc.xehEditorSelector )#',
			{
				search 		: search,
				editorName 	: "#rc.editorName#",
				clear 		: search.length > 0 ? false : true
			},
			function(){
				$( "##contentLoader" ).fadeOut();
			}
	);
}

function pagerLink( page ){
	$( "##contentLoader" ).fadeIn( "fast" );
	$('##modal')
		.load(
			'#event.buildLink( prc.xehEditorSelector )#?editorName=#rc.editorName#&page=' + page,
			function() {
				$( "##contentLoader" ).fadeOut();
			}
		);
}

function selectCBContent( slug, title, type ){
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
	link.setAttribute( 'href', type +':[' + slug + ']');
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
