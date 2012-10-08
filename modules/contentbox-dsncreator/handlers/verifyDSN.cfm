<cfparam name="dsnName" default="">
<cfset results = request.cfHelper.verifyDSN( dsnName )> 
<cfsetting showdebugoutput="false" >
<cfcontent reset="true" type="application/json">
<cfoutput>#serializeJSON( results )#</cfoutput>