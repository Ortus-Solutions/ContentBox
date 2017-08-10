<cfoutput>
    <cfset ETH = getModel( "EmailTemplateHelper@cb" )>
    #ETH.text( "
        <p>Dear @name@</p>

        <p>
			Your account password at <em>@siteName@</em> has been reset from the following IP Address: <strong>@ip@</strong>
        </p>

        <p>&nbsp;</p>
	
		<p>
			If this reset was not issued by you then please contact your system administrator <a href='mailto:@adminEmail@'>@adminEmail@</a>
		</p>

    " )#
</cfoutput>