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
	$excerpt		= $pageForm.find("##excerpt");
	$content 		= $pageForm.find("##content");
	$isPublished 	= $pageForm.find("##isPublished");
	$contentID		= $pageForm.find("##contentID");
	$contentType	= "#prc.page.getContentType()#";
	// setup editors via _tags/editors.cfm by passing the form container
	setupEditors( $pageForm, false );
});
// quick save for pages
function quickSave(){
	// Draft it
	$isPublished.val('false');

	// Validation first
	if( !$pageForm.data("validator").checkValidity() ){
		return false;
	}

	// Activate Loader
	toggleLoaderBar();

	// Post it
	$.post('#event.buildLink(prc.xehPageSave)#', $pageForm.serialize(),function(data){
		// Save new id
		$contentID.val( data.CONTENTID );
		// finalize
		$uploaderBarLoader.fadeOut(1500);
		$uploaderBarStatus.html('Page Draft Saved!');
		$isPublished.val('true');
	},"json");

	return false;
}
</script>
</cfoutput>