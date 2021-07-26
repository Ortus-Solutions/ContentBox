<cfoutput>
    <cfset ETH = getInstance( "EmailTemplateHelper@contentbox" )>
    #ETH.author(
        email   = args.gravatarEmail,
        content = "<strong>@currentAuthor@</strong> created a new user:<br /> <a href='@authorURL@'>@authorName@<a/>"
    )#

    #ETH.divider()#

    #ETH.heading( content="Details" )#

    #ETH.text( "
        <table cellpadding='3' cellspacing='3'>
            <tbody>
                <tr>
                    <td><strong>Name:</strong></td>
                    <td>@authorName@</td>
                </tr>
                <tr>
                    <td><strong>Email:</strong></td>
                    <td>@authorEmail@</td>
                </tr>
                <tr>
                    <td><strong>Role:</strong></td>
                    <td>@authorRole@</td>
                </tr>
                <tr>
                    <td><strong>Permission Groups:</strong></td>
                    <td>@permissionGroups@</td>
                </tr>
            </tbody>
        </table>
    " )#
</cfoutput>
