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
	    { name: 'tools',       items : [ 'Maximize','cbWidgets' ] }
	];
	// Activate ckeditor
	$content.ckeditor( function(){}, { 
			toolbar:ckToolbar,height:300, 
			filebrowserBrowseUrl : '/index.cfm/cbadmin/ckfilebrowser/',
			filebrowserImageBrowseUrl : '/index.cfm/cbadmin/ckfilebrowser/image/',
			filebrowserFlashBrowseUrl : '/index.cfm/cbadmin/ckfilebrowser/flash/',
			//filebrowserUploadUrl : '/index.cfm/filebrowser/' 
		} );
	$excerpt.ckeditor( function(){}, { toolbar:'Basic',height:175 } );
	// Date fields
	$(":date").dateinput();
	// form validator
	$entryForm.validator({position:'top right',grouped:true});
	// blur slugify
	var $title = $entryForm.find("#title");
	$title.blur(function(){ 
		if( $("#slug").size() ){
			createPermalink( $title.val() );
		}
	});
	// Editor dirty checks
	window.onbeforeunload = askLeaveConfirmation;
});
function askLeaveConfirmation(){
	if ( $("#content").ckeditorGet().checkDirty() ){
   		return "You have unsaved changes.";
   	}    
}
function createPermalink(){
	var slugger = $("#sluggerURL").val();
	$slug = $("#slug").fadeOut();
	$.get(slugger,{slug:$("#title").val()},function(data){ 
		$slug.fadeIn().val($.trim(data)); 		
	} );
}
function toggleDraft(){
	$("#isPublished").val('false');
}
function quickSave(){
	// Draft it
	$("#isPublished").val('false');
	
	// Validation first
	if( !$entryForm.data("validator").checkValidity() ){
		return false;
	}
	if( !$entryForm.find("#content").val().length ){
		alert("Please enter some content");
		return false;
	}
	
	// Activate Loader
	var $uploader = $("#uploadBarLoader");
	var $status = $("#uploadBarLoaderStatus");
	$status.html("Saving...");
	$uploader.slideToggle();
	
	// Post it
	$.post(getEditorSaveURL(), $entryForm.serialize(),function(data){
		// Save new id
		$entryForm.find("#entryID").val( data.ENTRYID );
		// finalize
		$uploader.fadeOut(1500);
		$status.html('Entry Draft Saved!');
		$("#isPublished").val('true');
	},"json");
	
	return false;
}