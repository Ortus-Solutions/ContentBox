<cfoutput>
    <cfset ETH = getInstance( "EmailTemplateHelper@contentbox" )>
    #ETH.author( email=args.gravatarEmail, content="
        <strong>@author@</strong> has added a new comment for:<br /> <a href='@contentURL@'>@contentTitle@<a/>
    " )#
    #ETH.heading( content="Comment" )#
    #ETH.text( content="@content@", callout="true" )#
    #ETH.text( "
        Don't want to receive email notifications about new comments to this content? No problem! <a href='@unsubscribeURL@'>Click here to unsubscribe</a>.
    " )#
</cfoutput>