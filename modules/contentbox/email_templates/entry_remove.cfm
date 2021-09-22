<cfoutput>
    <cfset ETH = getInstance( "EmailTemplateHelper@contentbox" )>
    #ETH.author( email=args.gravatarEmail, content="
        <strong>@entryAuthor@</strong> removed a blog entry from your system
    " )#
    #ETH.divider()#
    #ETH.text( "
        <table cellpadding='3' cellspacing='3'>
            <tbody>
                <tr>
                    <td><strong>Title:</strong></td>
                    <td>@entryTitle@</td>
                </tr>
            </tbody>
        </table>
    " )#
    #ETH.divider()#
    #ETH.heading( content="Excerpt" )#
    #ETH.text( content="@entryExcerpt@", callout="true" )#
</cfoutput>