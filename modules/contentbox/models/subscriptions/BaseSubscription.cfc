/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I am an Abstract Subscription Entity
*/
component   persistent="true" 
            entityname="cbSubscription" 
            table="cb_subscriptions" 
            extends="contentbox.models.BaseEntity"
            cachename="cbSubscription" 
            cacheuse="read-write"{

    /* *********************************************************************
    **                          PROPERTIES                                  
    ********************************************************************* */

    property    name="subscriptionID" 
                fieldtype="id" 
                generator="native" 
                setter="false" 
                params="{ allocationSize = 1, sequence = 'subscriptionID_seq' }";

    property    name="subscriptionToken" 
                notnull="true";

    property    name="type" 
                ormtype="string" 
                notnull="true";

    /* *********************************************************************
    **                          RELATIONSHIPS                                    
    ********************************************************************* */
    
    // M20 -> Content loaded as a proxy
    property    name="subscriber" 
                notnull="true" 
                cfc="contentbox.models.subscriptions.Subscriber" 
                fieldtype="many-to-one" 
                fkcolumn="FK_subscriberID" 
                lazy="true" 
                index="idx_subscriber" 
                inverse="true" 
                orderBy="subscriberEmail";
    
    /* *********************************************************************
    **                          PK + CONSTRAINTS                                    
    ********************************************************************* */

    this.pk = "subscriptionID";

    this.constraints ={
        "subscriptionToken" = { required=true, size="1..255" },
        "type"              = { required=true, size="1..255" }
    };

    /* *********************************************************************
    **                          PUBLIC FUNCTIONS                                    
    ********************************************************************* */

    /**
    * Get memento representation
    * @excludes Exclude Properties
    * @showSubscriber Show the subscriber
    */
    function getMemento( excludes="", boolean showSubscriber=true ){
        var pList   = listToArray( "subscriptionToken,type" );
        var result  = getBaseMemento( properties=pList, excludes=arguments.excludes );
        
        // Subscriber
        if( arguments.showSubscriber && hasSubscriber() ){
            result[ "subscriber" ] = getSubscriber().getMemento( showSubscriptions=false );      
        } else if( arguments.showSubscriber ){
            result[ "subscriber" ] = {};            
        }

        return result;
    }

}