<cfoutput>
<link href="#prc.cbroot#/includes/css/widgets/style.css" type="text/css" rel="stylesheet">
<!--- Custom Javascript --->
<script type="text/javascript">
$(document).ready(function() {
	// Widget Filter by text input
    $( '##widgetFilter' ).keyup(function(){
        var value = this.value,
            originalValue = value,
            widgetCount = 0;
		// remove selected class from any sidebar link
        // remove selected class from any sidebar link
        //$( '##widget-sidebar' ).find( 'li' ).removeClass( 'active' ).find( 'a' ).removeClass( 'current' );
        // set first item ('All') as selected
        //$( '##widget-sidebar' ).find( 'li' ).first().addClass( 'active' ).find( 'a' ).addClass( 'current' );
        // search through widget content to match ones relevant to the search
        $( '.widget-store' ).find( '.widget-content' ).each(function(){
            var widget = $( this );
            if( widget.attr( 'name' ).toLowerCase().indexOf( value.toLowerCase() ) != -1 ) {
                widget.show();
                widgetCount++;
            }
            else {
                widget.hide();
            }
        });
        if( !widgetCount ) {
            $( '.widget-no-preview' ).show();
        }
        else {
            $( '.widget-no-preview' ).hide();
        }
        if( originalValue != '' ) {
            $( '##widget-total-bar' ).html( 'Search for <strong>' + originalValue + '</strong> (' + widgetCount + ( widgetCount==1 ? ' Widget)' : ' Widgets)' ) )   
        }
        else {
            $( '##widget-total-bar' ).html( 'Category: <strong>All</strong> (' + widgetCount + ( widgetCount==1 ? ' Widget)' : ' Widgets)' ) )   
        }
	});
    // Handle clicks on widgets
    $( '.widget-content' ).click( function(){
        var me = $( this );
        // mark selected
        $( this ).addClass( 'selected' );
        // make ajax request for arguments form
        $.ajax({
            type: 'GET',
            url: getWidgetRenderArgsURL(),
            data: {
                widgetName: $( this ).attr( 'name' ),
                widgetType: $( this ).attr( 'type' ),
                widgetDisplayName: $( this ).attr( 'displayname' ),
                widgetUDF: 'renderIt'
            },
            success: function( data ) {
                // get content
                me.find( '.widget-args-holder' ).html( data );
                var content = me.find( '.widget-arguments-holder' ).html();
                // add content to arguments div
                $( '##widget-arguments' ).html( content );
                // fire switch method
                switchWidgetFormMode( 'detail' );
            }
        });
    });
    // Handle mode switch back to list
    $( '##widget-button-back' ).click( function(){
        $( '##widget-arguments' ).html( '' );
        $( '##widget-preview-content' ).html( '' );
        switchWidgetFormMode( 'list' );
    });
    // Handle widget insertion
    $( '##widget-button-insert' ).click( function() {
        insertCBWidget( $( '##widget-arguments' ).find( 'form' ).find( '##widgetName' ).val() );        
    });
    // Handle menu click
    $( '##widget-sidebar li' ).click( function(e){
        e.preventDefault();
        var me = $( this ),
            widgetCount = 0,
            link = me.find( 'a' ),
            originalValue = link.html(),
            // force lowercase so we don't have to deal with that
            value = link.html().toLowerCase();
        // remove selected from any selected
        me.parent().children().removeClass( 'active' ).find( 'a' ).removeClass( 'current' );
        // add selected class
        me.addClass( 'active' ).find( 'a' ).addClass( 'current' );
        // clear filter
        $( '##widgetFilter' ).val( '' );
        // search store for matching items
        $( '.widget-store' ).find( '.widget-content' ).each(function(){
            var widget = $( this );
            if( value=='all' ) {
                widget.show();
                widgetCount++;
            }
            else {
                if( widget.attr( 'category' ).toLowerCase().indexOf( value ) != -1 ) {
                    widget.show();
                    widgetCount++;
                }
                else {
                    widget.hide();
                }    
            }
        });
        if( !widgetCount ) {
            $( '.widget-no-preview' ).show();
        }
        else {
            $( '.widget-no-preview' ).hide();
        }
        $( '##widget-total-bar' ).html( 'Category: <strong>' + originalValue + '</strong> (' + widgetCount + ( widgetCount==1 ? ' Widget)' : ' Widgets)' ) ) 
    });
    $( '.widget-preview-refresh' ).click( function() {
        updatePreview();
    });
    $( '##widget-arguments' ).delegate( 'input, select', 'change', function(){
        if( !$( this ).hasClass( 'renderMethodSelect' ) ) {
            updatePreview();
        }
        else {
            updateArgs( $( this ) );
        }
    });
});

/*
 * Updates arguments div with new form based on render method selection
 * @select {HTMLSelect} the select box
 * return void
 */
