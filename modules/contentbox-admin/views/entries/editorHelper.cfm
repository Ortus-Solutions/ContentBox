<cfoutput>
<!--- Load Assets --->
#html.addAsset(prc.cbroot&"/includes/ckeditor/ckeditor.js")#
#html.addAsset(prc.cbroot&"/includes/ckeditor/adapters/jquery.js")#
#html.addAsset(prc.cbroot&"/includes/js/contentbox.editor.js")#
#html.addAsset(prc.cbroot&"/includes/css/date.css")#
<!--- Custom Javascript --->
<script type="text/javascript">
function getEditorSelectorURL(){ return '#event.buildLink(prc.xehWidgetSelector)#';}
function getEditorSaveURL(){ return '#event.buildLink(prc.xehEntrySave)#'; }
</script>
</cfoutput>