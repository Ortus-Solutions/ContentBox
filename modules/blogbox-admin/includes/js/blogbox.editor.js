$(document).ready(function() {
 	// pointers
	$content 	= $("#content");
	$excerpt	= $("#excerpt");
	$entryForm 	= $("#entryForm");
	// toolbar config
	var ckToolbar =
	[
	    { name: 'document',    items : [ 'Source','-','Templates' ] },
	    { name: 'clipboard',   items : [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ] },
	    { name: 'editing',     items : [ 'Find','Replace','-','SpellChecker', 'Scayt' ] },
	    //{ name: 'forms',       items : [ 'Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField' ] },
	   	{ name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
	     '/',
		{ name: 'paragraph',   items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl' ] },
	    { name: 'links',       items : [ 'Link','Unlink','Anchor' ] },
	    { name: 'insert',      items : [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar' ] },
	    '/',
	    { name: 'styles',      items : [ 'Styles','Format','Font','FontSize' ] },
	    { name: 'colors',      items : [ 'TextColor','BGColor' ] },
	    { name: 'tools',       items : [ 'Maximize' ] }
	];
	// Activate ckeditor
	$content.ckeditor( function(){}, { toolbar:ckToolbar,height:300 } );
	$excerpt.ckeditor( function(){}, { toolbar:'Basic',height:175 } );
	// Date fields
	$(":date").dateinput();
	// form validator
	$entryForm.validator({position:'center top'});
});
/**
 * Create permalink from title field
 * @param slugger
 */
function createPermalink(slugger){
	$slug = $("#slug").fadeOut();
	$.get(slugger,{slug:$("#title").val()},function(data){ 
		$slug.fadeIn().val($.trim(data)); 		
	} );
}
function toggleDraft(){
	$("#isPublished").val('false');
}