<cfoutput>
    <cfset ETH = getInstance( "EmailTemplateHelper@contentbox" )>
    #ETH.author( email=args.gravatarEmail, content="
        <strong>@contentAuthor@</strong> created a new content store object:<br /> <a href='@contentURL@'>@contentTitle@</a>
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
                <tr>
                    <td><strong>Published:</strong></td>
                    <td>@contentIsPublished@ on @contentPublishedDate@</td>
                </tr>
                <tr>
                    <td><strong>Expires:</strong></td>
                    <td>@contentExpireDate@</td>
                </tr>
            </tbody>
        </table>
    " )#
    #ETH.divider()#
    #ETH.heading( content="Excerpt" )#
    #ETH.text( content="@contentExcerpt@", callout="true" )#
</cfoutput>