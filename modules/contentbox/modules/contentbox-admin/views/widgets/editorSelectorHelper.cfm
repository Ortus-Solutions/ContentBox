<cfoutput>
<!--- Custom Javascript --->
<script>
( () => {
    // Handle clicks on widgets
    $( '.widget-selector' ).click( function(){
        var me = $( this );
        // mark selected
        $( this ).addClass( 'selected' );
        // make ajax request for arguments form
        $.ajax( {
            type    : 'GET',
            url     : getWidgetInstanceURL(),
            data    : {
                widgetName          : $( this ).attr( 'name' ),
                widgetType          : $( this ).attr( 'type' ),
                widgetDisplayName   : $( this ).attr( 'displayname' ),
                widgetUDF           : 'renderIt',
                editorName          : '#rc.editorName#'
            },
            success  : function( data ) {
                // update content
                $( '##widget-detail' ).html( data );
                // fire switch method
                switchWidgetFormMode( 'detail' );
            }
        } );
    } );
    // Handle mode switch back to list
    $( '##widget-button-back' ).click( function(){
        $( '##widget-arguments' ).html( '' );
        $( '##widget-preview-content' ).html( '' );
        switchWidgetFormMode( 'list' );
    } );
} )();
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
            } );
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
                iconName = detail.find( "##widgetIcon" ).val();
                titleBar.html( '<i class="fa fa-' + iconName + '"></i> Insert \'' +widgetDisplayName+ '\' Widget' );
                //updatePreview();
            } )
            break;
    }
}
</script>
</cfoutput>
