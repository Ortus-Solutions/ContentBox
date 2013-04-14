<cfoutput>
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
	    { name: 'insert',      items : [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar', 'MediaEmbed', 'InsertPre' ] }
	];
	// Activate ckeditor
	$quickEntryContent.ckeditor( function(){}, {
			toolbar:ckToolbar,
			height:180,
			filebrowserBrowseUrl : '#event.buildLink(prc.xehCKFileBrowserURL)#',
			filebrowserImageBrowseUrl : '#event.buildLink(prc.xehCKFileBrowserURLIMage)#',
			filebrowserFlashBrowseUrl : '#event.buildLink(prc.xehCKFileBrowserURLFlash)#'
		} );
	// form validator
	$quickPostForm.validator({position:'top left'});
});
function qpSaveDraft(){
	$quickPostForm.find("##isPublished").val('false');
}
function showQuickPost(){
    $( '##quickPostModal' ).modal({
        maxHeight: 800,
        height: '80%',
        width: 1000
    });
}
function closeQuickPost(){
    $(".error").hide();
    $( '##quickPostModal' ).modal( 'hide' );
    return false;
}
</script>
</cfoutput>