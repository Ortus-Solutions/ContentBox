/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I am a Subscriber Entity
*/
component persistent="true" entityname="cbSubscriber" table="cb_subscribers" cachename="cbSubscriber" cacheuse="read-write" {

    // PROPERTIES
    property name="subscriberID" fieldtype="id" generator="native" setter="false"  params="{ allocationSize = 1, sequence = 'subscriberID_seq' }";
    property name="subscriberEmail" notnull="true" length="255" index="idx_subscriberEmail";
    property name="subscriberToken" notnull="true";
    property name="createdDate" notnull="true" ormtype="timestamp" update="false" default="" index="idx_subscriberCreatedDate";

    property name="subscriptions" singularName="subscription" fieldtype="one-to-many" type="array" lazy="extra" batchsize="25" orderby="createdDate" cfc="contentbox.models.subscriptions.BaseSubscription" fkcolumn="FK_subscriberID" inverse="true" cascade="all-delete-orphan";
    /************************************** CONSTRUCTOR *********************************************/

    /**
    * constructor
    */
    function init(){
        createdDate = now();
    }

    /************************************** PUBLIC *********************************************/

    public void function preInsert() {
        if( isNull( getSubscriberToken() ) ) {
            var tkn = getSubscriberEmail() & getCreatedDate();
            setSubscriberToken( hash( tkn ) );
        }
    }

    /**
    * is loaded?
    */
    boolean function isLoaded(){
        return ( len( getSubscriberID() ) ? true : false );
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
