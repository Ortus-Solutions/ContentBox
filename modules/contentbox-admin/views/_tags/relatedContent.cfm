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
            <cfif structKeyExists( rc, "contentID" ) and len( rc.contentID )>
                var currentContentID = #rc.contentID#;
            </cfif>
            // listener for add button
            $( '##add-related-content' ).on( 'click', function() {
                var baseURL = '#event.buildLink( prc.xehShowRelatedContentSelector )#';
                // build up list of excluded IDs
                var excludeIDs = $( 'input[name=relatedContentIDs]' ).map( function(){
                    return $( this ).val();
                } ).get();
                if( typeof currentContentID !== 'undefined' ) {
                    excludeIDs.push( currentContentID );
                }
                if( excludeIDs.length ) {
                    baseURL += '?excludeIDs=' + excludeIDs.join( ',' );
                }
                openRemoteModal( baseURL, {}, 900, 600 );
            } );
            // remove relatedContent listener
            $( '##relatedContent-items' ).on( 'click', '.btn', function(){
                // remove row
                $( this ).closest( 'tr' ).remove();
                // evaluate if we need to modify the view of the row
                toggleWarningMessage();
            } );
            toggleWarningMessage();
        } );
        /**
         * Looks at table content to see if we need to hide the table and display a "no content" message or not
         */
        function toggleWarningMessage() {
            var table = $( '##relatedContent-items' ),
                warning = $( '##related-content-empty' );
            // if not empty...
            if( table.find( 'tr' ).length ) {
                warning.hide();
                table.show();
            }
            // otherwise, there's nothing there!
            else {
                table.hide();
                warning.show();
            }
        }
        /**
         * Handler for selection of related content in modal
         * @param {Number} id The content's id
         * @param {String} title The title of the content
         * @param {String} type The content type
         */
        function chooseRelatedContent( id, title, type ) {
            var table = $( '##relatedContent-items' ),
                warning = $( '##related-content-empty' ),
                template = [
                    '<tr id="content_{0}" class="related-content">',
                        '<td width="14" class="text-center">{1}</td>',
                        '<td>{2}</td>',
                        '<td width="14" class="text-center">',
                            '<button class="btn btn-xs btn-danger" type="button"><i class="fa fa-minus" title="Remove Related Content"></i></button>',
                            '<input type="hidden" name="relatedContentIDs" value="{0}" />',
                        '</td>',
                    '</tr>'
                ].join( ' ' ),
                params = [ id, getIconByContentType( type ), title ];
            // add to table
            table.find( 'tbody:last' ).append( $.validator.format( template, params ) );
            toggleWarningMessage();
            closeRemoteModal();
            return false;
        }
        /**
         * Helper for figuring out the correct icon based on content type
         * @param {String} type The type of the content
         */
        function getIconByContentType( type ) {
            var icon = '';
            switch( type ) {
                case 'Page':
                    icon = '<i class="fa fa-file icon-small" title="Page"></i>';
                    break;
                case 'Entry':
                    icon = '<i class="fa fa-quote-left icon-small" title="Entry"></i>';
                    break;
                case 'ContentStore':
                    icon = '<i class="fa fa-hdd-o icon-small" title="ContentStore"></i>';
                    break;
            }
            return icon;
        }
    </script>
    <button class="btn btn-sm btn-success" type="button" id="add-related-content">
        <i class="fa fa-plus"></i>  Add related content
    </button>
    <br /><br />
    <table class="table table-hover table-striped" id="relatedContent-items">
        <tbody>
            <cfloop array="#args.relatedContent#" index="content">
                <cfset publishedClass = content.isContentPublished() ? "published" : "selected">
                <cfset publishedTitle = content.isContentPublished() ? "" : "Content is not published!">
                <tr id="content_#content.getContentID()#" class="related-content" title="#publishedTitle#">
                    <td width="14" class="center #publishedClass#">
                        <cfif content.getContentType() eq "Page">
                            <i class="fa fa-file icon-small" title="Page"></i>
                        <cfelseif content.getContentType() eq "Entry">
                            <i class="fa fa-quote-left icon-small" title="Entry"></i>
                        <cfelseif content.getContentType() eq "ContentStore">
                            <i class="fa fa-hdd-o icon-small" title="ContentStore"></i>
                        </cfif>
                    </td>
                    <td class="#publishedClass#">#content.getTitle()#</td>
                    <td width="14" class="center #publishedClass#">
                        <button class="btn btn-xs btn-danger" type="button"><i class="fa fa-minus" title="Remove Related Content"></i></button>
                        <input type="hidden" name="relatedContentIDs" value="#content.getContentID()#" />
                    </td>
                </tr>
            </cfloop>
        </tbody>
    </table>
    <div id="related-content-empty" class="alert alert-info">No content has been related!</div>
</cfoutput>