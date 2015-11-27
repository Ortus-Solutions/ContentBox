<cfoutput>
    <cfset ETH = getModel( "EmailTemplateHelper@cb" )>
    #ETH.author( email=args.gravatarEmail, content="
        <strong>@currentAuthor@</strong> created a new user:<br /> <a href='@authorURL@'>@authorName@<a/>
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