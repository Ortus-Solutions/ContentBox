<cfoutput>
<cfif arrayLen( prc.content )>
    <!--- matches --->
    <table name="content" id="#rc.contentType#" class="tablesorter table table-hover table-striped table-condensed" width="98%">
        <thead>
            <tr>
                <th>Content Title</th>
                <th width="40" class="center"><i class="icon-globe icon-large" title="Published?"></i></th>
                <th width="120" class="center">Select</th>
            </tr>
        </thead>
        <tbody>
            <cfloop array="#prc.content#" index="content">
            <tr id="contentID-#content.getContentID()#" <cfif NOT content.getIsPublished()>class="warning"</cfif>
            ondblclick="return chooseRelatedContent( #content.getContentID()#,'#content.getTitle()#','#content.getContentType()#', '#content.getSlug()#' )">
                <td>
                    <!--- Title --->
                    <strong>#content.getTitle()#</strong>
                    <br>
                    <cfif content.getContentType() eq "page">
                        <span class="label label-success">#content.getSlug()#</span>
                    <cfelseif content.getContentType() eq "contentStore">
                        #content.getDescription()#
                    </cfif>
                </td>
                <td class="center">
                    <cfif content.getIsPublished()>
                        <i class="icon-ok icon-large textGreen"></i>
                        <span class="hidden">published</span>
                    <cfelse>
                        <i class="icon-remove icon-large textRed"></i>
                        <span class="hidden">draft</span>
                    </cfif>
                </td>
                <td class="center">
                    <div class="btn-group">
                    <button class="btn" onclick="return chooseRelatedContent( #content.getContentID()#,'#content.getTitle()#','#content.getContentType()#', '#content.getSlug()#' )" title="Link"><i class="icon-check icon-large"></i></button>
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