<cfoutput>
    <h2>Manage My Subscriptions</h2>
    <!--- MessageBox --->
    #getPlugin("MessageBox").renderit()#
    <cfif structCount( prc.subscriptions )>
        <form name="removeSubscriptions" action="#event.buildLink( linkto='__removesubscriptions' )#" method="POST" onsubmit="return onSubmitHandler();">
            <cfloop collection="#prc.subscriptions#" item="type">
                <!---<h2>#type# Subscriptions</h2>---->
                <cfset subs = prc.subscriptions[ type ]>
                <table cellpadding="10" cellspacing="0" border="0">
                    <cfloop array="#subs#" index="subscription">
                        <tr>
                            <td>#subscription.title#</td>
                            <td width="30" align="center"><input type="checkbox" value="#subscription.subscriptionToken#" name="keysToRemove" /></td>
                        </tr>
                    </cfloop>
                </table>
            </cfloop>
            <input type="hidden" name="subscriberToken" value="#rc.subscriberToken#" />
            <input type="submit" value="Remove Selected" name="removeSelected" />
        </form>
    <cfelse>
        <!--- MessageBox --->
        #getPlugin("MessageBox").info( "You don't currently have any active subscriptions." )#
    </cfif>
</cfoutput>
