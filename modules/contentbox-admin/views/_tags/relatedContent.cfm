<cfoutput>
    <style>
        .btn-tiny {
            padding: 0 3px;
            font-size: 9.5px;
            line-height:14px;
        }
    </style>
    <script>
        $( document ).ready(function() {
            // listener for add button
            $( '##add-related-content' ).on( 'click', function() {
                var baseURL = '#event.buildLink( prc.xehRelatedContentSelector )#';
                var excludeIDs = $( 'input[name=relatedContentIDs]' ).map( function(){
                    return $( this ).val();
                }).get();
                if( excludeIDs.length ) {
                    baseURL += '?excludeIDs=' + excludeIDs.join( ',' );
                }
                openRemoteModal( baseURL );
            });
            $( '##relatedContent-items' ).on( 'click', '.btn', function(){
                $( this ).closest( 'tr' ).remove();
                toggleWarningMessage();
            });
            toggleWarningMessage();
        });
        function toggleWarningMessage() {
            var table = $( '##relatedContent-items' ),
                warning = $( '##related-content-empty' );
            if( table.find( 'tr' ).length ) {
                warning.hide();
                table.show();
            }
            else {
                table.hide();
                warning.show();
            }
        }
        function chooseRelatedContent( id, title, type ) {
            var table = $( '##relatedContent-items' ),
                warning = $( '##related-content-empty' ),
                template = [
                    '<tr id="content_{0}" class="related-content">',
                        '<td width="14" class="center">{1}</td>',
                        '<td>{2}</td>',
                        '<td width="14" class="center">',
                            '<button class="btn btn-tiny btn-danger" type="button"><i class="icon-minus" title="Remove Related Content"></i></button>',
                            '<input type="hidden" name="relatedContentIDs" value="{0}" />',
                        '</td>',
                    '</tr>'
                ].join( ' ' ),
                params = [ id, getIconByContentType( type ), title ];

            table.find( 'tbody:last' ).append( $.validator.format( template, params ) );
            toggleWarningMessage();
            closeRemoteModal();
            return false;
        }
        function getIconByContentType( type ) {
            var icon = '';
            switch( type ) {
                case 'Page':
                    icon = '<i class="icon-file-alt icon-small" title="Page"></i>';
                    break;
                case 'Entry':
                    icon = '<i class="icon-quote-left icon-small" title="Entry"></i>';
                    break;
            }
            return icon;
        }
    </script>
    <button class="btn btn-small btn-success" type="button" id="add-related-content">
        <i class="icon-plus"></i>  Add related content
    </button>
    <br /><br />
    <table class="table table-hover table-bordered table-striped" id="relatedContent-items">
        <tbody>
            <cfloop array="#args.relatedContent#" index="content">
                <cfset publishedClass = content.isContentPublished() ? "published" : "selected">
                <cfset publishedTitle = content.isContentPublished() ? "" : "Content is not published!">
                <tr id="content_#content.getContentID()#" class="related-content" title="#publishedTitle#">
                    <td width="14" class="center #publishedClass#">
                        <cfif content.getContentType() eq "Page">
                            <i class="icon-file-alt icon-small" title="Page"></i>
                        <cfelseif content.getContentType() eq "Entry">
                            <i class="icon-quote-left icon-small" title="Entry"></i>
                        </cfif>
                    </td>
                    <td class="#publishedClass#">#content.getTitle()#</td>
                    <td width="14" class="center #publishedClass#">
                        <button class="btn btn-tiny btn-danger" type="button"><i class="icon-minus" title="Remove Related Content"></i></button>
                        <input type="hidden" name="relatedContentIDs" value="#content.getContentID()#" />
                    </td>
                </tr>
            </cfloop>
        </tbody>
    </table>
    <div id="related-content-empty" class="alert alert-info">No content has been related!</div>
</cfoutput>