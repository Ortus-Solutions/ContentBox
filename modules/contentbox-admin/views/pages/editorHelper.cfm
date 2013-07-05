<cfoutput>
<!--- Load Editor Custom Assets --->
#html.addAsset(prc.cbroot & "/includes/css/date.css")#
<!--- Render Commong editor functions --->
#renderView(view="_tags/editors", prePostExempt=true)#
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
 	// Editor Pointers
	$pageForm 		= $("##pageForm");
	// setup editors via _tags/editors.cfm by passing the form container
	setupEditors( $pageForm, #prc.cbSettings.cb_page_excerpts#, '#event.buildLink( prc.xehPageSave )#' );
});
</script>
</cfoutput>