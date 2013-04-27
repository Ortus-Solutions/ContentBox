<cfoutput>
<link href="#prc.cbroot#/includes/css/widgets/style.css" type="text/css" rel="stylesheet">
<!--- Custom JS --->
<script type="text/javascript">
$(document).ready(function() {
	$uploadForm = $("##widgetUploadForm");
	$widgetForm = $("##widgetForm");
	$forgebox   = $("##forgeboxPane");
	// table sorting + filtering
	$("##widgets").tablesorter();
	$("##widgetFilter").keyup(function(){
		$.uiTableFilter( $("##widgets"), this.value );
	});
	// form validator
	$uploadForm.validate({success:function(e,els){ activateLoaders(); }});
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
});
function activateLoaders(){
	$("##uploadBar").slideToggle();
	$("##uploadBarLoader").slideToggle();
}
function remove(widgetFile){
	$widgetForm.find("##widgetFile").val( widgetFile );
	$widgetForm.submit();
}
function loadForgeBox(orderBY){
	if( orderBY == null ){ orderBY = "popular"; }
	$forgebox.load('#event.buildLink(prc.xehForgeBox)#',
		{typeslug:'#prc.forgeBoxSlug#', installDir:'#prc.forgeBoxInstallDir#', returnURL:'#prc.forgeboxReturnURL#', orderBY:orderBY});
}
</script>
</cfoutput>