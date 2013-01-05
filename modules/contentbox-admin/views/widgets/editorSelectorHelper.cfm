<cfscript>
	function renderWidgetArgs(udf,widgetName){
		var md = getMetadata( arguments.udf );
		var argForm = "";

		if( !arrayLen(md.parameters) ){ return argForm; }

		savecontent variable="argForm"{

			writeOutput( html.startForm(name="widgetArgsForm_#arguments.widgetName#") );
			writeOutput( html.startFieldSet(legend="Widget Arguments") );
			writeOutput("<p>Please fill out the arguments for this widget:</p>");

			for(var x=1; x lte arrayLen(md.parameters); x++){
				var thisArg = md.parameters[x];
				var requiredText = "";
				var requiredValidator = "";

				if( !structKeyExists(thisArg,"required") ){ thisArg.required = false; }
				if( !structKeyExists(thisArg,"hint") ){ thisArg.hint = ""; }
				if( !structKeyExists(thisArg,"type") ){ thisArg.type = "any"; }
				if( !structKeyExists(thisArg,"default") ){ thisArg.default = ""; }

				// required stuff
				if( thisarg.required ){
					requiredText = "<span class='textRed'>Required</span>";
					requiredValidator = "required";
				}

				writeOutput( html.label(field=thisArg.name,content="#thisArg.name# (Type=#thisArg.type#) #requiredText#") );
				if( len( thisArg.hint ) ){
					writeOutput( "<small>#thisArg.hint#</small><br/>" );
				}
				// Boolean?
				if( thisArg.type eq "boolean"){
					writeOutput( html.select(name=thisArg.name,options="true,false",selectedValue=thisArg.default) );
				}
				else{
					writeOutput( html.textfield(name=thisArg.name,size="35",class="textfield",required=requiredValidator,title=thisArg.hint) );
				}
			}
			writeOutput( "<br/><br/><div>" & html.button(name="selectWidget_#widgetName#",value="Insert Widget",class="button2",onclick="insertCBWidget('#widgetName#')") & "</div>");
			writeOutput( html.endFieldSet() );
			writeOutput( html.endForm() );
		}

		return argForm;
	}
</cfscript>
<cfoutput>
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
	// Widget Filter
	$("##widgetFilter").keyup(function(){
		$.uiTableFilter( $("##widgets"), this.value );
	});
});
function selectCBWidget(widget){
    var selector = widget.replace(/(~|@)/g, '\\$1');
	var argDiv = $("##widgetArgs_"+selector).slideToggle();
	// check if we have arguments, else just insert
	if( !argDiv.html().length ){
		sendEditorText("{{{"+widget+"}}}");
	}
	// apply form validator
	$("##widgetArgsForm_"+selector).validator({position:'center right'});
}
function insertCBWidget(widget){
    // conditional selector for different kinds of widgets
    var selector = widget.replace(/(~|@)/g, '\\$1');
    // choose form based on selector
	var $widgetForm = $("##widgetArgsForm_"+selector);

	if( !$widgetForm.data("validator").checkValidity() ){
		return;
	}
    // add selector to args form
	var args = $("##widgetArgsForm_"+selector).serializeArray();
	var widgetContent = "{{{"+widget;
    // build out content
    widgetContent +=":";
	for(var i in args){
		if( args[i].value.length ){
			widgetContent += args[i].name+"='"+args[i].value+"'";
			// arg separator
			if( i < args.length ){
				widgetContent+=",";
			}
		}
	}
	widgetContent = widgetContent.replace(/\,$/, "");

	widgetContent+="}}}";
	sendEditorText( widgetContent );
}
function sendEditorText(text){
	$("###rc.editorName#").ckeditorGet().insertText( text );
	closeRemoteModal();
}
</script>
</cfoutput>