<cfoutput>
    <!--- MessageBox --->
    <cfif flash.exists( "notice" )>
        <div class="alert alert-#flash.get( 'notice' ).type#">#flash.get( 'notice' ).message#</div>
    </cfif>
    
    <cfif structKeyExists( prc, "subscriptions" ) AND structCount( prc.subscriptions )>
        <a href="#event.buildLink( linkto='__subscriptions/#prc.subscriberToken#' )#">Manage My Subscriptions</a>
    </cfif>
</cfoutput>