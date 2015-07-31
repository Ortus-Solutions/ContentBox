<cfparam name="cfmlPassword" default="">
<cfset results = request.cfHelper.verifyCFMLAdmin( cfmlPassword )>
<cfsetting showdebugoutput="false" >
<cfcontent reset="true" type="application/json">
<cfoutput>#serializeJSON( results )#</cfoutput>