<cfoutput>
    <cfset ETH = getInstance( "EmailTemplateHelper@contentbox" )>
    #ETH.author( email=args.gravatarEmail, content="
        <strong>@pageAuthor@</strong> created a new page:<br /><a href='@pageURL@'>@pageTitle@</a>
    " )#
    #ETH.divider()#
    #ETH.heading( content="Page Details" )#
    #ETH.text( "
        <table cellpadding='3' cellspacing='3'>
            <tbody>
                <tr>
                    <td><strong>Title:</strong></td>
                    <td>@pageTitle@</td>
                </tr>
                <tr>
                    <td><strong>URL:</strong></td>
                    <td><a href='@pageURL@'>@pageURL@</a></td>
                </tr>
                <tr>
                    <td><strong>Published:</strong></td>
                    <td>@pageIsPublished@ on @pagePublishedDate@</td>
                </tr>
                <tr>
                    <td><strong>Expires:</strong></td>
                    <td>@pageExpireDate@</td>
                </tr>
            </tbody>
        </table>
    " )#
    #ETH.divider()#
    #ETH.heading( content="Excerpt" )#
    #ETH.text( content="@pageExcerpt@", callout="true" )#
</cfoutput>