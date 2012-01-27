<cfoutput>
#html.addAsset("#prc.cbRoot#/includes/editarea/edit_area_full.js")#
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
	$templateEditForm = $("##templateEditForm");	
	// load editable areas
	editAreaLoader.init({
		id : "templateCode",
		syntax: "coldfusion",
		start_highlight: true,
		allow_resize : true,
		allow_toggle : true,
		language: "en",
		toolbar: "search, go_to_line, fullscreen, |, undo, redo, |, select_font,|, syntax_selection,|, change_smooth_selection, highlight, reset_highlight, word_wrap, |, help"
	});
});
function saveTemplateCode(){
	var $uploader = $("##uploadBarLoader");
	var $status = $("##uploadBarLoaderStatus");
	// Activate Loader
	$status.html("Saving...");
	$uploader.slideToggle();
	// Post it
	$.post('#event.buildLink(prc.xehTemplateSave)#',{template:'#rc.encodedTemplate#',templateCode:editAreaLoader.getValue('templateCode')},function(data){
		$uploader.fadeOut(1500);
		$status.html('Code Saved!');
	});
	return false;
}
</script>
</cfoutput>