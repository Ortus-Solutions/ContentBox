<cfoutput>
<cfif arrayLen( prc.content )>
    <!--- matches --->
    <table name="content" id="#rc.contentType#" class="tablesorter table table-hover table-striped table-condensed" width="98%">
        <thead>
            <tr class="info">
                <th>Content Title</th>
                <th width="40" class="text-center"><i class="fa fa-globe icon-large"></i></th>
                <th width="120" class="text-center">Select</th>
            </tr>
        </thead>
        <tbody>
            <cfloop array="#prc.content#" index="content">
            <tr id="contentID-#content.getContentID()#" <cfif NOT content.getIsPublished()>class="warning"</cfif>>
                <td>
                    <!--- Title --->
                    <strong>#content.getTitle()#</strong>
                    <br>
                    <span class="label label-primary">Published: #content.getDisplayPublishedDate()#</span>
                </td>
                <td class="text-center">
                    <cfif content.getIsPublished()>
                        <i class="fa fa-check icon-large textGreen"></i>
                        <span class="hidden">published</span>
                    <cfelse>
                        <i class="fa fa-remove icon-large textRed"></i>
                        <span class="hidden">draft</span>
                    </cfif>
                </td>
                <td class="text-center">
                    <div class="btn-group">
                        <button class="btn btn-sm btn-success" onclick="return chooseRelatedContent( #content.getContentID()#,'#content.getTitle()#','#content.getContentType()#', '#content.getSlug()#' )" title="Link">
                            <i class="fa fa-check icon-large"></i>
                        </button>
                    </div>
                </td>
            </tr>
            </cfloop>
        </tbody>
    </table>
<cfelse>
    <div class="alert alert-block">
        <h4>Sorry!</h4>
        <p>No results were found matching your search.</p>
    </div>
</cfif>
<!--- Paging --->
#prc.pagingPlugin.renderit( foundRows=prc.contentCount, link=prc.pagingLink, asList=true )#
</cfoutput>