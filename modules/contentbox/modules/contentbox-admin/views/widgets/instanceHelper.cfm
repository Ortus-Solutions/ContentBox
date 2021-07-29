<cfset event.paramValue( "editorName", "" )>
<cfoutput>
<!--- Custom Javascript --->
<script>
( () => {
    // register listeners
    $( '##widget-button-insert' ).off( 'click.inWidget' ).on( 'click.inWidget', insertCBWidget );
    $( '##widget-button-update' ).off( 'click.upWidget' ).on( 'click.upWidget', updateCBWidget );
    $( '.widget-preview-refresh' ).off( 'click.refWidget' ).on( 'click.refWidget', updatePreview );
    $( '.widget-arguments' ).delegate( 'input,select', 'change', function(){
        if( !$( this ).hasClass( 'renderMethodSelect' ) ) {
            updatePreview();
        }
        else {
            updateArgs( $( this ) );
        }
    } );
    updatePreview();
} )();

/*
 * Gets form values from arguments form
 * return {Array}
 */
function getFormValues() {
    var form = $( '##widget-arguments' ).find( 'form' ).serializeArray(),
        vals = {};
    // loop over form fields, and add form field values to struct
    $.each( form, function(){
        vals[ this.name ] = this.value;
    } );
    return vals;
}

/*
 * Updates arguments div with new form based on render method selection
 * @select {HTMLSelect} the select box
 * return void
 */
function updateArgs( select ) {
    var vals = getFormValues();
    $.ajax( {
        type: 'GET',
        url: getWidgetInstanceURL(),
        data: {
            widgetName: vals.widgetName,
            widgetType: vals.widgetType,
            widgetDisplayName: vals.widgetDisplayName,
            widgetUDF: select.val(),
            editorName: '#rc.editorName#',
            modal: false
        },
        success: function( data ) {
            // update content
            $( '##widget-preview-wrapper' ).parent().html( data );
        }
    } );
}

/*
 * Simple, common method to update preview div based on form parameters
 */
function updatePreview() {
    // get form
    var vals = getFormValues(),
        me = this;
        // make ajax request for preview content
        $.ajax( {
            type: 'GET',
            url: getWidgetPreviewURL(),
            data: vals,
            success: function( data, status, xhr ) {
                // if we have content, update it
                if( !data.length ) {
                    $( '##widget-preview-content' ).html( '<div class="widget-no-preview">No preview available!</div>' );
                }
                // otherwise, show error message
                else {
                    $( '##widget-preview-content' ).html( data );
                }
            },
            error: function( e ) {
                $( '##widget-preview-content' ).html( '<div class="widget-no-preview">No preview available!</div>' );
            }
        } );
}

function buildInfobarText( vals, count ) {
    var blacklistKeys = ['widgetName','widgetType','widgetDisplayName','renderMethodSelect','widgetUDF'],
        infobarText='',i=1,pop=false;
    infobarText += vals[ 'widgetDisplayName' ] + ' : ';
    for( var item in vals ) {
        pop=false;
        i++;
        if( vals[ item ].length ) {
            if( $.inArray( item, blacklistKeys ) == -1 ) {
                infobarText+= item + ' = ' + vals[ item ];
                pop=true;
            }
            if( item == 'widgetUDF' ) {
                infobarText += 'UDF = ' + vals[ item ] + '()';
                pop=true;
            }
            if( i < count && pop ){
                infobarText += ' | ';
            }
        }
    }
    return infobarText;
}

/*
 * Creates widget for CKEDITOR instance editor
 */
function insertCBWidget(){
    // conditional selector for different kinds of widgets
    var form = $( '##widget-arguments' ).find( 'form' ),
        widgetContent,widgetInfobar,widgetInfobarImage,
        args = form.serializeArray(),
        vals = getFormValues(),
        infobarText = buildInfobarText( vals, args.length );
    // apply form validator
    form.validate();
    // choose form based on selector
    var $widgetForm = form;
    // validate form
    if( !$widgetForm.valid() ){
        return;
    }
    // add selector to args form
    args = form.serializeArray();
    vals = getFormValues();

    // NO CKEditor
    if( typeof( CKEDITOR ) == 'undefined' ){
        var widget = "{{{" + vals.widgetName;

        // Function name
        if( vals.widgetUDF.toLowerCase() !== "renderit" ){
            widget += "." + vals.widgetUDF;
        }

        // Arguments
        var blacklistKeys = ['widgetName','widgetType','widgetDisplayName','renderMethodSelect','widgetUDF','widgetIcon']
        for( var item in vals ){
            if( $.inArray( item, blacklistKeys ) == -1 ) {
                widget += " " + item + "=" + "'" + vals[ item ] + "'";
            }
        }

        // close it
        widget += "}}}";
        insertEditorContent( '#rc.editorName#', widget );
        closeRemoteModal();
        return false;
    }

    // create new widget element
    widgetContent = new CKEDITOR.dom.element( 'widget' );
    widgetContent.setAttributes( vals );
    // create new widgetinfobar element
    widgetInfobar = new CKEDITOR.dom.element( 'widgetinfobar' );
    widgetInfobar.setAttributes( {
        contenteditable: false
    } );
    // create new img element
    widgetInfobarImage = new CKEDITOR.dom.element( 'img' );
    widgetInfobarImage.setAttributes( {
        src: '#prc.cbroot#/includes/images/ContentBox_30.png',
        width: 20,
        height:20,
        align:'left',
        style: 'margin-right:5px;',
        contenteditable: false
    } )
    widgetInfobar.setText( infobarText );
    widgetInfobar.append( widgetInfobarImage, true );
    widgetContent.append( widgetInfobar );
    sendEditorText( widgetContent );
}

/*
 * Updates widget in CKEditor with new values from form
 * return void
 */
function updateCBWidget() {
    var editor = $( "###rc.editorName#" ).ckeditorGet(),
        element = editor.widgetSelection,
        textel = element.getChild( 0 ).getChild( 1 ),
        form = $( '##widget-arguments' ).find( 'form' ),
        args = form.serializeArray(),
        vals=getFormValues(),
        infobarText=buildInfobarText( vals, args.length );
    // apply form validator
    form.validate();
    // choose form based on selector
    var $widgetForm = form;
    // validate
    if( !$widgetForm.valid() ){
        return;
    }
    textel.setText( infobarText );
    // update element attributes and text
    element.setAttributes( vals );
    closeRemoteModal();
}

/*
 * Pushes new element into CKEDITOR instance editor
 * @element {CKEDITOR.dom.element} The CKEDITOR element to insert into the editor
 */
function sendEditorText( element ){
    // call via editor interface to insert
    insertEditorContent( '#rc.editorName#', element );
    closeRemoteModal();
}
</script>
</cfoutput>