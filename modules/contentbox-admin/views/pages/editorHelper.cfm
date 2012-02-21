<cfoutput>
<!--- Load Assets --->
#html.addAsset(prc.cbroot&"/includes/css/date.css")#
<!--- Render Commong editor functions --->
#renderView(view="_tags/editors",prePostExempt=true)#
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
 	// Shared Pointers
	$pageForm 		= $("##pageForm");
	$excerpt		= $pageForm.find("##excerpt");
	$content 		= $pageForm.find("##content");
	$isPublished 	= $pageForm.find("##isPublished");
	$contentID		= $pageForm.find("##contentID");
	// setup editors
	setupEditors( $pageForm );
});
function quickSave(){
	// Draft it
	$isPublished.val('false');
	
	// Validation first
	if( !$pageForm.data("validator").checkValidity() ){
		return false;
	}
	
	// Activate Loader
	var $uploader = $("##uploadBarLoader");
	var $status = $("##uploadBarLoaderStatus");
	$status.html("Saving...");
	$uploader.slideToggle();
		
	// Post it
	$.post('#event.buildLink(prc.xehPageSave)#', $pageForm.serialize(),function(data){
		// Save new id
		$contentID.val( data.CONTENTID );
		// finalize
		$uploader.fadeOut(1500);
		$status.html('Page Draft Saved!');
		$isPublished.val('true');
	},"json");
	
	return false;
}
</script>
</cfoutput>