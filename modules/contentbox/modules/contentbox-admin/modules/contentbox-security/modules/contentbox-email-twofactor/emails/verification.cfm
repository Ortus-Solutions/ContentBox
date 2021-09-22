<cfoutput>
    <cfset ETH = getInstance( "EmailTemplateHelper@contentbox" )>
    #ETH.text( "
        <p>Dear @name@,</p>

        <p>
            Your <em>@siteName@</em> account was just used to sign in from the following IP Address: <strong>@ip@</strong>.
        </p>

        <p>
            Your account requires a two-factor authentication code in order to allow you to sign-in.  Please use the verification code
            below in order to allow you to access your account.
        </p>

        <p style='border: 2px solid gray; padding: 20px; text-align:center; background-color: greenyellow'>
            <strong>Verification Code: <br> @token@</strong>
        </p>

        <p style='text-align: center'>
            <strong>Please note that this code is only valid for the next @tokenTimeout@ minutes</strong>
        </p>
    " )#
</cfoutput>
