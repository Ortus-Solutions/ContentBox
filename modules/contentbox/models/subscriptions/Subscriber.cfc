/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I am a Subscriber Entity
*/
component   persistent="true" 
            entityname="cbSubscriber" 
            table="cb_subscribers" 
            extends="contentbox.models.BaseEntity"
            cachename="cbSubscriber" 
            cacheuse="read-write"{

    /* *********************************************************************
    **                          PROPERTIES                                  
    ********************************************************************* */

    property    name="subscriberID" 
                fieldtype="id" 
                generator="native" 
                setter="false" 
                params="{ allocationSize = 1, sequence = 'subscriberID_seq' }";

    property    name="subscriberEmail" 
                notnull="true" 
                length="255" 
                index="idx_subscriberEmail";

    property    name="subscriberToken" 
                notnull="true";

    /* *********************************************************************
    **                          RELATIONSHIPS
    ********************************************************************* */

    property    name="subscriptions" 
                singularName="subscription" 
                fieldtype="one-to-many" 
                type="array" 
                lazy="extra" 
                batchsize="25" 
                orderby="createdDate" 
                cfc="contentbox.models.subscriptions.BaseSubscription" 
                fkcolumn="FK_subscriberID" 
                inverse="true" 
                cascade="all-delete-orphan";
    
    /* *********************************************************************
    **                          PK + CONSTRAINTS                                    
    ********************************************************************* */

    this.pk = "subscriberID";

    this.constraints ={
        "subscriptionToken" = { required=true, size="1..255" },
        "subscriberEmail"   = { required=true, size="1..255", type="email" }
    };

    /* *********************************************************************
    **                          PUBLIC FUNCTIONS                                    
    ********************************************************************* */

    /**
    * Get memento representation
    * @excludes Property excludes
    * @showSubscriptions Show the subscriptions
    */
    function getMemento( excludes="", boolean showSubscriptions=true ){
        var pList   = listToArray( "subscriberEmail,subscriberToken" );
        var result  = getBaseMemento( properties=pList, excludes=arguments.excludes );

        // subscriptions
        if( arguments.showSubscriptions && hasSubscription() ){
            result[ "subscriptions" ] = [];   
            for( var thisSub in variables.subscriptions ){
                result[ "subscriptions" ].append( thisSub.getMemento( showSubscriber=false ) );
            }
        } else if ( arguments.showSubscriptions ){
            result[ "subscriptions" ] = [];   
        }
        
        return result;
    }


    public void function preInsert() {
        super.preInsert();
        if( isNull( getSubscriberToken() ) ) {
            var tkn = getSubscriberEmail() & getCreatedDate();
            setSubscriberToken( hash( tkn ) );
        }
    }

    /**
    * Returns a slim representation of subscriptions by type
    */
    public struct function getSubscriptionsByContentType() {
        var subs = {};
        for( var subscription in getSubscriptions() ) {
            var contentType = subscription.getType();
            if( !structKeyExists( subs, contentType ) ) {
                subs[ "#contentType#" ] = [];
            }
            var memento = {
                "subscriptionToken" = subscription.getSubscriptionToken()
            };
            switch( contentType ) {
                case "Comment":
                    memento[ "title" ] = subscription.getRelatedContent().getTitle();
                break;
            }
            arrayAppend( subs[ "#contentType#" ], memento );
        }
        return subs;
    }
}
