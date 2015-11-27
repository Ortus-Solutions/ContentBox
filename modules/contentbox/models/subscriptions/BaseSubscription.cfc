/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* I am an Abstract Subscription Entity
*/
component persistent="true" entityname="cbSubscription" table="cb_subscriptions" cachename="cbSubscription" cacheuse="read-write" {

    // PROPERTIES
    property name="subscriptionID" fieldtype="id" generator="native" setter="false"  params="{ allocationSize = 1, sequence = 'subscriptionID_seq' }";
    property name="subscriptionToken" notnull="true";
    property name="type" ormtype="string" notnull="true";
    property name="createdDate" notnull="true" ormtype="timestamp" update="false" default="" index="idx_subscriptionCreatedDate";

    // M20 -> Content loaded as a proxy
    property name="subscriber" notnull="true" cfc="contentbox.models.subscriptions.Subscriber" fieldtype="many-to-one" fkcolumn="FK_subscriberID" lazy="true" index="idx_subscriber" inverse="true" orderBy="subscriberEmail";
    /************************************** CONSTRUCTOR *********************************************/

    /**
    * constructor
    */
    function init(){
        createdDate = now();
    }
    /************************************** PUBLIC *********************************************/
}