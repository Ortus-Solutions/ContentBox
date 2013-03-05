<cfoutput>
<link href="#prc.cbroot#/includes/css/widgets/style.css" type="text/css" rel="stylesheet">	
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
    updatePreview();
    $( '##widget-button-update' ).click( function() {
        updateCBWidget();        
    });
    $( '.widget-preview-refresh' ).click( function() {
        updatePreview();
    });
    $( '##widget-arguments' ).delegate( 'input, select', 'change', function(){
        updatePreview();
    });
});
function updatePreview() {
    var form = $( '##widget-arguments' ).find( 'form' ).serializeArray(),
        me = this,
        vals = {};
        $.each( form, function(){
            vals[ this.name ] = this.value;
        });
        $.ajax({
            type: 'GET',
            url: getWidgetPreviewURL(),
            data: vals,
            success: function( data, status, xhr ) {
                if( !data.length ) {
                    $( '##widget-preview-content' ).html( '<div class="widget-no-preview">No preview available!</div>' ); 
                }
                else {
                    $( '##widget-preview-content' ).html( data );
                }
            }
        });
}
function updateCBWidget() {
    var editor = $("###rc.editorName#").ckeditorGet(),
            element = editor.widgetSelection,
            textel = element.getChild( 0 ).getChild( 1 ),
            form = $( '##widget-arguments' ).find( 'form' ),
            args = form.serializeArray(),
            vals={},infobarText='',i=0,re = / \| $/g;
    // apply form validator
	form.validator({position:'center right'});
    // choose form based on selector
	var $widgetForm = form;
    // validate
	if( !$widgetForm.data("validator").checkValidity() ){
		return;
	}
    // get attributes from form
    $.each( args, function(){
        vals[ this.name ] = this.value;
    })
    infobarText += vals[ 'widgetDisplayName' ] + ' : ';
    for( var item in vals ) {
        if( vals[ item ].length ) {
            if( item != 'widgetName' && item != 'widgetType' && item != 'widgetDisplayName' ) {
                infobarText+= item + ' = ' + vals[ item ] + ' | ';  
            }
        }
    }

    textel.setText( infobarText.substring( 0, infobarText.length - 3 ) );
    // update element attributes and text
    element.setAttributes( vals );
	closeRemoteModal();
}
</script>
<cfscript>
	function renderWidgetArgs( udf, widgetName, widgetType, widgetDisplayName, vals ){
		var md = getMetadata( arguments.udf );
		var argForm = "";

		//if( !arrayLen(md.parameters) ){ return argForm; }

		savecontent variable="argForm"{

			writeOutput( html.startForm(name="widgetArgsForm_#arguments.widgetName#") );
			writeOutput( html.startFieldSet(legend="Widget Arguments") );
			if( arrayLen( md.parameters ) ){ 
				writeOutput( "<p>Please fill out the arguments for this widget:</p>" );
			}
			else {
				writeOutput( "<p>There are no arguments for this widget!</p>" );
			}


			for(var x=1; x lte arrayLen(md.parameters); x++){
				var thisArg = md.parameters[x];
				var requiredText = "";
				var requiredValidator = "";

				if( !structKeyExists(thisArg,"required") ){ thisArg.required = false; }
				if( !structKeyExists(thisArg,"hint") ){ thisArg.hint = ""; }
				if( !structKeyExists(thisArg,"type") ){ thisArg.type = "any"; }
				if( !structKeyExists(thisArg,"default") ){ thisArg.default = ""; }
				thisArg.value = structKeyExists( arguments.vals, thisArg.name ) ? arguments.vals[ thisArg.name ] : "";
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
					writeOutput( html.select(name=thisArg.name,options="true,false",selectedValue=thisArg.value) );
				}
				else{
					writeOutput( html.textfield(name=thisArg.name,size="35",class="textfield",required=requiredValidator,title=thisArg.hint, value=thisArg.value ) );
				}
			}
			writeOutput( html.hiddenfield( name="widgetName", id="widgetName", value=widgetName ) );
			writeOutput( html.hiddenfield( name="widgetDisplayName", id="widgetDisplayName", value=widgetDisplayName ) );
			writeOutput( html.hiddenfield( name="widgetType",value=widgetType ) );
			writeOutput( html.endFieldSet() );
			writeOutput( html.endForm() );
		}

		return argForm;
	}
</cfscript>
</cfoutput>