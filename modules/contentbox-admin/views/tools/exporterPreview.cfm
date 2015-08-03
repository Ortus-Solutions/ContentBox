<cfoutput>
    <h4>Here is a preview of your super-awesome ContentBox export!</h4>
    <table class="table table-bordered">
        <tr>
            <th>Content Area</th>
            <th>Format</th>
            <th>Total</th>
        </tr>
        <cfset sortedContent = structSort( prc.descriptor.content, "text", "asc", "name" )>
        <cfloop array="#sortedContent#" index="key">
            <cfset content = prc.descriptor.content[ key ]>
            <tr>
                <td>#content.name#</td>
                <cfset formatlabel = content.format eq "json" ? "label label-info" : "label label-warning">
                <td><span class="#formatlabel#">#content.format#</span></td>
                <td><span class="badge">#content.total#</div></td>
            </tr>
        </cfloop>
    </table>
</cfoutput>