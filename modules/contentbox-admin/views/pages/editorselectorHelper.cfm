<cfoutput>
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
 	// Shared Pointers
	$pageEditorSelectorForm 	= $("##pageEditorSelectorForm");
	$pageEditorSelectorLoader 	= $pageEditorSelectorForm.find("##pageLoader");
	// Filtering
	$pageEditorSelectorForm.find("##pageFilter").keyup(function(){
		$.uiTableFilter( $("##pages"), this.value );
	});
});
function selectCBWidget(widget){
	var argDiv = $("##widgetArgs_"+widget).slideToggle();
	// check if we have arguments, else just insert
	if( !argDiv.html().length ){
		sendEditorText("{{{"+widget+"}}}");
	}
	// apply form validator
	$("##widgetArgsForm_"+widget).validator({position:'center right'});
}
function insertCBWidget(widget){
	var $widgetForm = $("##widgetArgsForm_"+widget);
	
	if( !$widgetForm.data("validator").checkValidity() ){
		return;
	}
	
	var args = $("##widgetArgsForm_"+widget).serializeArray();
	var widgetContent = "{{{"+widget;
	for(var i in args){
		if( args[i].value.length ){
			widgetContent += " "+args[i].name+"='"+args[i].value+"'"
		}
	}
	widgetContent+="}}}";
	sendEditorText( widgetContent );	
}
function sendEditorText(text){
	$("###rc.editorName#").ckeditorGet().insertText( text );
	closeRemoteModal();
}
function pagerLink(page){
	$pageEditorSelectorLoader.fadeIn("fast");
	$('##remoteModelContent')
		.load('#event.buildLink(prc.xehEditorSelector)#?editorName=#rc.editorName#&page=' + page, function() {
			$pageEditorSelectorLoader.fadeOut();
	});
}
</script>
</cfoutput>