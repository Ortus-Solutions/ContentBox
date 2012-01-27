<cfoutput>
<!--- Load Assets --->
#html.addAsset(prc.cbroot&"/includes/ckeditor/ckeditor.js")#
#html.addAsset(prc.cbroot&"/includes/ckeditor/adapters/jquery.js")#
#html.addAsset(prc.cbroot&"/includes/css/date.css")#
<!--- Custom Javascript --->
<script type="text/javascript">
// Setup the Editors
function setupEditors($theForm){
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
			filebrowserBrowseUrl : '#event.buildLink(prc.xehCKFileBrowserURL)#',
			filebrowserImageBrowseUrl : '#event.buildLink(prc.xehCKFileBrowserURLIMage)#',
			filebrowserFlashBrowseUrl : '#event.buildLink(prc.xehCKFileBrowserURLFlash)#'
		} );
	$excerpt.ckeditor( function(){}, { toolbar:'Basic',height:175,filebrowserBrowseUrl : '/index.cfm/cbadmin/ckfilebrowser/' } );
	
	// Date fields
	$(":date").dateinput();
	
	// form validator
	$theForm.validator({position:'top right',grouped:true,onSuccess:function(e,els){ needConfirmation=false; }});
	
	// blur slugify
	var $title = $theForm.find("##title");
	$title.blur(function(){ 
		if( $theForm.find("##slug").size() ){
			createPermalink( $title.val() );
		}
	});
	// Editor dirty checks
	window.onbeforeunload = askLeaveConfirmation;
	needConfirmation = true;
}
// Ask for leave confirmations
function askLeaveConfirmation(){
	if ( $content.ckeditorGet().checkDirty() && needConfirmation ){
   		return "You have unsaved changes.";
   	}    
}
// Create Permalinks
function createPermalink(){
	var slugger = $("##sluggerURL").val();
	$slug = $("##slug").fadeOut();
	$.get(slugger,{slug:$("##title").val()},function(data){ 
		$slug.fadeIn().val($.trim(data)); 		
	} );
}
// Toggle drafts on for saving
function toggleDraft(){
	needConfirmation = false;
	$isPublished.val('false');
}
// Widget Plugin Integration
function getEditorSelectorURL(){ return '#event.buildLink(prc.xehWidgetSelector)#';}
</script>
</cfoutput>