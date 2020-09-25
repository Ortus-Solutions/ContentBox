<cfoutput>
    <div class="modal-dialog modal-lg" role="document" >
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4><span id="widget-title-bar"><i class="fa fa-image fa-lg fa-2x"></i> Image editor</span></h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-12">
                        <h1>File Info</h1>
                        <ul>
                        <cfloop collection="#prc.fileInfo#" item="myKey">
                            <li><b>#myKey#</b>: #prc.fileInfo[myKey]#</li>
                        </cfloop>
                        </ul>
                        <h1>Image Info</h1>
                        <cfif structKeyExists( prc, "imgInfo" )>
                        #parseStruct(prc.ImgInfo)#
                        </cfif>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <div class="widget-footer-right">
                        <a id="widget-button-cancel" href="javascript:void(0);" class="btn btn-default" onclick="closeRemoteModal()">Close</a>
                </div>
            </div>
        </div>
    </div>
</cfoutput>
<cfscript>
function parseStruct( data ){
    if( isSimpleValue( arguments.data ) ){
        return arguments.data;
    }
    if( isDate( arguments.data ) ){
        return dateFormat( arguments.data );
    }
    if( isArray( arguments.data) ){
        return arrayToList( arguments.data );
    }
    if( isStruct( arguments.data) ){

        var newList = "<ul>";

        for( var k in arguments.data ){
            newList &= "<li><b>" & k & "</b>: " & parseStruct( arguments.data[ k ] ) & "</li>";
        }
        return "#newList#</ul>";
    }

}
</cfscript>