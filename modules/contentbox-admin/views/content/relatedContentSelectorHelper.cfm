<cfscript>
    function getContentTypeIconCls( contentType ) {
        var iconCls = "";
        switch( arguments.contentType ) {
            case 'Page':
                iconCls = "icon-file-alt";
                break;
            case 'Entry':
                iconCls = "icon-quote-left";
                break;
            case 'ContentStore':
                iconCls = "icon-hdd";
                break;
            default:
                break;
        }
        return iconCls;
    }
</cfscript>
<cfoutput>
    <style>
        .tab-content>.active, .pill-content>.active {
            display:block !important;
        }
    </style>
    <!--- Custom Javascript --->
    <script type="text/javascript">
    $( document ).ready(function() {
        // Shared Pointers
        $relatedContentSelectorForm    = $( "##relatedContentSelectorForm" );
        $relatedContentSelectorLoader  = $relatedContentSelectorForm.find( "##contentLoader" );
        // keyup quick search
        $( "##contentSearch" ).keyup(function(){
            var $this = $( this );
            var clearIt = ( $this.val().length > 0 ? false : true );
            // ajax search
            var params = { search: $this.val(), clear: clearIt };
            loadContentTypeTab( 'Page', params );
            loadContentTypeTab( 'Entry', params );
            loadContentTypeTab( 'ContentStore', params );
        });
        // prevent enter submisson
        $( "##contentSearch" ).keydown(function( e ){
            if( e.keyCode == 13 ) {
              e.preventDefault();
              return false;
            }
        });
        // handler for tabbed content
        $( '##contentTypes a' ).click(function( e ) {
            e.preventDefault();
            $( this ).tab( 'show' );
        })
        <cfif len( rc.search )>
        $( "##contentSearch" ).focus();
        </cfif>
        // fire off requests for individual tabs...should be dynamically evaluated in the future, I think
        loadContentTypeTab( 'Page', {} );
        loadContentTypeTab( 'Entry', {} );
        loadContentTypeTab( 'ContentStore', {} );
    });
    /**
     * Generic method for making an AJAX request for tabbed related content
     * @param {String} contentType The content type to restrict the results to
     * @param {Object} params Optional hash of params to send along with the request
     */
    function loadContentTypeTab( contentType, params ) {
        var url = '#event.buildLink( prc.xehRelatedContentSelector )#?excludeIDs=#rc.excludeIDs#&contentType=' + contentType;
        $( '##' + contentType ).load( url, params, function( data ) {});
    }
    /**
     * Handler for pager links; has additional contentType argument to determine which pager/tab combo is currently active
     * @param {Number} page The clicked "page"
     * @param {String} contentType The contentType to restrict results to
     */
    function pagerLink( page, contentType ){
        $relatedContentSelectorLoader.fadeIn("fast");
        var url = '#event.buildLink(prc.xehRelatedContentSelector )#?excludeIDs=#rc.excludeIDs#&contentType=' + contentType + '&page=' + page;
        $( '##' + contentType ).load( url, function( data ) {
            $relatedContentSelectorLoader.fadeOut();
        });
    }
    </script>
</cfoutput>
