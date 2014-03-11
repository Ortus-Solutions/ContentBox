 <cfoutput>
    <style>
        .dd { width:75%; }
    </style>
    <script>
        var confirmConfig = {
            placement: 'right',
            title: 'Are you sure you want to remove this menu item and all its descendants?',
            singleton: true,
            href: 'javascript:void(0);',
            onConfirm: function() {
                $( this ).closest( '.dd3-item' ).remove();
            }
        };
        // Create Slug
        function createSlug( linkToUse ){
            var linkToUse = ( typeof linkToUse === "undefined" ) ? $( "##title" ).val() : linkToUse,
                $slug = $( '##slug' );
            if( !linkToUse.length ){ 
                return; 
            }
            toggleSlug()
            $.get( '#event.buildLink( prc.xehSlugify )#', { slug : linkToUse }, function( data ){
                $slug.val( data );
                slugUniqueCheck();
                toggleSlug();
            });
        }

        //disable or enable (toggle) slug field
        function toggleSlug(){
            var toggle = $( '##toggleSlug' ),
                $slug = $( '##slug' );
            // Toggle lock icon on click..  
            toggle.hasClass( 'icon-lock' ) ? toggle.attr( 'class', 'icon-unlock' ) : toggle.attr( 'class', 'icon-lock' );
            //disable input field
            $slug.prop( "disabled", !$slug.prop( 'disabled' ) );
        }
        /**
         * Checks slug for uniqueness
         * @param {String} linkToUse The link to use for validating the slug
         */
        function slugUniqueCheck( linkToUse ){
            var $slug = $( '##slug' ),
                linkToUse = ( typeof linkToUse === "undefined" ) ? $slug.val() : linkToUse;
            linkToUse = $.trim( linkToUse ); //slugify still appends a space at the end of the string, so trim here for check uniqueness    
            if( !linkToUse.length ){ 
                return; 
            }
            // Verify unique
            $.getJSON( '#event.buildLink( prc.xehSlugCheck )#', { slug:linkToUse, menuID: $( '##menuID' ).val() }, function( data ){
                if( !data.UNIQUE ){
                    $( '##slugCheckErrors' ).html('The menu slug you entered is already in use, please enter another one or modify it.').addClass( 'alert' );
                }
                else{
                    $( '##slugCheckErrors' ).html( '' ).removeClass( 'alert' );
                }
            } );
        }
        /**
         * Updates label of menu item when label is changed in form
         * @param {HTMLElement} el The DOM element of the label field
         */
        function updateLabel( el ) {
            var me = $( el ),
                titleDiv = me.closest( '.dd3-extracontent' ).prev( '.dd3-content' ),
                value = me.val() != '' ? me.val() : '<i class="emptytext">Please enter a label</i>';
            // toggle 
            $( titleDiv ).html( value );
        }
        /**
         * Adds menu item into the tree
         * @param {HTMLElement} content The DOM element being added
         * @param {HTMLElement} context The DOM element to which the menu item is being added
         */
        function addMenuItem( content, $context ) {
            var $wrapper = $( '##nestable' ),
                $outer = $wrapper.children( 'ol' );
            // if there is a context, we're inserting a child node
            if( $context ) {
                var $listWrapper = $context.children( 'ol' );
                // if no children found for context item...
                if( !$listWrapper.length ) {
                    // create sub list
                    $context.append( '<ol class="dd-list"></ol>' );
                    // notify nestable of new parent
                    $wrapper.nestable( {fn:'setParent', args:[ $context ]} );
                }
                $outer = $context.children( 'ol' );
            }
            $( content ).appendTo( $outer ).each(function() {
                var extra = $( this ).find( '.dd3-extracontent' );
                extra.toggle( 300 );
                extra.find( 'input[name^=label]' ).focus();
                var element = $( this );
                $( element ).find( '[data-toggle="confirmation"]' ).confirmation( confirmConfig );
            });
            activateTooltips();
        }
        /**
         * Creates data objects on menu item by parsing child form fields
         * @param {jQueryElement} $li The jQuery Element to whcih data needs to be added
         */
        function processItem( $li ) {
            var fields = $li.children( '.dd3-extracontent' ).find( ':input' ),
                errors =  0;
            // run over fields to gather data for serialization
            for( var i=0; i<fields.length; i++ ) {
                var $fld = $( fields[ i ] );
                $li.data( $fld.data( 'original-name' ), $fld.val() );
            }
        }
        /**
         * Toggles error states on menu items
         * @param {String} dir The direction (on/off)
         */
        function toggleErrors( dir ) {
            var $nestable = $( '##nestable' ),
                $errors = $( '##menuErrors' );
            switch( dir ) {
                case 'on':
                    // highlight errors
                    $nestable .find( 'div.error' ).each(function() {
                        $( this ).closest( '.dd3-item' ).children( '.dd3-type' ).removeClass( 'btn-inverse' ).addClass( 'btn-danger' );
                    });
                    // expand so we can see nested errors
                    $( '.dd' ).nestable( 'expandAll' );
                    $errors.show();
                    break;
                case 'off':
                    // remove error highlights
                    $nestable .find( '.dd3-type' ).each(function() {
                        $( this ).removeClass( 'btn-danger' ).addClass( 'btn-inverse' );
                    });
                    $errors.hide();
                    break; 
            }
        }
        function transformFieldNames() {
            var $nestable = $( '##nestable' ),
                i =0;
            // stupid jQuery validator...can't handle duped names. let's fix that
            $nestable .find( ':input' ).each(function(){
                $fld = $( this );
                // if we've already transformed, just skip
                if( $fld.attr( 'data-original-name' ) === undefined ) {
                    $fld.attr( 'data-original-name', $fld.attr( 'name' ) );
                    $fld.attr( 'name', $fld.attr( 'name' ) + '-' + i );
                }
                i++;
            })
        }
        /**
         * Saves menu with serialized item data
         */
        function saveMenu() {
            var form = $( '##menuForm' ),
                nestable = $( '##nestable' );
            // transform fields
            transformFieldNames();
            // if valid, submit form
            if( $( '##menuForm' ).valid() ) {
                toggleErrors( 'off' );
                // prepare data
                $( '##nestable li' ).each(function() {
                    processItem( $( this ) );
                });
                // get serialized data
                $( '##submitMenu' ).attr( 'disabled', true ).html( '<i class="icon-spinner icon-spin"></i> Saving...' );
                $( '##menuItems' ).val( JSON.stringify( nestable.nestable( 'serialize' ) ) );
                form.submit();
            }
            else {
                toggleErrors( 'on' );
            }
        }
        /**
         * Previews menu with serialized item data
         */
        function previewMenu() {
            var form = $( '##menuForm' ),
                nestable = $( '##nestable' );
            // transform fields
            transformFieldNames();
            // if valid, preview
            if( $( '##menuForm' ).valid() ) {
                toggleErrors( 'off' );
                // prepare data
                $( '##nestable li' ).each(function() {
                    processItem( $( this ) );
                });
                // get serialized data
                $( '##menuItems' ).val( JSON.stringify( nestable.nestable( 'serialize' ) ) );
                $.ajax({
                    url: '#event.buildLink( linkTo=prc.xehMenuPreview )#',
                    type: 'POST',
                    data: form.serialize(),
                    success: function( data, textStatus, jqXHR ){
                        var $modal = $( '##previewDialog' );
                            $modal.find( '.modal-body' ).html( data );
                        openModal( $modal, 500 );
                    }
                });
            }
            else {
                toggleErrors( 'on' );
            }
        }

        $( document ).ready(function() {
            //****** setup listeners ********//
            var $contextMenu = $( '##context-menu' );
            var $title = $( '##menuForm' ).find( "##title" );
            var $slug = $( '##slug' );
            var $menuItemClicked;
            // hide context menu
            $( document ).click( function() {
                $contextMenu.hide();
            });
            // add contextmenu 
            $( '##nestable' ).on( 'contextmenu', ".dd3-content", function( e ) {
                $menuItemClicked = $( this );
                $contextMenu.css({
                    display: "block",
                    left: e.pageX,
                    top: e.pageY
                });
                return false;
            });
            // add listeners to contextmenu links
            $contextMenu.on( 'click', 'a', function () {
                var parent = $menuItemClicked.closest( 'li' );
                var context = $( parent );
                var provider = $( this ).data( 'provider' );
                $.ajax({
                    url: '#event.buildLink( linkto=prc.xehMenuItem )#',
                    data: { type: provider },
                    success: function( data, textStatus, jqXHR ){
                        addMenuItem( data, context );
                    }
                })
                $contextMenu.hide();
            });
            // add listener to submit button
            $( '##submitMenu' ).on( 'click', function() {
                if( $( this ).attr( 'disabled' ) ) {
                    return false;
                }
                saveMenu();
            });
            // add listener for preview
            $( '##preview-button' ).on( 'click', function() {
                previewMenu();
            });
            // add confirmation toggle
            $( '[data-toggle="confirmation"]' ).confirmation( confirmConfig );
            // setup expand listeners
            $( '##nestable' ).on('click', '.dd3-expand', function() {
                var me = $( this ),
                    li = me.closest( 'li' ),
                    prev = me.prev( '.dd3-extracontent' );

                // toggle 
                prev.slideToggle( 200 );
            });
            // add input listeners to update label field
            $( '##nestable' ).on('keyup change focus blur', 'input[name^=label]', function() {
                updateLabel( this );
            });
            // provider buttons
            $( '.provider' ).click(function( e ) {
                e.preventDefault();
                var provider = $( this ).data( 'provider' );
                $.ajax({
                    url: '#event.buildLink( linkto=prc.xehMenuItem )#',
                    data: { type: provider, menuID: '#rc.menuID#' },
                    success: function( data, textStatus, jqXHR ){
                        addMenuItem( data );
                    }
                })
            });
            // toggle buttons
            $( 'a[data-action]' ).on( 'click', function() {
                var $button = $( this );
                switch( $button.data( 'action' ) ) {
                    case 'expand-all':
                        $( '.dd' ).nestable( 'expandAll' );
                        break;
                    case 'collapse-all':
                        $( '.dd' ).nestable( 'collapseAll' );
                        break;
                }
            })
            // Activate blur slugify on titles

            // set up live event for title, do nothing if slug is locked..
            $title.on('blur', function(){
                if( !$slug.prop( 'disabled' ) ){
                    createSlug( $title.val() );
                }
            });
            // Activate permalink blur
            $slug.on('blur',function(){
                if( !$( this ).prop( 'disabled' ) ){
                    slugUniqueCheck();
                }
            });
            //******** setup nestable menu items **************//
            $( '##nestable' ).nestable({});
        });
    </script>
</cfoutput>