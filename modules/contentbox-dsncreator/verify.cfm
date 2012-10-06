<cfparam name="dsnName" default="">
<cfset results = { error = false, messages = "" }>
	<cftry>
		<cfdbinfo type="version" name="dbResults" datasource="#dsnName#">
		<cfset results.messages = "Datasource verified">
		<cfcatch type="any">
			<cfset results.error = true>
			<cfset results.messages = "#cfcatch.message# #cfcatch.detail#">
		</cfcatch>
	</cftry>
<cfsetting showdebugoutput="false" >
<cfcontent reset="true" type="application/json">
<cfoutput>#serializeJSON( results )#</cfoutput>