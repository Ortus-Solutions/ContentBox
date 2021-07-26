<cfoutput>
    <cfset ETH = getInstance( "EmailTemplateHelper@contentbox" )>
    #ETH.text( "
        <p>Dear @name@,</p>

        <p>
            A new <em>@siteName@</em> account has been created for you with username <strong>@username@</strong>.
        </p>

        <p>
            Please follow the link below to reset your account password and finalize the creation of your new account.
            Please note that your link below will only be active for the next @linkTimeout@ minutes.<br /><br />
            <a href='@linkToken@'>Click here to reset your password</a>
        </p>

        <p>Reset Link: @linkToken@</p>

        <div style='padding:20px; margin:20px; background-color: ##f2dede; border: 1px dotted gray;clear:both'>
            If your reset token expires, you can start the reset process yet again by
            following the reset password link: <a href='@resetLink@'>Reset Password</a> and entering your
            account email: <strong>@email@</strong>.
        </div>
    " )#
</cfoutput>
