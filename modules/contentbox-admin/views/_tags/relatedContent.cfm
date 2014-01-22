<cfoutput>
    <style>
        .btn-tiny {
            padding: 0 3px;
            font-size: 9.5px;
            line-height:14px;
        }
    </style>
    <script>
        $(document).ready(function() {
            // listener for add button
            $( '##add-related-content' ).on( 'click', function() {
                openRemoteModal( '#event.buildLink( prc.xehRelatedContentSelector )#' );
            });
        });
        function chooseRelatedContent( id, title, type ) {
            var table = $( '##relatedContent-items' ),
                template = '<tr><td width="14" class="center">{0}</td><td>{1}</td><td width="14" class="center"><button class="btn btn-tiny btn-danger" type="button"><i class="icon-minus"></i></button></td>',
                params = [ getIconByContentType( type ), title ];

            table.find( 'tbody:last' ).append( $.validator.format( template, params ) );
            return false;
        }
        function getIconByContentType( type ) {
            var icon = '';
            switch( type ) {
                case 'Page':
                    icon = '<i class="icon-plus icon-small"></i>';
                    break;
                case 'Entry':
                    icon = '<i class="icon-plus icon-small"></i>';
                    break;
            }
            return icon;
        }
    </script>
    <button class="btn btn-tiny btn-success" type="button" id="add-related-content">
        <i class="icon-plus icon-small"></i>
    </button>
    <table class="table table-hover table-bordered table-striped" id="relatedContent-items">
        <tbody>
            <cfloop array="#args.relatedContent#" index="content">
                <tr id="content_#content.getContentID()#">
                    <td></td>
                    <td>#content.getTitle()#</td>
                    <td>
                        <button class="btn btn-tiny btn-danger" type="button"><i class="icon-minus"></i></button>
                    </td>
                </tr>
            </cfloop>
            <!---<tr>
                <td><i class="icon-plus"></td>
                <td width="90%">Testing Child Pages</td>
                <td>
                    <button class="btn btn-tiny btn-danger" type="button"><i class="icon-minus"></i></button>
                </td>
            </tr>--->
        </tbody>
    </table>
    <div id="related-content-empty" class="alert alert-info">No content has been related yet!</div>
</cfoutput>