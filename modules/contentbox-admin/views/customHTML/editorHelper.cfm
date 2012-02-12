<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	$contentEditForm = $("##contentEditForm");
	// form validators
	$contentEditForm.validator({grouped:true,position:'top left',onSuccess:function(e,els){ needConfirmation = false; }});
	// blur slugify
	var $title = $contentEditForm.find("##title");
	$title.blur(function(){
		createPermalink( $title.val() );
	});

	activateCustomEditor();
	// Editor dirty checks
	window.onbeforeunload = askLeaveConfirmation;
	needConfirmation = true;
});
// Widget Plugin Integration
function getWidgetSelectorURL(){ return '#event.buildLink(prc.cbAdminEntryPoint & ".widgets.editorselector")#';}
// Page Selection Integration
function getPageSelectorURL(){ return '#event.buildLink(prc.cbAdminEntryPoint & ".pages.editorselector")#';}
// Entry Selection Integration
function getEntrySelectorURL(){ return '#event.buildLink(prc.cbAdminEntryPoint & ".entries.editorselector")#';}
// activate custom editor
function activateCustomEditor(){
	// toolbar config
	var ckToolbar =
	[
	    { name: 'document',    items : [ 'Source'] },
	    { name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','-','TextColor','BGColor'] },
	    { name: 'paragraph',   items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock' ] },
	    { name: 'links',       items : [ 'Link','Unlink','Anchor' ] },
	    { name: 'insert',      items : [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar' ] },
		{ name: 'tools',       items : [ 'Maximize','ShowBlocks','-','cbWidgets','cbLinks','cbEntryLinks' ] }
	];
	// Activate ckeditor
	$contentEditForm.find("##content").ckeditor( function(){}, {
			toolbar:ckToolbar,
			height:250,
			filebrowserBrowseUrl : '#event.buildLink(prc.xehCKFileBrowserURL)#',
			filebrowserImageBrowseUrl : '#event.buildLink(prc.xehCKFileBrowserURLIMage)#',
			filebrowserFlashBrowseUrl : '#event.buildLink(prc.xehCKFileBrowserURLFlash)#'
		} );
}
function createPermalink(){
	var slugger = '#event.buildLink(prc.xehSlugify)#';
	$slug = $contentEditForm.find("##slug").fadeOut();
	$.get(slugger,{slug:$contentEditForm.find("##title").val()},function(data){
		$slug.fadeIn().val($.trim(data));
	} );
}
function askLeaveConfirmation(){
	if ( $("##content").ckeditorGet().checkDirty() && needConfirmation){
   		return "You have unsaved changes.";
   	}
}
</script>
</cfoutput>