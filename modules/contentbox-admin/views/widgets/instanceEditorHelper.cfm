<cfoutput>
<link href="#prc.cbroot#/includes/css/widgets/style.css" type="text/css" rel="stylesheet">	
<!--- Custom Javascript --->
<script type="text/javascript">
    // temp cache for initial request, since form won't be available
    var argCache = {};
    <cfloop collection="#prc.vals#" item="key">
        <cfif isSimpleValue( prc.vals[ key ] ) >
        argCache[ '#key#' ] = '#prc.vals[ key ]#';    
        </cfif>
    </cfloop>
$(document).ready(function() {
    updateArgs( false );
    $( '##widget-button-update' ).click( function() {
        updateCBWidget();        
    });
    $( '.widget-preview-refresh' ).click( function() {
        updatePreview();
    });
    $( '##widget-arguments' ).delegate( 'input, select', 'change', function(){
        if( $( this ).attr( 'id' )!='renderMethodSelect' ) {
            updatePreview();
        }
    });
    $( '##renderMethodSelect' ).change( updateArgs );
});

/*
 * Updates arguments div with new form based on render method selection
 * @useArgs {Boolean} whether to use form or argCache (default: false)
 * return void
 */
function updateArgs( useArgs ) {
    var args = {};
    // if using form
    if( useArgs ) {
        var form = $( '##widget-arguments' ).find( 'form' ).serializeArray();
        $.each( form, function(){
            args[ this.name ] = this.value;
        });
        args[ 'widgetUDF' ] = $( '##renderMethodSelect' ).val();
    }
    // if using arugment cache
    else {
        args = argCache;
    }
    $.ajax({
        type: 'GET',
        url: getWidgetRenderArgsURL(),
        data: args,
        success: function( data ) {
            $( '.widget-args-holder' ).html( data );
            updatePreview();
        }
    })
}

/*
 * Creates AJAX request to update preview area based on argument form
 * return void
 */
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

/*
 * Updates widget in CKEditor with new values from form
 * return void
 */
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
            if( item != 'widgetName' && item != 'widgetType' && item != 'widgetDisplayName' && item != 'widgetUDF' ) {
                infobarText+= item + ' = ' + vals[ item ] + ' | ';  
            }
            if( item == 'widgetUDF' ) {
                infobarText += 'UDF = ' + vals[ item ] + '() | '; 
            }
        }
    }

    textel.setText( infobarText.substring( 0, infobarText.length - 3 ) );
    // update element attributes and text
    element.setAttributes( vals );
	closeRemoteModal();
}
</script>
</cfoutput>