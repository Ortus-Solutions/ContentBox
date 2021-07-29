<cfoutput>
    <script>
        document.addEventListener( "DOMContentLoaded", () => {
            // on load, update tab with result count
            var tab = $( 'a[href="###rc.contentType#"]' );
            var baseHTML = tab.html().replace( /<(span)[^>]*>[^<]*(<\/span>)/ig, '' );
            var badge = '<span class="label label-default">#prc.contentCount#</span>';
            // set new content
            tab.html(  baseHTML + '  ' + badge );
        } );
    </script>
</cfoutput>