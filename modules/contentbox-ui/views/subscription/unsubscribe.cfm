<cfoutput>
    <!--- MessageBox --->
    #getPlugin("MessageBox").renderit()#
    <cfif structKeyExists( prc, "subscriptions" ) AND structCount( prc.subscriptions )>
        <a href="#event.buildLink( linkto='__subscriptions/#prc.subscriberToken#' )#">Manage My Subscriptions</a>
    </cfif>
</cfoutput>