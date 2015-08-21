<cfoutput>
<style>
    .widget-wrapper {padding:5px;}
    .widget-content {cursor:pointer;clear:right;border: solid 1px ##dadada;padding: 10px;border-radius: 4px;margin-bottom:20px;}
    .widget-content.third {width:29%;}
    .widget-content.half {width:46%;}
    .widget-content.spacer {margin-left:20px;}
    .widget-content.selected {background-color:##f1f1f1 !important;}
    .widget-content:hover {background:##f1f1f1;}
    .widget-content:hover .widget-title {background:##dadada;}
    .widget-content img.widget-icon {float:left;margin-right:10px;transition: all .2s ease;-webkit-transition: all .2s ease;-moz-transition: all .2s ease;
    }
    .widget-content img.widget-icon{margin-bottom:15px;}
    .widget-icon-selector{ display: none; clear: both}
    .widget-icon-selector img.widget-icon {margin: 5px; float:left;margin-right:10px;transition: all .2s ease;-webkit-transition: all .2s ease;-moz-transition: all .2s ease;}
    .widget-content img.widget-icon:hover, .widget-icon-selector img.widget-icon:hover {transform: scale(1.01);-webkit-transform: scale( 1.08 );-moz-transform: scale( 1.08 );
    }
    .widget-title {position:relative;text-shadow: 1px 1px 1px rgba(255, 255, 255, 1);background:##efefef; padding:3px 10px;font-size:115%;font-weight:bold;margin: -10px -10px 10px;border-bottom:solid 1px ##dadada;}
    .widget-actions {position:relative;font-size:85%;background:##efefef; padding:3px 10px;font-weight:bold;margin: 0px -10px -10px;border-top:solid 1px ##dadada;clear:both;}
    .widget-type {font-size:80%;position:absolute;right:0px;margin-right:10px;color:##999;}
    .widget-teaser {line-height: 1.2em;font-size:11px;}
    .widget-footer-left {width: 50%;float: left;text-align: left;}
    .widget-footer-right {width: 50%;float: left;text-align: right;}
    .widget-no-preview {padding: 10px;background: ##efefef;border: dashed 1px ##dadada;font-weight: bold;margin-right: 15px;}
    .widget-preview-content .widget-no-preview {margin-top:10px;}
    ##confirmIt a.close, ##remoteModal a.close, ##quickPost a.close, .modal a.close {z-index:99999;}
    ##widget-title-bar img {margin-top:-5px;}
    .widget-total-bar {margin-bottom: 10px;font-size: 8pt;}
</style>
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
    // table sorting + filtering
    //$( "##widgets" ).tablesorter();
    $( "##widgetFilter" ).keyup(function(){
        $.uiTableFilter( $( "##widgets" ), this.value );
    } );
    // Widget Filter by text input
    $( '##widgetFilter' ).keyup(function(){
        var value = this.value,
            originalValue = value,
            widgetCount = 0;
        // remove selected class from any sidebar link
        $( '##widget-sidebar' ).find( 'li' ).removeClass( 'active' ).find( 'a' ).removeClass( 'current' );
        // set first item ('All') as selected
        $( '##widget-sidebar' ).find( 'li' ).first().addClass( 'active' ).find( 'a' ).addClass( 'current' );
        // search through widget content to match ones relevant to the search
        $( '.widget-store' ).find( '.widget-content' ).each(function(){
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
    } );
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
        $( '.widget-store' ).find( '.widget-content' ).each(function(){
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
    openRemoteModal( '#event.buildLink( prc.xehWidgetTest )#', attributes, 1000, 650 );
    return false;
}
</script>
</cfoutput>