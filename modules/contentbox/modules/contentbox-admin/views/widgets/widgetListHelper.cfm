<cfoutput>
<script>
<cfif args.mode eq "edit">
document.addEventListener( "DOMContentLoaded", setupWidgetListing );
<cfelse>
( () => {
	setupWidgetListing();
})();
</cfif>

function setupWidgetListing(){
    // Widget Filter by text input
    $( '##widgetFilter' ).keyup(
        _.debounce(
            function(){
                var value 			= this.value,
                    originalValue 	= value,
					widgetCount 	= 0;

                // remove selected class from any sidebar link
				resetTabs();

				// set first item ('All') as selected
				$( '##widget-sidebar' )
					.find( 'li' )
					.first()
						.addClass( 'active' )
						.find( 'a' )
							.addClass( 'current' );

				// search through widget content to match ones relevant to the search
                $( '.widget-store' ).find( '.panel' ).each( function(){
                    var widget 	= $( this );
                    var wrapper = $( this ).parent();

					if( widget.attr( 'name' ).toLowerCase().indexOf( value.toLowerCase() ) != -1 ) {
                        wrapper.show();
                        widgetCount++;
                    } else {
                        wrapper.hide();
                    }
				} );

				toggleWidgetCount( widgetCount );
            },
            300
        )
	);

    // Handle menu clicks
    $( '##widget-sidebar li' ).click( function(){
        var thisTab       = $( this ),
            widgetCount   = 0,
            link          = thisTab.find( 'a > span.categoryName' ),
            originalValue = link.html(),
			// force lowercase so we don't have to deal with that
			value = $.trim( link.html().toLowerCase() );

        // remove selected from any selected
		resetTabs();
        // add selected class
        thisTab.addClass( 'active' ).find( 'a' ).addClass( 'current' );

		// clear filter
        $( '##widgetFilter' ).val( '' );

		// search store for matching items
        $( '.widget-store' ).find( '.panel' ).each(function(){
            var widget 	= $( this );
			var wrapper = $( this ).parent();

            if( value == 'all' ) {
                wrapper.show();
                widgetCount++;
            } else {
                if( widget.attr( 'category' ).toLowerCase().indexOf( value ) != -1 ) {
                    wrapper.show();
                    widgetCount++;
                }
                else {
                    wrapper.hide();
                }
            }
		} );

		toggleWidgetCount( widgetCount );
	});
}

function resetTabs(){
	$( '##widget-sidebar' )
		.find( 'li' )
		.removeClass( 'active' )
		.find( 'a' )
		.removeClass( 'current' );
}

function toggleWidgetCount( count ){
	if( count ){
		$( "##widgetCountAlert" ).hide()
	} else {
		$( "##widgetCountAlert" ).show()
	}
}

function clearFilter(){
	$( '##widgetFilter' ).val( '' );
	$( '.widget-store' ).find( '.panel' ).each( function(){
		$( this ).parent().show();
	} );
}

<cfif args.mode eq "edit">
	function getWidgetPreviewURL(){
		return '#event.buildLink( prc.cbAdminEntryPoint & ".widgets.preview" )#';
	}
	function getWidgetInstanceURL(){
		return '#event.buildLink( prc.cbAdminEntryPoint & ".widgets.viewWidgetInstance" )#';
	}
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