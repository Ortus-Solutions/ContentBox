<cfscript>
	function renderWidgetArgs(udf,widgetName,widgetType,widgetDisplayName){
		var md = getMetadata( arguments.udf );
		var argForm = "";
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
					writeOutput( html.textfield(name=thisArg.name,size="35",class="textfield",required=requiredValidator,title=thisArg.hint,value=thisArg.default) );
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
        $( '##widget-sidebar' ).find( 'li' ).removeClass( 'active' ).find( 'a' ).removeClass( 'current' );
        // set first item ('All') as selected
        $( '##widget-sidebar' ).find( 'li' ).first().addClass( 'active' ).find( 'a' ).addClass( 'current' );
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
        // mark selected
        $( this ).addClass( 'selected' );
        // get content
        var content = $( this ).find( '.widget-arguments-holder' ).html();
        // add content to arguments div
        $( '##widget-arguments' ).html( content );
        // fire switch method
        switchWidgetFormMode( 'detail' );
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
        updatePreview();
    });
});
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