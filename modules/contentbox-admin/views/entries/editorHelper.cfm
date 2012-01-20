<cfoutput>
<!--- Load Assets --->
#html.addAsset(prc.cbroot&"/includes/ckeditor/ckeditor.js")#
#html.addAsset(prc.cbroot&"/includes/ckeditor/adapters/jquery.js")#
#html.addAsset(prc.cbroot&"/includes/js/contentbox.editor.js")#
#html.addAsset(prc.cbroot&"/includes/css/date.css")#
<!--- Custom Javascript --->
<script type="text/javascript">
function getEditorSelectorURL(){ return '#event.buildLink(prc.xehWidgetSelector)#';}
</script>
</cfoutput>
<!--- Custom CF UDFs --->
<cfscript>
	function toCKDate(inDate){
		return dateFormat(arguments.inDate,"yyyy-mm-dd");
	}
	function ckHour(inDate){
		if( isNull(inDate) ){ inDate = now(); }
		return timeFormat(arguments.inDate,"HH");
	}
	function ckMinute(inDate){
		if( isNull(inDate) ){ inDate = now(); }
		return timeFormat(arguments.inDate,"mm");
	}
</cfscript>
