/**
********************************************************************************
ContentBox - A Modular Content Platform
Copyright 2012 by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
Apache License, Version 2.0

Copyright Since [2012] [Luis Majano and Ortus Solutions,Corp] 

Licensed under the Apache License, Version 2.0 (the "License" );
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, software 
distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and 
limitations under the License.
********************************************************************************
* Handles subscriptions
*/
component singleton{

    // DI
    property name="subscriberService" inject="subscriberService@cb";
    property name="subscriptionService"  inject="id:subscriptionService@cb";

    public function removeSubscriptions( required any event, required struct rc, required struct prc ) {
        event.paramValue( "keysToRemove", "" );
        event.paramValue( "subscriberToken", "" );
        // check to make sure that at least one subscription AND subscriber token are found
        if( len( rc.keysToRemove ) && len( rc.subscriberToken ) ) {
            // try to find subscriber by token
            var criteria = { "subscriberToken"=rc.subscriberToken };
            var subscriber = subscriberService.findWhere( criteria=criteria );
            if( !isNull( subscriber ) ) {
                var targets = listToArray( rc.keysToRemove );
                // loop over remove targers
                for( var i=1; i<=arrayLen( targets ); i++ ) {
                    var deleteCriteria = { "subscriptionToken"=targets[ i ] };
                    subscriptionService.deleteWhere( subscriptionToken = targets[ i ] );
                }
                
                messagebox.info( "Your subscriptions were successfully updated!" );
                setNextEvent( "__subscriptions/#rc.subscriberToken#" );
            } else {
                messagebox.error( "Sorry, we couldn't complete your request. Please try again." );
            }
        } else {
            messagebox.warn( "Sorry, we couldn't complete your request. Please try again." );
        }
        setNextEvent( "/" );
    }

    public function getSubscriptions( required any event, required struct rc, required struct prc ) {
        event.paramValue( "subscriberToken", "" );
        if( len( rc.subscriberToken ) ) {
            // get subscriber
            var criteria = { "subscriberToken"=rc.subscriberToken };
            var subscriber = subscriberService.findWhere( criteria=criteria );
            if( !isNull( subscriber ) ) {
                prc.subscriptions = subscriber.getSubscriptionsByContentType();
            }
        }
        event.setLayout( name="#prc.cbTheme#/layouts/pages", module="contentbox" )
             .setView( view="subscription/subscriptions" );
    }

    /**
     * Unsubscribe from comment notifications
     */
    public function unsubscribe( event, rc, prc ) {
        var criteria = { subscriptionToken = rc.subscriptionToken };
        var subscription = subscriptionService.findWhere( criteria=criteria );
        // if we find a match...
        if( !isNull( subscription ) ) {
            var subscriber = subscription.getSubscriber();
            // delete it
            subscriptionService.delete( subscription );
            messagebox.warn( "You have been succssfully unsubscribed!" );
            // see if subscriber has others; if so, we can provide a handy link to managing their other subs
            prc.subscriberToken = subscriber.getSubscriberToken();
            prc.subscriptions = subscriber.getSubscriptionsByContentType();
        } else {
            messagebox.warn( "Sorry, your request could not be completed." );
        }
        event.setLayout( name="#prc.cbTheme#/layouts/pages", module="contentbox" )
             .setView( view="subscription/unsubscribe" );
    }
}