<cfset settings = {allowDownload = true}>
<cfoutput>
	#runEvent(event='filebrowser:home.index',eventArguments={widget=true,settings=settings})#
</cfoutput>