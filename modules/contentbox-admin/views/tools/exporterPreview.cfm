<cfoutput>
    <h4>Here is a preview of your super-awesome ContentBox export!</h4>
    <table class="table table-bordered table-hover">
        <tr>
            <th>Content Area</th>
            <th class='text-center'>Format</th>
            <th class='text-center'>Total</th>
        </tr>
        <cfloop array="#prc.aSortedContent#" index="key">
            <cfset content = prc.descriptor.content[ key ]>
            <tr>
                <td>#content.name#</td>
                <cfset formatlabel = content.format eq "json" ? "label label-primary" : "label label-info">
                <td class="text-center"><span class="#formatlabel#">#content.format#</span></td>
                <td class="text-center"><span class="badge">#content.total#</div></td>
            </tr>
        </cfloop>
    </table>
</cfoutput>