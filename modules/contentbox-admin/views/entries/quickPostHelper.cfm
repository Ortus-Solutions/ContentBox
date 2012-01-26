﻿<cfoutput>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
 	// pointers
	$quickPost 			= $("##quickPost");
	$quickPostForm 		= $("##quickPostForm");
	$quickEntryContent 	= $quickPostForm.find("##quickcontent");
	// toolbar config
	var ckToolbar =
	[
	    { name: 'document',    items : [ 'Source'] },
	    { name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','-','TextColor','BGColor'] },
	    { name: 'paragraph',   items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock' ] },
	    { name: 'links',       items : [ 'Link','Unlink','Anchor' ] },
	    { name: 'insert',      items : [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar' ] }
	];
	// Activate ckeditor
	$quickEntryContent.ckeditor( function(){}, {
			toolbar:ckToolbar,
			height:180,
			filebrowserBrowseUrl : '/index.cfm/cbadmin/ckfilebrowser/',
			filebrowserImageBrowseUrl : '/index.cfm/cbadmin/ckfilebrowser/image/',
			filebrowserFlashBrowseUrl : '/index.cfm/cbadmin/ckfilebrowser/flash/',
			//filebrowserUploadUrl : '/index.cfm/filebrowser/'
		} );
	// form validator
	$quickPostForm.validator({position:'top left'});
});
function qpSaveDraft(){
	$quickPostForm.find("##isPublished").val('false');
}
function showQuickPost(){
	$quickPost.overlay({
			mask: {
			color: '##fff',
			loadSpeed: 200,
			opacity: 0.6
		},
		closeOnClick : false,
		onClose: function(){ closeQuickPost(); }
	});
	// load it
	$quickPost.data("overlay").load();
}
function closeQuickPost(){
	$quickPost.data("overlay").close();
	$(".error").hide();
	return false;
}
</script>
</cfoutput>