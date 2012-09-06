<cfoutput>
<!--- Load Assets --->
#html.addAsset(prc.cbroot&"/includes/css/date.css")#
<!--- Render Commong editor functions --->
#renderView(view="_tags/editors",prePostExempt=true)#
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
 	// Editor Pointers
	$entryForm 		= $("##entryForm");
	$excerpt		= $entryForm.find("##excerpt");
	$content 		= $entryForm.find("##content");
	$isPublished 	= $entryForm.find("##isPublished");
	$contentID		= $entryForm.find("##contentID");
	// setup editors
	setupEditors( $entryForm );
});
// quick save for blog entries
function quickSave(){
	// Draft it
	$isPublished.val('false');

	// Validation first
	if( !$entryForm.data("validator").checkValidity() ){
		return false;
	}
	if( !$content.val().length ){
		alert("Please enter some content");
		return false;
	}

	// Activate Loader
	toggleLoaderBar();
	
	// Post it
	$.post('#event.buildLink(prc.xehEntrySave)#', $entryForm.serialize(),function(data){
		// Save newly saved or persisted id
		$contentID.val( data.CONTENTID );
		// finalize
		$uploaderBarLoader.fadeOut(1500);
		$uploaderBarStatus.html('Entry Draft Saved!');
		$isPublished.val('true');
	},"json");

	return false;
}
</script>
</cfoutput>