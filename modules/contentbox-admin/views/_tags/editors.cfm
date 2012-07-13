<cfoutput>
<cfsavecontent variable="toolbarJSON">
[
    { "name": "document",    "items" : [ "Source","-","Maximize","ShowBlocks" ] },
    { "name": "clipboard",   "items" : [ "Cut","Copy","Paste","PasteText","PasteFromWord","-","Undo","Redo" ] },
    { "name": "editing",     "items" : [ "Find","Replace","-","SpellChecker", "Scayt" ] },
    { "name": "forms",       "items" : [ "Form", "Checkbox", "Radio", "TextField", "Textarea", "Select", "Button","HiddenField" ] },
    "/",
	{ "name": "basicstyles", "items" : [ "Bold","Italic","Underline","Strike","Subscript","Superscript","-","RemoveFormat" ] },
    { "name": "paragraph",   "items" : [ "NumberedList","BulletedList","-","Outdent","Indent","-","Blockquote","CreateDiv","-","JustifyLeft","JustifyCenter","JustifyRight","JustifyBlock","-","BidiLtr","BidiRtl" ] },
    { "name": "links",       "items" : [ "Link","Unlink","Anchor" ] },
    "/",
    { "name": "styles",      "items" : [ "Styles","Format" ] },
    { "name": "colors",      "items" : [ "TextColor","BGColor" ] },
	{ "name": "insert",      "items" : [ "Image","Flash","Table","HorizontalRule","Smiley","SpecialChar" ] },
    { "name": "contentbox",  "items" : [ "cbIpsumLorem","cbWidgets","cbCustomHTML","cbLinks","cbEntryLinks", "cbPreview" ] }
]</cfsavecontent>
<cfset iData = { toolbar = deserializeJSON( toolbarJSON ) }>
<cfset announceInterception("cbadmin_ckeditorToolbar", iData)>
<!---Extra Plugins --->
<cfset iData2 = { extraPlugins = listToArray( "cbWidgets,cbLinks,cbEntryLinks,cbCustomHTML,cbPreview,cbIpsumLorem" ) }>
<cfset announceInterception("cbadmin_ckeditorExtraPlugins", iData2)>

<!--- Custom Javascript --->
<script type="text/javascript">
// Setup the Editors
function setupEditors($theForm, withExcerpt){
	// with excerpt
	if( withExcerpt == null ){ withExcerpt = true; }
	// toolbar config
	var ckToolbar = $.parseJSON('#serializeJSON( iData.toolbar )#');
	// Activate ckeditor
	$content.ckeditor( function(){}, {
			<cfif arrayLen( iData2.extraPlugins )>
			extraPlugins : '#arrayToList( iData2.extraPlugins )#',
			</cfif>
			toolbar: ckToolbar,
			height:300,
			filebrowserBrowseUrl : '#event.buildLink(prc.xehCKFileBrowserURL)#',
			filebrowserImageBrowseUrl : '#event.buildLink(prc.xehCKFileBrowserURLIMage)#',
			filebrowserFlashBrowseUrl : '#event.buildLink(prc.xehCKFileBrowserURLFlash)#',
			baseHref : '#getSetting("htmlBaseURL")#/'
		} );
	// Excerpts
	if (withExcerpt) {
		$excerpt.ckeditor(function(){}, {
			toolbar: 'Basic',
			height: 175,
			filebrowserBrowseUrl: '/index.cfm/cbadmin/ckfilebrowser/',
			baseHref: '#getSetting("htmlBaseURL")#/'
		});
	}

	// Date fields
	$(":date").dateinput();

	// form validator
	$theForm.validator({position:'top left',grouped:true,onSuccess:function(e,els){ needConfirmation=false; }});
	// Custom content unique validator
	$.tools.validator.fn($content, function(el, value) {
		if( value.length ){ return true; }
		alert("Please enter some content!");
		return false;
	});
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
function getWidgetSelectorURL(){ return '#event.buildLink(prc.cbAdminEntryPoint & ".widgets.editorselector")#';}
// Page Selection Integration
function getPageSelectorURL(){ return '#event.buildLink(prc.cbAdminEntryPoint & ".pages.editorselector")#';}
// Entry Selection Integration
function getEntrySelectorURL(){ return '#event.buildLink(prc.cbAdminEntryPoint & ".entries.editorselector")#';}
// Custom HTML Selection Integration
function getCustomHTMLSelectorURL(){ return '#event.buildLink(prc.cbAdminEntryPoint & ".customHTML.editorselector")#';}
// Preview Integration
function getPreviewSelectorURL(){ return '#event.buildLink(prc.cbAdminEntryPoint & ".content.preview")#';}
// Module Link Building
function getModuleURL(module, event, queryString){
	var returnURL = "";
	$.ajax({
		url : '#event.buildLink(prc.cbAdminEntryPoint & ".modules.buildModuleLink")#',
		data : {module: module, moduleEvent: event, moduleQS: queryString},
		async : false,
		success : function(data){
			returnURL = data;
		}
	});
	return $.trim( returnURL );
}
</script>
</cfoutput>