<cfoutput>
    <cfset ETH = getModel( "EmailTemplateHelper@cb" )>
    #ETH.text( "
        Dear @name@,<br/>
        In order to reset your ContentBox password you must first click on the link below so we can verify you first.<br /><br />
        <a href='@linkToken@'>Click here to reset password</a>
        <br /><br />
        Reset Link: @linkToken@
    " )#
</cfoutput>