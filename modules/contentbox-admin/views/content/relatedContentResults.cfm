<cfoutput>
<!--- entries --->
<table name="content" id="entries" class="tablesorter table table-hover table-striped table-condensed" width="98%">
    <thead>
        <tr>
            <th width="40" class="center"><i class="icon-file icon-large" title="Content Type"></i></th>
            <th>Content Title</th>
            <th width="40" class="center"><i class="icon-globe icon-large"></i></th>
            <th width="120" class="center">Select</th>
        </tr>
    </thead>
    <tbody>
        <cfloop array="#prc.content#" index="content">
        <tr id="contentID-#content.getContentID()#" <cfif NOT content.getIsPublished()>class="warning"</cfif>>
            <td class="center">
                #content.getContentType()#
            </td>
            <td>
                <!--- Title --->
                <strong>#content.getTitle()#</strong>
                <br>
                <span class="label">Published: #content.getDisplayPublishedDate()#</label>
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
                <button class="btn" onclick="return chooseRelatedContent( #content.getContentID()#,'#content.getTitle()#','#content.getContentType()#' )" title="Link"><i class="icon-check icon-large"></i></button>
                </div>
            </td>
        </tr>
        </cfloop>
    </tbody>
</table>

<!--- Paging --->
#prc.pagingPlugin.renderit( foundRows=prc.contentCount, link=prc.pagingLink, asList=true )#
</cfoutput>