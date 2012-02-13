<cfoutput>
<!--- Render Commong editor functions --->
#renderView(view="_tags/editors",prePostExempt=true)#
<script type="text/javascript">
$(document).ready(function() {
 	// pointers
	$contentEditForm = $("##contentEditForm");
	$content 		 = $contentEditForm.find("##content");
	// setup editors
	setupEditors( $contentEditForm, false);
});
</script>
</cfoutput>