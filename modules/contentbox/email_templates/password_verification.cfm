<cfoutput>
    <cfset ETH = getInstance( "EmailTemplateHelper@contentbox" )>
    #ETH.text( "
        <p>Dear @name@,</p>

        <p>
        A password reset has been issued for your <em>@siteName@</em> account from the following IP Address: <strong>@ip@</strong>.
        Please follow the link below to reset your account password.
        Please note that your link below will only be active for the next @linkTimeout@ minutes.<br /><br />
        <a href='@linkToken@'>Click here to reset password</a>
        </p>

        <p>Reset Link: @linkToken@</p>
    " )#
</cfoutput>
