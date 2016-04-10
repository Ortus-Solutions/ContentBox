<cfoutput>
<div class="modal-dialog modal-lg" role="document" >
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h3><i class="fa fa-sitemap"></i> Select Related Content</h3>
        </div>
        <div class="modal-body">
        #html.startForm(name="relatedContentSelectorForm" )#

            <!--- Loader --->
            <div class="loaders floatRight" id="relatedContentSelectorLoader">
                <i class="fa fa-spinner fa-spin fa-lg"></i>
            </div>

            <!--- Content Bar --->
            <div class="form-group">
                #html.label(field="contentSearch",content="Quick Search:",class="inline" )#
                #html.textField(name="contentSearch",size="30",class="form-control",value=rc.search)#
            </div>

            <!--- Render tables out --->
            <div id="contentContainer" class="tab-wrapper tab-top tab-primary">
                <ul class="nav nav-tabs" id="contentTypes">
                    <!---loop over content types--->
                    <cfset types = listToArray( rc.contentType )>
                    <cfloop from="1" to="#arrayLen( types )#" index="i">
                        <cfset ct = types[ i ]>
                        <li <cfif i eq 1> class="active"</cfif>>
                            <a href="###ct#" data-toggle="tab"><i class="#getContentTypeIconCls( ct )# icon-small" title="#ct#"></i> #ct#</a>
                        </li>
                    </cfloop>
                </ul>
                <div class="tab-content">
                    <cfloop from="1" to="#arrayLen( types )#" index="i">
                        <cfset ct = types[ i ]>
                        <div class="tab-pane fade<cfif i eq 1> active in</cfif>" id="#ct#"></div>
                    </cfloop>
                    <!---<div class="tab-pane fade active in" id="Page"></div>
                    <div class="tab-pane fade" id="Entry"></div>
                    <div class="tab-pane fade" id="ContentStore"></div>--->
                </div>
            </div>


        #html.endForm()#
        </div>
        <!--- Button Bar --->
        <div class="modal-footer">
            <button class="btn" onclick="closeRemoteModal()"> Close </button>
        </div>
    </div>
</div>
</cfoutput>