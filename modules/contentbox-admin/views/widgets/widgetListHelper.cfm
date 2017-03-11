<cfoutput>
<!--- Custom JS --->
<script>
$(document).ready(function() {
    // table sorting + filtering
    $( "##widgetFilter" ).keyup(
        _.debounce(
            function(){
                $.uiTableFilter( $( "##widgets" ), this.value );
            },
            300
        )
    );
    // Widget Filter by text input
    $( '##widgetFilter' ).keyup(
        _.debounce(
            function(){
                var value = this.value,
                    originalValue = value,
                    widgetCount = 0;
                // remove selected class from any sidebar link
                $( '##widget-sidebar' ).find( 'li' ).removeClass( 'active' ).find( 'a' ).removeClass( 'current' );
                // set first item ('All') as selected
                $( '##widget-sidebar' ).find( 'li' ).first().addClass( 'active' ).find( 'a' ).addClass( 'current' );
                // search through widget content to match ones relevant to the search
                $( '.widget-store' ).find( '.panel' ).each(function(){
                    var widget = $( this );
                    var wrapper = $( this ).parent();
                    if( widget.attr( 'name' ).toLowerCase().indexOf( value.toLowerCase() ) != -1 ) {
                        wrapper.show();
                        widgetCount++;
                        updateWidgetCSS( widget, widgetCount );
                    }
                    else {
                        wrapper.hide();
                    }
                } );
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
            },
            300
        )
    );
    // Handle menu click
    $( '##widget-sidebar li' ).click( function(){
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
        $( '.widget-store' ).find( '.panel' ).each(function(){
            var widget = $( this );
            var wrapper = $( this ).parent();
            if( value=='all' ) {
                wrapper.show();
                widgetCount++;
                updateWidgetCSS( widget, widgetCount );
            }
            else {
                if( widget.attr( 'category' ).toLowerCase().indexOf( value ) != -1 ) {
                    wrapper.show();
                    widgetCount++;
                    updateWidgetCSS( widget, widgetCount );
                }
                else {
                    wrapper.hide();
                }    
            }
        } );
        if( !widgetCount ) {
            $( '.widget-no-preview' ).show();
        }
        else {
            $( '.widget-no-preview' ).hide();
        }
        $( '##widget-total-bar' ).html( 'Category: <strong>' + originalValue + '</strong> (' + widgetCount + ( widgetCount==1 ? ' Widget)' : ' Widgets)' ) ) 
    } ); 
} );
function updateWidgetCSS( widget, count ) {
    if( count % 3 != 1 ) {
        //widget.addClass( 'spacer' );
    }
    else {
        //widget.removeClass( 'spacer' );
    }
}
<cfif args.mode eq "edit">
function getWidgetPreviewURL(){ return '#event.buildLink( prc.cbAdminEntryPoint & ".widgets.preview" )#'; }
function getWidgetInstanceURL(){ return '#event.buildLink( prc.cbAdminEntryPoint & ".widgets.viewWidgetInstance" )#'; }
function testWidgetCode( name, type ){
    // Test it
    $widgetEditorForm = $( "##widgetEditForm" );
    var attributes = {
        modal       : true,
        mode        : 'Test',
        widgetName  : name,
        widgetType  : type
    };
    return openRemoteModal( '#event.buildLink( prc.xehWidgetTest )#', attributes );
}
</cfif>
</script>
</cfoutput>