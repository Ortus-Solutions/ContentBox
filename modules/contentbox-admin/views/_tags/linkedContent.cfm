<cfoutput>
    <script>
        <cfif structKeyExists( rc, "contentID" ) and len( rc.contentID )>
            var currentLCContentID = #rc.contentID#;
        </cfif>
        $( document ).ready(function() {
            $( '##linkedContent-items' ).on( 'click', '.btn', function(){
                var me = this;
                $.ajax( {
                    url: '#event.buildLink( prc.xehBreakContentLink )#',
                    type: 'POST',
                    data: {
                        contentID: currentLCContentID,
                        linkedID: this.id
                    }
                } ).done(function() {
                    $( me ).closest( 'tr' ).remove();
                    toggleLCWarningMessage();
                } );
            } );
            toggleLCWarningMessage();
        } );
        function toggleLCWarningMessage() {
            var table = $( '##linkedContent-items' ),
                warning = $( '##linked-content-empty' );
            if( table.find( 'tr' ).length ) {
                warning.hide();
                table.show();
            }
            else {
                table.hide();
                warning.show();
            }
        }
    </script>
    <p>The items below have linked to this #args.contentType# as related content.</p>
    <table class="table table-hover table-striped" id="linkedContent-items">
        <tbody>
            <cfloop array="#args.linkedContent#" index="content">
                <cfset publishedClass = content.isContentPublished() ? "published" : "selected">
                <cfset publishedTitle = content.isContentPublished() ? "" : "Content is not published!">
                <tr id="content_#content.getContentID()#" class="related-content" title="#publishedTitle#">
                    <td width="14" class="center #publishedClass#">
                        <cfif content.getContentType() eq "Page">
                            <i class="fa fa-file-alt icon-small" title="Page"></i>
                        <cfelseif content.getContentType() eq "Entry">
                            <i class="fa fa-quote-left icon-small" title="Entry"></i>
                        <cfelseif content.getContentType() eq "ContentStore">
                            <i class="fa fa-hdd-o icon-small" title="ContentStore"></i>
                        </cfif>
                    </td>
                    <td class="#publishedClass#">#content.getTitle()#</td>
                    <td width="14" class="center #publishedClass#">
                        <button id="#content.getContentID()#" class="btn btn-xs btn-danger" type="button"><i class="fa fa-unlink" title="Break Link to Content"></i></button>
                    </td>
                </tr>
            </cfloop>
        </tbody>
    </table>
    <div id="linked-content-empty" class="alert alert-info">There are no links to this #args.contentType#</div>
</cfoutput>