<cfoutput>
    <cfset ETH = getInstance( "EmailTemplateHelper@contentbox" )>
    #ETH.author( email=args.gravatarEmail, content="
        <strong>@entryAuthor@</strong> created a new blog entry:<br /><a href='@entryURL@'>@entryTitle@</a>
    " )#
    #ETH.divider()#
    #ETH.heading( content="Entry Details" )#
    #ETH.text( "
        <table cellpadding='3' cellspacing='3'>
            <tbody>
                <tr>
                    <td><strong>Title:</strong></td>
                    <td>@entryTitle@</td>
                </tr>
                <tr>
                    <td><strong>URL:</strong></td>
                    <td><a href='@entryURL@'>@entryURL@</a></td>
                </tr>
                <tr>
                    <td><strong>Published:</strong></td>
                    <td>@entryIsPublished@ on @entryPublishedDate@</td>
                </tr>
                <tr>
                    <td><strong>Expires:</strong></td>
                    <td>@entryExpireDate@</td>
                </tr>
            </tbody>
        </table>
    " )#
    #ETH.divider()#
    #ETH.heading( content="Excerpt" )#
    #ETH.text( content="@entryExcerpt@", callout="true" )#
</cfoutput>