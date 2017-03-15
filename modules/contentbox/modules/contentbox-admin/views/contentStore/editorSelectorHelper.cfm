<cfoutput>
<!--- Shared Dynamic JS --->
#renderView(view="_tags/contentSelector",prePostExempt=true)#
<!--- Custom Javascript --->
<script>
$(document).ready(function() {
 	// Shared Pointers
	$editorSelectorForm 		= $( "##contentStoreEditorSelectorForm" );
	$editorSelectorLoader 	= $editorSelectorForm.find( "##contentStoreLoader" );
	// keyup quick search
	$( "##contentSearch" ).keyup(
		_.debounce(
            function(){
                var $this = $(this);
				var clearIt = ( $this.val().length > 0 ? false : true );
				// ajax search
				$('##contentContainer').load( '#event.buildLink( prc.xehEditorSelector )#', 
					{ search: $this.val(), editorName : "#rc.editorName#", clear: clearIt }, 
					function(){
						$editorSelectorLoader.fadeOut();
				} );
            },
            300
        )
	);
	<cfif len( rc.search )>
	$( "##contentSearch" ).focus();
	</cfif>
} );
function pagerLink(page){
	$editorSelectorLoader.fadeIn( "fast" );
	$('##modal')
		.load('#event.buildLink(prc.xehEditorSelector)#?editorName=#rc.editorName#&page=' + page, function() {
			$editorSelectorLoader.fadeOut();
	} );
}
function insertContentStore(slug){
	var customContent = "{{{ContentStore slug='"+slug+"'}}}";
	insertEditorContent( '#rc.editorName#', customContent );
	closeRemoteModal();
	return false;
}
</script>
</cfoutput>