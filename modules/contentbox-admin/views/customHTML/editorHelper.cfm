<cfoutput>
<script type="text/javascript">
$(document).ready(function() {
	$contentEditForm = $("##contentEditForm");
	// form validators
	$contentEditForm.validator({grouped:true,position:'top left'});
	// blur slugify
	var $title = $contentEditForm.find("##title");
	$title.blur(function(){
		createPermalink( $title.val() );
	});

	activateCustomEditor();
	// Editor dirty checks
	window.onbeforeunload = askLeaveConfirmation;
});
function getEditorSelectorURL(){ return '#event.buildLink(prc.xehWidgetSelector)#';}
function activateCustomEditor(){
	// toolbar config
	var ckToolbar =
	[
	    { name: 'document',    items : [ 'Source'] },
	    { name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','-','TextColor','BGColor'] },
	    { name: 'paragraph',   items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock' ] },
	    { name: 'links',       items : [ 'Link','Unlink','Anchor' ] },
	    { name: 'insert',      items : [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar' ] },
		{ name: 'tools',       items : [ 'Maximize','cbWidgets' ] }
	];
	// Activate ckeditor
	$contentEditForm.find("##content").ckeditor( function(){}, {
			toolbar:ckToolbar,
			height:250,
			filebrowserBrowseUrl : '/index.cfm/cbadmin/ckfilebrowser/',
			filebrowserImageBrowseUrl : '/index.cfm/cbadmin/ckfilebrowser/image/',
			filebrowserFlashBrowseUrl : '/index.cfm/cbadmin/ckfilebrowser/flash/',
			//filebrowserUploadUrl : '/index.cfm/filebrowser/'
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
	if ( $("##content").ckeditorGet().checkDirty() ){
   		return "You have unsaved changes.";
   	}
}
</script>
</cfoutput>