function updateArgs( select ) {
    var args = {},
        form = $( '##widget-arguments' ).find( 'form' ).serializeArray();
    $.each( form, function(){
        args[ this.name ] = this.value;
    });
    args[ 'widgetUDF' ] = select.val();
    $.ajax({
        type: 'GET',
        url: getWidgetRenderArgsURL(),
        data: args,
        success: function( data ) {
            // get final location for args
            var parent = $( '##widget-arguments' );
            // update form section
            parent.find( '.widget-args-holder' ).html( data );
            // udpate preview with new args
            updatePreview();
        }
    })
}

/*
 * Simple, common method to update preview div based on form parameters
 */
function updatePreview() {
    // get form
    var form = $( '##widget-arguments' ).find( 'form' ).serializeArray(),
        me = this,
        vals = {};
        // loop over form fields, and add form field values to struct
        $.each( form, function(){
            vals[ this.name ] = this.value;
        });
        // make ajax request for preview content
        $.ajax({
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
        });
}
/*
 * Get selected widget from collection
 */
function findSelectedWidget() {
    return $( '.widget-content.selected' );
}
/*
 * Handle switching between list and detail modes
 */
function switchWidgetFormMode( mode ) {
    var list = $( '##widget-container' ),
        detail = $( '##widget-detail' ),
        backBtn = $( '##widget-button-back' ),
        cancelBtn = $( '##widget-button-cancel' ),
        insertBtn = $( '##widget-button-insert' ),
        filter = $( '##widget-filter' ),
        titleBar = $( '##widget-title-bar' ),
        widgetName,form,vals,selected,src;
    switch( mode ) {
        // list mode
        case 'list':
            findSelectedWidget().removeClass( 'selected' );
            detail.fadeOut( 300, function() {
                list.fadeIn( 300 )  
                filter.show();
                backBtn.hide();
                insertBtn.hide();
                titleBar.html( 'Select a Widget' );
            });
            break;
        // detail mode
        case 'detail':
            list.fadeOut( 300, function() {
                detail.fadeIn( 300 );
                filter.hide();
                backBtn.show();
                insertBtn.show();
                form = detail.find( 'form' ).serializeArray();
                widgetName = detail.find( '##widgetName' ).val();
                widgetDisplayName = detail.find( '##widgetDisplayName' ).val();
                src = findSelectedWidget().find( 'img' ).attr( 'src' );
                titleBar.html( '<img width="25" src="' + src + '" /> Insert \'' +widgetDisplayName+ '\' Widget' );
                updatePreview();
            })
            break;
    }
}
/*
 * Creates widget for CKEDITOR instance editor
 * @widget {String} the widget to insert
 */
function insertCBWidget(widget){
    // conditional selector for different kinds of widgets
    var selector = widget.replace(/(~|@)/g, '\\$1'),
        form = $( '##widget-arguments' ).find( "##widgetArgsForm_"+selector ),
        selected = findSelectedWidget(),
        widgetContent,widgetInfobar,widgetInfobarImage,
        infobarText='',
        args,form,vals={},separator=" ";
    // apply form validator
	form.validator({position:'center right'});
    // choose form based on selector
	var $widgetForm = form;
    // validate form
	if( !$widgetForm.data("validator").checkValidity() ){
		return;
	}
    // add selector to args form
	args = form.serializeArray();
    $.each( args, function(){
        vals[ this.name ] = this.value;
    });
    // create new widget element
    widgetContent = new CKEDITOR.dom.element( 'widget' );
    widgetContent.setAttributes( vals );
    // create new widgetinfobar element
    widgetInfobar = new CKEDITOR.dom.element( 'widgetinfobar' );
    widgetInfobar.setAttributes({
        contenteditable: false    
    });
    // create new img element
    widgetInfobarImage = new CKEDITOR.dom.element( 'img' );
    widgetInfobarImage.setAttributes({
        src: findSelectedWidget().find( 'img' ).attr( 'src' ),
        width: 20,
        height:20,
        align:'left',
        style: 'margin-right:5px;',
        contenteditable: false
    })
    infobarText += form.find( '##widgetDisplayName' ).val() + ' : ';
    for( var i in args ) {
        if( args[ i ].value.length ) {
            if( args[ i ].name != 'widgetName' && args[ i ].name != 'widgetType' && args[ i ].name != 'widgetDisplayName' ) {
                infobarText+= args[ i ].name + ' = ' + args[ i ].value;
                if( i < args.length-1 ){
    				infobarText += ' | ';
    			}   
            }
        }
    }
    widgetInfobar.setText( infobarText.substring( 0, infobarText.length - 3 ) );
    widgetInfobar.append( widgetInfobarImage, true );
    widgetContent.append( widgetInfobar );
	sendEditorText( widgetContent );
}
/*
 * Pushes new element into CKEDITOR instance editor
 * @element {CKEDITOR.dom.element} The CKEDITOR element to insert into the editor
 */
function sendEditorText( element ){
    $("###rc.editorName#").ckeditorGet().insertElement( element );
	closeRemoteModal();
}
</script>
</cfoutput>