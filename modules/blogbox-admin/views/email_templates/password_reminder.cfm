<cfoutput>
Dear @name@,<br/>
A new password has been generated for you: <strong>@genPassword@</strong><br />
Please use this password with your current username and login to your account. Please update your password also.<br /><br />
<a href="#event.buildLink(rc.xehLogin)#">Click here to login</a>
<br /><br />
Login Link: #event.buildLink(rc.xehLogin)#
</cfoutput>