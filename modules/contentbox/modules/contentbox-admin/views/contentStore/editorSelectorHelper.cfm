<cfoutput>
<!--- Custom Javascript --->
<script>
$( document ).ready(function() {
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
} );

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
function clearSearch(){
	$( '##contentSearch' ).val( '' );
	loadContent( '' );
}
function pagerLink(page){
	$( "##contentLoader" ).fadeIn( "fast" );
	$('##modal')
		.load(
			'#event.buildLink( prc.xehEditorSelector )#?editorName=#rc.editorName#&page=' + page,
			function() {
				$( "##contentLoader" ).fadeOut();
			}
		);
}
function insertContent( slug ){
	var customContent = "{{{ContentStore slug='" + slug + "'}}}";
	insertEditorContent( '#rc.editorName#', customContent );
	closeRemoteModal();
	return false;
}
</script>
</cfoutput>