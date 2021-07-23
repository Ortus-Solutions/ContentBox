<cfoutput>
    <cfset ETH = getInstance( "EmailTemplateHelper@contentbox" )>
    #ETH.author( email=args.gravatarEmail, content="
        <strong>@currentAuthor@</strong> removed an author from your system
    " )#
    #ETH.divider()#
    #ETH.heading( content="Author Details" )#
    #ETH.text( "
        <table cellpadding='3' cellspacing='3'>
            <tbody>
                <tr>
                    <td><strong>Author:</strong></td>
                    <td>@authorName@</td>
                </tr>
                <tr>
                    <td><strong>Author Email:</strong></td>
                    <td>@authorEmail@</td>
                </tr>
                <tr>
                    <td><strong>Author Role:</strong></td>
                    <td>@authorRole@</td>
                </tr>
            </tbody>
        </table>
    " )#
</cfoutput>