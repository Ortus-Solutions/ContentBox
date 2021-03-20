<cfoutput>
<div class="container">
    <h1>Manage My Subscriptions</h1>

    <!--- MessageBox --->
    #cbMessageBox().renderit()#

    <cfif prc.oSubscriber.isLoaded()>
        <cfif structCount( prc.subscriptions )>
            <form name="removeSubscriptions" action="#event.buildLink( to='__removesubscriptions' )#" method="POST" onsubmit="return onSubmitHandler();">

                <cfloop collection="#prc.subscriptions#" item="type">
                    <!---<h2>#type# Subscriptions</h2>---->
                    <cfset aSubscriptions = prc.subscriptions[ type ]>
                    <table cellpadding="10" cellspacing="0" class="table table-hover table-striped table-condensed">
                        <cfloop array="#aSubscriptions#" index="subscription">
                            <tr>
                                <td>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" value="#subscription.subscriptionToken#" name="keysToRemove" />
                                            #subscription.title#
                                        </label>
                                    </div>
                                </td>
                            </tr>
                        </cfloop>
                    </table>
                </cfloop>

                <div class="well well-sm text-center">
                    <input type="hidden" name="subscriberToken" value="#encodeForHTMLAttribute( rc.subscriberToken )#" />
                    <input type="submit" class="btn btn-primary" value="Remove Selected" name="removeSelected" />
                </div>
            </form>
        <cfelse>
            <!--- MessageBox --->
            <div class="alert alert-warning">You don't currently have any active subscriptions</div>
        </cfif>

     </cfif>
</div>
</cfoutput>
