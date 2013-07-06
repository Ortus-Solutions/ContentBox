<cfoutput>
<!--- Render Commong editor functions --->
#renderView(view="_tags/editors",prePostExempt=true)#
<script type="text/javascript">
$(document).ready(function() {
 	// pointers
	$contentEditForm = $("##contentEditForm");
	// setup editors
	setupEditors( $contentEditForm, false, '#event.buildLink(prc.xehContentSave)#' );
});
</script>
</cfoutput>