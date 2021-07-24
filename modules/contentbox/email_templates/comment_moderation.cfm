<cfoutput>
    <cfset ETH = getInstance( "EmailTemplateHelper@contentbox" )>
    #ETH.author( email=args.gravatarEmail, content="
        <strong>@author@</strong> has posted a new, moderated comment on the page:<br /> <a href='@contentURL@'>@contentTitle@<a/>
    " )#
    #ETH.heading( content="Comment" )#
    #ETH.text( content="@content@", callout="true" )#
    #ETH.buttonBar(
        [
            {href="@approveURL@",image="ok-circle.png",text="Approve It"},
            {href="@deleteURL@",image="minus-sign.png",text="Delete It"},
            {href="@commentURL@",image="comment-alt.png",text="View Comment"}
        ]
    )#
    #ETH.heading( content="Comment Details" )#
    #ETH.text('
        <table cellpadding="3" cellspacing="3">
            <tbody>
                <tr>
                    <td><strong>Author:</strong></td>
                    <td>@author@</td>
                </tr>
                <tr>
                    <td><strong>Author Email:</strong></td>
                    <td>@AuthorEmail@</td>
                </tr>
                <tr>
                    <td><strong>Author URL:</strong></td>
                    <td><a href="@authorURL@">@authorURL@</a></td>
                </tr>
                <tr>
                    <td><strong>Author IP:</strong></td>
                    <td>@authorIP@</td>
                </tr>
                <tr>
                    <td><strong>WHOIS:</strong></td>
                    <td><a href="@whoisURL@=@authorIP@">@whoisURL@=@authorIP@</a></td>
                </tr>
            </tbody>
        </table>
    ')#
</cfoutput>