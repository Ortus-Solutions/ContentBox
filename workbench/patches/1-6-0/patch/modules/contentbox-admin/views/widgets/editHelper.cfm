<cfoutput>
#html.addAsset("#prc.cbRoot#/includes/editarea/edit_area_full.js")#
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
	$widgetEditorForm = $("##widgetEditForm");	
	// load editable areas
	editAreaLoader.init({
		id : "widgetCode",
		syntax: "coldfusion",
		start_highlight: true,
		allow_resize : true,
		allow_toggle : true,
		language: "en",
		toolbar: "search, go_to_line, fullscreen, |, undo, redo, |, select_font,|, syntax_selection,|, change_smooth_selection, highlight, reset_highlight, word_wrap, |, help"
	});
});
function getWidgetPreviewURL(){ return '#event.buildLink( prc.cbAdminEntryPoint & ".widgets.preview" )#'; }
function getWidgetInstanceURL(){ return '#event.buildLink( prc.cbAdminEntryPoint & ".widgets.viewWidgetInstance" )#'; }
function testWidgetCode(){
	$widgetEditorForm = $("##widgetEditForm");
	var attributes = {
		modal: true,
		mode: 'Test',
		widgetName: '#prc.widget.name#',
		widgetType: '#prc.widget.widgetType#',
		widgetUDF: '#prc.widget.udf#'
	};
    openRemoteModal( '#event.buildLink( prc.xehWidgetTest )#', attributes, 1000, 650 );
	return false;
}
function saveWidgetCode(){
	var $uploader = $("##uploadBarLoader");
	var $status = $("##uploadBarLoaderStatus");
	// Activate Loader
	$status.html("Saving...");
	$uploader.slideToggle();
	// Post it
	$.post('#event.buildLink(prc.xehWidgetSave)#',
		{ widget:'#rc.widget#', widgetCode:editAreaLoader.getValue('widgetCode'), type: '#rc.type#'},
		function(data){
		$uploader.fadeOut(1500);
		$status.html('Code Saved!');
	});
	return false;
}
</script>
</cfoutput>