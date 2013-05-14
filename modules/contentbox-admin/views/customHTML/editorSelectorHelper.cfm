<cfoutput>
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
 	// Shared Pointers
	$entryEditorSelectorForm 	= $("##entryEditorSelectorForm");
	$entryEditorSelectorLoader 	= $entryEditorSelectorForm.find("##entryLoader");
	// keyup quick search
	$("##entrySearch").keyup(function(){
		var $this = $(this);
		var clearIt = ( $this.val().length > 0 ? false : true );
		// ajax search
		$('##entriesContainer').load( '#event.buildLink( prc.xehEditorSelector )#', 
			{ search: $this.val(), editorName : "#rc.editorName#", clear: clearIt }, 
			function(){
				$pageEditorSelectorLoader.fadeOut();
		});
		
	});
	<cfif len( rc.search )>
	$("##entrySearch").focus();
	</cfif>
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