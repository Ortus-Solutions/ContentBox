<cfoutput>
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
            $( '##contentContainer' ).load( '#event.buildLink( prc.xehRelatedContentSelector )#?excludeIDs=#rc.excludeIDs#', 
                { search: $this.val(), clear: clearIt }, 
                function(){
                    $relatedContentSelectorLoader.fadeOut();
            });
            
        });
        <cfif len( rc.search )>
        $( "##contentSearch" ).focus();
        </cfif>
    });
    function pagerLink(page){
        $relatedContentSelectorLoader.fadeIn("fast");
        $('##modal')
            .load( '#event.buildLink(prc.xehRelatedContentSelector )#?excludeIDs=#rc.excludeIDs#&page=' + page, function() {
                $relatedContentSelectorLoader.fadeOut();
        });
    }
    </script>
</cfoutput>
