<cfoutput>
    <cfset ETH = getInstance( "EmailTemplateHelper@contentbox" )>
    #ETH.author( email=args.gravatarEmail, content="
        <strong>@contentAuthor@</strong> removed a content store object from your system
    " )#
    #ETH.divider()#
    #ETH.heading( content="Content Store Object Details" )#
    #ETH.text( "
        <table cellpadding='3' cellspacing='3'>
            <tbody>
                <tr>
                    <td><strong>Title:</strong></td>
                    <td>@contentTitle@</td>
                </tr>
                <tr>
                    <td><strong>Description:</strong></td>
                    <td>@contentDescription@</td>
                </tr>
            </tbody>
        </table>
    " )#
    #ETH.divider()#
    #ETH.heading( content="Excerpt" )#
    #ETH.text( content="@contentExcerpt@", callout="true" )#
</cfoutput>