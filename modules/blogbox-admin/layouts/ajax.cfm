<cfsetting showdebugoutput="false">
<cfset event.showDebugPanel(false)>
<cfcontent reset="true">
<cfoutput>#renderView()#</cfoutput>