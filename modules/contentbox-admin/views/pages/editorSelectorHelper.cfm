<cfoutput>
<!--- Shared Dynamic JS --->
#renderView(view="_tags/contentSelector",prePostExempt=true)#
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
 	// Shared Pointers
	$pageEditorSelectorForm 	= $( "##pageEditorSelectorForm" );
	$pageEditorSelectorLoader 	= $pageEditorSelectorForm.find( "##pageLoader" );
	// Search
	// keyup quick search
	$( "##pageSearch" ).keyup(function(){
		var $this = $(this);
		var clearIt = ( $this.val().length > 0 ? false : true );
		// ajax search
		$('##pagesContainer').load( '#event.buildLink( prc.xehEditorSelector )#', 
			{ search: $this.val(), editorName : "#rc.editorName#", clear: clearIt }, 
			function(){
				$pageEditorSelectorLoader.fadeOut();
		} );
		
	} );
	<cfif len( rc.search )>
	$( "##pageSearch" ).focus();
	</cfif>
} );
function pagerLink(page){
	$pageEditorSelectorLoader.fadeIn( "fast" );
	$('##modal')
		.load('#event.buildLink(prc.xehEditorSelector)#?search=#rc.search#&editorName=#rc.editorName#&page=' + page, function() {
			$pageEditorSelectorLoader.fadeOut();
	} );
}
</script>
</cfoutput>
