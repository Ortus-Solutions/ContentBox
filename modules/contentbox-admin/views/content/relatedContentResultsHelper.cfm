<cfoutput>
    <script>
        $( document ).ready(function() {
            // on load, update tab with result count
            var tab = $( 'a[href=###rc.contentType#]' );
            var baseHTML = tab.html().replace( /<(span)[^>]*>[^<]*(<\/span>)/ig, '' );
            var badge = '<span class="label">#prc.contentCount#</span>';
            // set new content
            tab.html(  baseHTML + '  ' + badge );
        });
    </script>
</cfoutput>